//
//  Event ProgramChange.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

// MARK: - ProgramChange

extension MIDI.File.Event {
    
    public typealias ProgramChange = MIDI.Event.ProgramChange
    
}

extension MIDI.Event.ProgramChange: MIDIFileEvent {
    
    public static let smfEventType: MIDI.File.Event.EventType = .programChange
    
    public init(midi1SMFRawBytes rawBytes: [MIDI.Byte]) throws {
        
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDI.File.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        let readStatus = (rawBytes[0] & 0xF0) >> 4
        let readChannel = rawBytes[0] & 0x0F
        let readProgramNumber = rawBytes[1]
        
        guard readStatus == 0xC else {
            throw MIDI.File.DecodeError.malformed(
                "Invalid status nibble: \(readStatus.hex.stringValue(padTo: 1, prefix: true))."
            )
        }
        
        guard readProgramNumber.isContained(in: 0 ... 127) else {
            throw MIDI.File.DecodeError.malformed(
                "Program Change program number is out of bounds: \(readProgramNumber)"
            )
        }
        
        guard let channel = readChannel.toMIDIUInt4Exactly,
              let programNumber = readProgramNumber.toMIDIUInt7Exactly else {
                  throw MIDI.File.DecodeError.malformed(
                    "Value(s) out of bounds."
                  )
              }
        
        let newEvent = MIDI.Event.programChange(program: programNumber,
                                                channel: channel)
        guard case .programChange(let unwrapped) = newEvent else {
            throw MIDI.File.DecodeError.malformed(
                "Could not unwrap enum case."
            )
        }
        
        self = unwrapped
        
    }
    
    public var midi1SMFRawBytes: [MIDI.Byte] {
        
        // Cn program
        
        midi1RawBytes()
        
    }
    
    static let midi1SMFFixedRawBytesLength = 2
    
    public static func initFrom(midi1SMFRawBytesStream rawBuffer: Data) -> InitFromMIDI1SMFRawBytesStreamResult? {
        
        let requiredData = rawBuffer.prefix(midi1SMFFixedRawBytesLength).bytes
        
        guard requiredData.count == midi1SMFFixedRawBytesLength else {
            return nil
        }
        
        guard let newInstance = try? Self(midi1SMFRawBytes: requiredData) else {
            return nil
        }
        
        return (newEvent: newInstance,
                bufferLength: midi1SMFFixedRawBytesLength)
        
    }
    
    public var smfDescription: String {
        
        let chanString = channel.uInt8Value.hex.stringValue(padTo: 1, prefix: true)
        
        return "prgm#\(program) chan:\(chanString)"
    }
    
    public var smfDebugDescription: String {
        
        "ProgChange(" + smfDescription + ")"
        
    }
    
}
