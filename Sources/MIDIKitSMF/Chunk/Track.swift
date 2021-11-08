//
//  Track.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
import SwiftASCII

// MARK: - Track

extension MIDI.File.Chunk {
    
    /// `MTrk` chunk type.
    public struct Track: Equatable {
        
        public static let staticIdentifier: ASCIIString = "MTrk" 
        
        internal static let chunkEnd: [MIDI.Byte] = [0xFF, 0x2F, 0x00]
        
        /// Storage for events in the track.
        public var events: [MIDI.File.Event] = []
        
        /// Instance a new empty MIDI file track.
        public init() { }
        
        public init(events: [MIDI.File.Event]) {
            
            self.events = events
            
        }
        
    }
    
}

extension MIDI.File.Chunk.Track: MIDIFileChunk {
    
    public var identifier: ASCIIString { Self.staticIdentifier }
    
}

extension MIDI.File.Chunk.Track {
    
    public init(rawBuffer: [MIDI.Byte]) throws {
        
        guard rawBuffer.count >= 8 else {
            throw MIDI.File.DecodeError.malformed(
                "There was a problem reading chunk header. Encountered end of file early."
            )
        }
        
        // track header
        
        let readChunkType = rawBuffer[0 ... 3].data
        
        guard let chunkLength = rawBuffer[4 ... 7].data.toUInt32(from: .bigEndian)?.int else {
            throw MIDI.File.DecodeError.malformed(
                "There was a problem reading chunk length."
            )
        }
        
        let chunkTypeString = ASCIIString(exactly: readChunkType) ?? "????"
        
        guard chunkTypeString == Self.staticIdentifier else {
            throw MIDI.File.DecodeError.malformed(
                "Chunk header does not contain track header identifier. Found \(chunkTypeString.stringValue.quoted) instead."
            )
        }
        
        guard rawBuffer.count >= 8 + chunkLength else {
            throw MIDI.File.DecodeError.malformed(
                "There was a problem reading track data blob. Encountered end of data early."
            )
        }
        
        try self.init(rawData: Array(rawBuffer[8 ... (8 + chunkLength)]))
        
    }
    
    /// Init from raw data block, excluding the header identifier and length
    internal init(rawData: [MIDI.Byte]) throws {
        
        // chunk data
        
        var chunkDataReader = DataReader(rawData.data)
        
        // events
        
        var eventsCounted = 0
        var endOfChunk = false
        var newEvents: [MIDI.File.Event] = []
        
        // running status
        
        var runningStatus: MIDIFileEvent?
        
        while !endOfChunk {
            eventsCounted += 1
            
            // delta time
            
            guard let eventDeltaTimeRead = chunkDataReader.nonAdvancingRead(bytes: 4)?.bytes else {
                throw MIDI.File.DecodeError.malformed(
                    "Encountered end of file early."
                )
            }
            
            guard let eventDeltaTime = MIDI.File.decodeVariableLengthValue(from: eventDeltaTimeRead) else {
                throw MIDI.File.DecodeError.malformed(
                    "Delta time variable length value could not be read and may be malformed."
                )
            }
            
            chunkDataReader.advanceBy(eventDeltaTime.byteLength)
            
            // event
            
            guard var readBuffer = chunkDataReader.nonAdvancingRead() else {
                throw MIDI.File.DecodeError.malformed(
                    "Encountered end of file early."
                )
            }
            
            // first check for end of track
            
            if readBuffer.count == Self.chunkEnd.count,
               readBuffer.bytes == Self.chunkEnd
            {
                endOfChunk = true
                break
            }
            
            // check for running status
            
            var runningStatusByte: MIDI.Byte?
            
            if let testForRunningStatusByte = readBuffer[safe: readBuffer.startIndex] {
                if testForRunningStatusByte.isContained(in: 0x00 ... 0x7F),
                   let getRunningStatusByte = runningStatus?.midi1SMFRawBytes[safe: 0]
                {
                    runningStatusByte = getRunningStatusByte
                }
            }
            
            // if running status byte is present, inject it into the byte buffer
            if let runningStatusByte = runningStatusByte {
                readBuffer.insert(runningStatusByte, at: readBuffer.startIndex)
            }
            
            // iterate through all known event initializers
            
            var foundEvent: (newEvent: MIDIFileEvent, bufferLength: Int)?
            
            for eventDef in MIDI.File.Chunk.Track.eventDecodeOrder.concreteTypes {
                if let success = eventDef.initFrom(midi1SMFRawBytesStream: readBuffer) {
                    foundEvent = success
                    break // break for-loop lazily
                }
            }
            
            if let foundEvent = foundEvent {
                // inject delta time into event
                let newEventDelta: MIDI.File.DeltaTime = .ticks(eventDeltaTime.value.uint32)
                
                // offset buffer length if runningStatusByte is present
                let chunkBufferLength = runningStatusByte != nil
                ? foundEvent.bufferLength - 1
                : foundEvent.bufferLength
                
                // add new event to new track
                newEvents.append(foundEvent.newEvent.wrapped(delta: newEventDelta))
                chunkDataReader.advanceBy(chunkBufferLength)
                
                // store event in running status
                if let testForRunningStatusByte = foundEvent.newEvent.midi1SMFRawBytes[safe: 0] {
                    if testForRunningStatusByte.isContained(in: 0x80 ... 0xEF) {
                        runningStatus = foundEvent.newEvent
                    } else if testForRunningStatusByte.isContained(in: 0xF0 ... 0xF7) {
                        runningStatus = nil
                    }
                }
                
            } else {
                // throw an error since no events could be decoded and there are still bytes remaining in the chunk
                
                let byteOffsetString = chunkDataReader.readPosition.hex
                    .stringValue(padTo: 1, prefix: true)
                
                let sampleBytes =
                (1 ... 8)
                    .reduce([MIDI.Byte]()) {
                        // read as many bytes as possible, up to range.count
                        if let getByte = chunkDataReader.nonAdvancingRead(bytes: $1) {
                            return getByte.bytes
                        }
                        return $0
                    }
                    .hex.stringValues(padTo: 2, prefixes: true)
                    .joined(separator: " ")
                
                throw MIDI.File.DecodeError.malformed(
                    "Unexpected data encountered before end of track at track data byte offset \(byteOffsetString) (\(sampleBytes) ...)."
                )
            }
        }
        
        events = newEvents
    }
    
}

