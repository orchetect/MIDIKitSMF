//
//  Event Pressure.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

// MARK: - Channel Pressure

extension MIDI.File.Event {
    
    public typealias Pressure = MIDI.Event.Pressure
    
}

extension MIDI.Event.Pressure: MIDIFileEvent {
    
    public static let smfEventType: MIDI.File.Event.EventType = .pressure
    
    public init(midi1SMFRawBytes rawBytes: [MIDI.Byte]) throws {
        
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDI.File.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        let readStatus = (rawBytes[0] & 0xF0) >> 4
        let readChannel = rawBytes[0] & 0x0F
        let readValue = rawBytes[1]
        
        guard readStatus == 0xD else {
            throw MIDI.File.DecodeError.malformed(
                "Invalid status nibble: \(readStatus.hex.stringValue(padTo: 1, prefix: true))."
            )
        }
        
        guard readValue.isContained(in: 0 ... 127) else {
            throw MIDI.File.DecodeError.malformed(
                "Channel Pressure value is out of bounds: \(readValue)"
            )
        }
        
        guard let channel = readChannel.toMIDIUInt4Exactly,
              let pressure = readValue.toMIDIUInt7Exactly else {
                  throw MIDI.File.DecodeError.malformed(
                    "Value(s) out of bounds."
                  )
              }
        
        let newEvent = MIDI.Event.pressure(amount: .midi1(pressure),
                                           channel: channel)
        guard case .pressure(let unwrapped) = newEvent else {
            throw MIDI.File.DecodeError.malformed(
                "Could not unwrap enum case."
            )
        }
        
        self = unwrapped
        
    }
    
    public var midi1SMFRawBytes: [MIDI.Byte] {
        
        // Dn value
        midi1RawBytes()
        
    }
    
    static let midi1SMFFixedRawBytesLength = 2

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

        return "pressure:\(amount) chan:\(chanString)"
        
    }

    public var smfDebugDescription: String {
        
        "ChanPressure(" + smfDescription + ")"
        
    }
    
}
