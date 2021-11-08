//
//  Event Note On.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

// MARK: - NoteOn

extension MIDI.File.Event {
    
    public typealias NoteOn = MIDI.Event.Note.On
    
}

extension MIDI.Event.Note.On: MIDIFileEvent {
    
    public static let smfEventType: MIDI.File.Event.EventType = .noteOn
    
    public init(midi1SMFRawBytes rawBytes: [MIDI.Byte]) throws {
        
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDI.File.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        let readStatus = (rawBytes[0] & 0xF0) >> 4
        let readChannel = rawBytes[0] & 0x0F
        let readNoteNum = rawBytes[1]
        let readVelocity = rawBytes[2]
        
        guard readStatus == 0x9 else {
            throw MIDI.File.DecodeError.malformed(
                "Invalid status nibble: \(readStatus.hex.stringValue(padTo: 1, prefix: true))."
            )
        }
        
        guard readNoteNum.isContained(in: 0 ... 127) else {
            throw MIDI.File.DecodeError.malformed(
                "Note number is out of bounds: \(readNoteNum)"
            )
        }
        
        guard readVelocity.isContained(in: 0 ... 127) else {
            throw MIDI.File.DecodeError.malformed(
                "Note velocity is out of bounds: \(readVelocity)"
            )
        }
        
        guard let channel = readChannel.toMIDIUInt4Exactly,
              let noteNum = readNoteNum.toMIDIUInt7Exactly,
              let velocity = readVelocity.toMIDIUInt7Exactly else {
                  throw MIDI.File.DecodeError.malformed(
                    "Value(s) out of bounds."
                  )
              }
        
        let newEvent = MIDI.Event.noteOn(noteNum,
                                         velocity: .midi1(velocity),
                                         channel: channel)
        guard case .noteOn(let unwrapped) = newEvent else {
            throw MIDI.File.DecodeError.malformed(
                "Could not unwrap enum case."
            )
        }
        
        self = unwrapped
        
    }
    
    public var midi1SMFRawBytes: [MIDI.Byte] {
        
        // 9n note velocity
        
        midi1RawBytes()
        
    }
    
    static let midi1SMFFixedRawBytesLength = 3
    
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
        
        return "noteOn:#\(note) vel:\(velocity) chan:\(chanString)"
        
    }
    
    public var smfDebugDescription: String {
        
        "NoteOn(" + smfDescription + ")"
        
    }
    
}
