//
//  Event CC.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

// MARK: - CC

extension MIDI.File.Event {
    
    public typealias CC = MIDI.Event.CC
    
}

extension MIDI.Event.CC: MIDIFileEvent {
    
    public static let smfEventType: MIDI.File.Event.EventType = .cc
    
    public init(midi1SMFRawBytes rawBytes: [MIDI.Byte]) throws {
        
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDI.File.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }

        let readStatus = (rawBytes[0] & 0xF0) >> 4
        let readChannel = rawBytes[0] & 0x0F
        let readCCNum = rawBytes[1]
        let readValue = rawBytes[2]

        guard readStatus == 0xB else {
            throw MIDI.File.DecodeError.malformed(
                "Invalid status nibble: \(readStatus.hex.stringValue(padTo: 1, prefix: true))."
            )
        }

        guard readCCNum.isContained(in: 0 ... 127) else {
            throw MIDI.File.DecodeError.malformed(
                "CC number is out of bounds: \(readCCNum)"
            )
        }

        guard readValue.isContained(in: 0 ... 127) else {
            throw MIDI.File.DecodeError.malformed(
                "CC value is out of bounds: \(readValue)"
            )
        }
        
        guard let channel = readChannel.toMIDIUInt4Exactly,
              let ccNum = readCCNum.toMIDIUInt7Exactly,
              let value = readValue.toMIDIUInt7Exactly else {
                  throw MIDI.File.DecodeError.malformed(
                    "Value(s) out of bounds."
                  )
              }
            
        let newEvent = MIDI.Event.cc(.init(number: ccNum),
                                     value: .midi1(value),
                                     channel: channel)
        guard case .cc(let unwrapped) = newEvent else {
            throw MIDI.File.DecodeError.malformed(
                "Could not unwrap enum case."
            )
        }
        
        self = unwrapped
        
    }

    public var midi1SMFRawBytes: [MIDI.Byte] {
        
        // Bn controller value
        
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

        return "cc#\(controller.number) val:\(value) chan:\(chanString)"
        
    }

    public var smfDebugDescription: String {
        
        "CC(" + smfDescription + ")"
        
    }
    
}