extension MIDI.File.Chunk.Track {
    
    /// Raw data block, excluding the header identifier and length
    func rawData(using timing: MIDI.File.TimeBase) -> Data {
        
        var data = Data()
        
        for event in events {
            let unwrapped = event.unwrapped
            data.append(deltaTime: unwrapped.delta.ticksValue(using: timing))
            data.append(contentsOf: unwrapped.event.midi1SMFRawBytes)
        }
        
        data.append(deltaTime: 0)
        data.append(contentsOf: Self.chunkEnd)
        
        return data
        
    }
    
}

extension MIDI.File.Chunk.Track {
    
    /// Determines the order in which track raw data decoding attempts to iteratively decode events
    static let eventDecodeOrder: [MIDI.File.Event.EventType] = [
        .noteOff,
        .noteOn,
        .cc,
        .pressure,
        .pitchBend,
        .notePressure,
        .programChange,
        .keySignature,
        .smpteOffset,
        .sysEx,
        .universalSysEx,
        .text,
        .timeSignature,
        .tempo,
        .sequencerSpecific,
        .sequenceNumber,
        .channelPrefix,
        .portPrefix,
        .xmfPatchTypePrefix,
        .unrecognizedMeta // this should always be last
    ]
    
}

extension MIDI.File.Chunk.Track: CustomStringConvertible,
                                 CustomDebugStringConvertible {
    
    public var description: String {
        
        var outputString = ""
        
        outputString += "Track(".newLined
        outputString += "  events (\(events.count)): ".newLined
        
        events.forEach {
            let deltaString = $0.unwrapped.delta.description
                .padding(toLength: 15, withPad: " ", startingAt: 0)
            
            outputString += "    \(deltaString) \($0.unwrapped)".newLined
        }
        
        outputString += ")"
        
        return outputString
        
    }
    
    public var debugDescription: String {
        
        var outputString = ""
        
        outputString += "Track(".newLined
        outputString += "  events (\(events.count)): ".newLined
        
        events.forEach {
            let deltaString = $0.unwrapped.delta.debugDescription
                .padding(toLength: 15 + 11, withPad: " ", startingAt: 0)
            
            outputString += "    \(deltaString) \($0.unwrapped.event.smfDebugDescription)".newLined
        }
        
        outputString += ")"
        
        return outputString
        
    }
    
}
