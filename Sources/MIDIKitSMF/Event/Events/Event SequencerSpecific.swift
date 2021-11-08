//
//  Event SequencerSpecific.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

// MARK: - SequencerSpecific

extension MIDI.File.Event {
    
    public struct SequencerSpecific: Equatable, Hashable {
        
        /// Data bytes.
        /// Typically begins with a 1 or 3 byte manufacturer ID, similar to SysEx.
        public var data: [UInt8] = []
        
    }
    
}

extension MIDI.File.Event.SequencerSpecific: MIDIFileEvent {
    
    public static let smfEventType: MIDI.File.Event.EventType = .sequencerSpecific
    
    public init(midi1SMFRawBytes rawBytes: [MIDI.Byte]) throws {
        
        guard rawBytes.count >= 3 else {
            throw MIDI.File.DecodeError.malformed(
                "Too few bytes."
            )
        }
        
        // 2-byte preamble
        guard rawBytes.starts(with: MIDI.File.kEventHeaders[.sequencerSpecific]!) else {
            throw MIDI.File.DecodeError.malformed(
                "Event does not start with expected bytes."
            )
        }
        
        guard let length = MIDI.File.decodeVariableLengthValue(from: Array(rawBytes[2...])) else {
            throw MIDI.File.DecodeError.malformed(
                "Could not extract variable length."
            )
        }
        
        let expectedFullLength = 2 + length.byteLength + length.value
        
        guard rawBytes.count >= expectedFullLength else {
            throw MIDI.File.DecodeError.malformed(
                "Fewer bytes are available (\(rawBytes.count)) than are expected (\(expectedFullLength))."
            )
        }
        
        let beginIndex = rawBytes.startIndex.advanced(by: 2)
        let stopIndex = beginIndex.advanced(by: length.value)
        let readData = Array(rawBytes[beginIndex ... stopIndex])
        
        data = readData
        
    }
    
    public var midi1SMFRawBytes: [MIDI.Byte] {
        
        // FF 7F length data
        
        MIDI.File.kEventHeaders[.sequencerSpecific]! +
        // length of data
        MIDI.File.encodeVariableLengthValue(self.data.count) +
        // data
        self.data
        
    }
    
    public static func initFrom(midi1SMFRawBytesStream rawBuffer: Data) -> InitFromMIDI1SMFRawBytesStreamResult? {
        
        guard rawBuffer.count >= 3 else {
            return nil
        }
        
        guard let newInstance = try? Self(midi1SMFRawBytes: rawBuffer.bytes) else {
            return nil
        }
        
        #warning("> TODO: this is brittle but it may work")
        
        let length = newInstance.midi1SMFRawBytes.count
        
        return (newEvent: newInstance,
                bufferLength: length)
        
    }
    
    public var smfDescription: String {
        
        "sequencerSpecific: \(data.count) bytes"
        
    }
    
    public var smfDebugDescription: String {
        
        let byteDump = data
            .hex.stringValues(padTo: 2, prefixes: true)
            .joined(separator: ", ")
            .wrapped(with: .brackets)
        
        return "SequencerSpecific(\(data.count) bytes: \(byteDump)"
        
    }
    
}
