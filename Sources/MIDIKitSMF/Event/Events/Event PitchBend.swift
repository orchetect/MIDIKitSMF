//
//  Event PitchBend.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

// MARK: - PitchBend

extension MIDI.File.Event {
    
    public typealias PitchBend = MIDI.Event.PitchBend
    
}

extension MIDI.Event.PitchBend: MIDIFileEvent {
    
    public static let smfEventType: MIDI.File.Event.EventType = .pitchBend
    
    public init(midi1SMFRawBytes rawBytes: [MIDI.Byte]) throws {
        
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDI.File.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        let readStatus = (rawBytes[0] & 0xF0) >> 4
        let readChannel = rawBytes[0] & 0x0F
        let readValue = MIDI.Byte.Pair(msb: rawBytes[2], lsb: rawBytes[1]).uInt16Value
        
        guard readStatus == 0xE else {
            throw MIDI.File.DecodeError.malformed(
                "Invalid status nibble: \(readStatus.hex.stringValue(padTo: 1, prefix: true))."
            )
        }
        
        guard rawBytes[1].isContained(in: 0 ... 127) else {
            throw MIDI.File.DecodeError.malformed(
                "Pitch Bend LSB is out of bounds: \(rawBytes[1].hex.stringValue(padTo: 2, prefix: true))"
            )
        }
        
        guard rawBytes[2].isContained(in: 0 ... 127) else {
            throw MIDI.File.DecodeError.malformed(
                "Pitch Bend MSB is out of bounds: \(rawBytes[2].hex.stringValue(padTo: 2, prefix: true))"
            )
        }
        
        let valueRange = MIDI.UInt14.min(UInt16.self) ... MIDI.UInt14.max(UInt16.self)
        guard readValue.isContained(in: valueRange) else {
            let valueString = readValue.hex.stringValue(padToEvery: 2, prefix: true)
            let lsb = rawBytes[1].hex.stringValue(padTo: 2, prefix: true)
            let msb = rawBytes[2].hex.stringValue(padTo: 2, prefix: true)
            
            throw MIDI.File.DecodeError.malformed(
                "Pitch Bend value is out of bounds: UInt:\(readValue) (\(valueString) from LSB:\(lsb) MSB:\(msb)"
            )
        }
        
        guard let channel = readChannel.toMIDIUInt4Exactly,
              let value = readValue.toMIDIUInt14Exactly else {
                  throw MIDI.File.DecodeError.malformed(
                    "Value(s) out of bounds."
                  )
              }
        
        let newEvent = MIDI.Event.pitchBend(value: .midi1(value),
                                            channel: channel)
        guard case .pitchBend(let unwrapped) = newEvent else {
            throw MIDI.File.DecodeError.malformed(
                "Could not unwrap enum case."
            )
        }
        
        self = unwrapped
        
    }
    
    public var midi1SMFRawBytes: [MIDI.Byte] {
        
        // 3 bytes : En lsb msb
        
        midi1RawBytes()
        
    }
    
    static let midi1SMFFixedRawBytesLength = 3
    
    public static func initFrom(midi1SMFRawBytesStream rawBuffer: Data) throws -> InitFromMIDI1SMFRawBytesStreamResult {
        
        let requiredData = rawBuffer.prefix(midi1SMFFixedRawBytesLength).bytes
        
        guard requiredData.count == midi1SMFFixedRawBytesLength else {
            throw MIDI.File.DecodeError.malformed(
                "Unexpected byte length."
            )
        }
        
        let newInstance = try Self(midi1SMFRawBytes: requiredData)
        
        return (newEvent: newInstance,
                bufferLength: midi1SMFFixedRawBytesLength)
        
    }
    
    public var smfDescription: String {
        
        let chanString = channel.uInt8Value.hex.stringValue(padTo: 1, prefix: true)
        
        return "bend:\(value) chan:\(chanString)"
        
    }
    
    public var smfDebugDescription: String {
        
        "PitchBend(" + smfDescription + ")"
        
    }
    
}
