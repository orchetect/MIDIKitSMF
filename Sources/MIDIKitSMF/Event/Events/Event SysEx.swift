//
//  Event SysEx.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

// MARK: - SysEx

extension MIDI.Event {
    
    internal static func sysEx(
        midi1SMFRawBytes rawBytes: [MIDI.Byte],
        group: MIDI.UInt4 = 0
    ) throws -> Self {
        
        guard rawBytes.count >= 3 else {
            throw MIDI.File.DecodeError.malformed(
                "Not enough bytes."
            )
        }
        
        // 1-byte preamble
        guard rawBytes.starts(with: [0xF0]) else {
            throw MIDI.File.DecodeError.malformed(
                "Event is not a SysEx event."
            )
        }
        
        guard let length = MIDI.File.decodeVariableLengthValue(from: Array(rawBytes[1...])) else {
            throw MIDI.File.DecodeError.malformed(
                "Could not extract variable length."
            )
        }
        
        let expectedFullLength = 1 + length.byteLength + length.value
        
        guard rawBytes.count >= expectedFullLength else {
            throw MIDI.File.DecodeError.malformed(
                "Fewer bytes are available (\(rawBytes.count)) than are expected (\(expectedFullLength))."
            )
        }
        
        let sysExBodySlice = Array(rawBytes[(1 + length.byteLength) ..< expectedFullLength])
        
        guard let lastByte = sysExBodySlice.last else {
            throw MIDI.File.DecodeError.malformed(
                "SysEx data was empty when attempting to read termination byte."
            )
        }
        
        guard lastByte == 0xF7 else {
            throw MIDI.File.DecodeError.malformed(
                "Expected SysEx termination byte 0xF7 but found \(lastByte.hex.stringValue(padTo: 2, prefix: true)) instead."
            )
        }
        
        let sysExFullSlice = [0xF0] + Array(rawBytes[1 + length.byteLength ..< expectedFullLength])
        
        return try MIDI.Event.sysEx(rawBytes: sysExFullSlice)
            
    }
    
}

// MARK: - SysEx

extension MIDI.File.Event {
    
    public typealias SysEx = MIDI.Event.SysEx
    
}

extension MIDI.Event.SysEx: MIDIFileEvent {
    
    public static let smfEventType: MIDI.File.Event.EventType = .sysEx
    
    public init(midi1SMFRawBytes rawBytes: [MIDI.Byte]) throws {
        
        let parsedSysEx = try MIDI.Event.sysEx(midi1SMFRawBytes: rawBytes)
        
        switch parsedSysEx {
        case .sysEx(let sysEx):
            self = sysEx
        case .universalSysEx:
            throw MIDI.Event.ParseError.invalidType
        default:
            throw MIDI.Event.ParseError.invalidType
        }
        
    }
    
    public var midi1SMFRawBytes: [MIDI.Byte] {
        
        // F0 variable_length(of message including trailing F7) message
        // The system exclusive message :
        // F0 7E 00 09 01 F7
        // would be encoded (without the preceding delta-time) as :
        // F0 05 7E 00 09 01 F7
        
        let msg = midi1RawBytes(leadingF0: false, trailingF7: false)
        
        return [0xF0] + MIDI.File.encodeVariableLengthValue(msg.count) + msg + [0xF7]
        
    }
    
    public static func initFrom(midi1SMFRawBytesStream rawBuffer: Data) throws -> InitFromMIDI1SMFRawBytesStreamResult {
        
        guard rawBuffer.count >= 3 else {
            throw MIDI.File.DecodeError.malformed(
                "Byte length too short."
            )
        }
        
        let newInstance = try Self(midi1SMFRawBytes: rawBuffer.bytes)
        
        #warning("> TODO: this is brittle but it may work")
        
        let length = newInstance.midi1SMFRawBytes.count
        
        return (newEvent: newInstance,
                bufferLength: length)
        
    }
    
    public var smfDescription: String {
        
        "sysEx: \(midi1SMFRawBytes.count) bytes"
        
    }

    public var smfDebugDescription: String {
        
        let bytes = midi1SMFRawBytes
        
        let byteDump = bytes
            .hex.stringValues(padTo: 2, prefixes: true)
            .joined(separator: ", ")
            .wrapped(with: .brackets)

        return "SysEx(\(bytes.count) bytes: \(byteDump)"
        
    }
    
}

// MARK: - UniversalSysEx

extension MIDI.File.Event {
    
    public typealias UniversalSysEx = MIDI.Event.UniversalSysEx
    
}


extension MIDI.Event.UniversalSysEx: MIDIFileEvent {
    
    public static let smfEventType: MIDI.File.Event.EventType = .universalSysEx
    
    public init(midi1SMFRawBytes rawBytes: [MIDI.Byte]) throws {
        
        let parsedSysEx = try MIDI.Event.sysEx(midi1SMFRawBytes: rawBytes)
        
        switch parsedSysEx {
        case .sysEx:
            throw MIDI.Event.ParseError.invalidType
        case .universalSysEx(let universalSysEx):
            self = universalSysEx
        default:
            throw MIDI.Event.ParseError.invalidType
        }
        
    }
    
    public var midi1SMFRawBytes: [MIDI.Byte] {
        
        // F0 variable_length(of message including trailing F7) message
        // The system exclusive message :
        // F0 7E 00 09 01 F7
        // would be encoded (without the preceding delta-time) as :
        // F0 05 7E 00 09 01 F7
        
        let msg = midi1RawBytes(leadingF0: false, trailingF7: false)
        
        return [0xF0] + MIDI.File.encodeVariableLengthValue(msg.count) + msg + [0xF7]
        
    }
    
    public static func initFrom(midi1SMFRawBytesStream rawBuffer: Data) throws -> InitFromMIDI1SMFRawBytesStreamResult {
        
        guard rawBuffer.count >= 3 else {
            throw MIDI.File.DecodeError.malformed(
                "Byte length too short."
            )
        }
        
        let newInstance = try Self(midi1SMFRawBytes: rawBuffer.bytes)
        
        #warning("> TODO: this is brittle but it may work")
        
        let length = newInstance.midi1SMFRawBytes.count
        
        return (newEvent: newInstance,
                bufferLength: length)
        
    }
    
    public var smfDescription: String {
        
        "universalSysEx: \(midi1SMFRawBytes.count) bytes"
        
    }
    
    public var smfDebugDescription: String {
        
        let bytes = midi1SMFRawBytes
        
        let byteDump = bytes
            .hex.stringValues(padTo: 2, prefixes: true)
            .joined(separator: ", ")
            .wrapped(with: .brackets)
        
        return "UniversalSysEx(\(bytes.count) bytes: \(byteDump)"
        
    }
    
}
