//
//  Event TimeSignature.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

// MARK: - TimeSignature

extension MIDI.File.Event {
    
    /// Time Signature event.
    /// For a format 1 MIDI file, Time Signature Meta events should only occur within the first MTrk chunk.
    /// If there are no Time Signature events in a MIDI file, 4/4 is assumed.
    public struct TimeSignature: Equatable, Hashable {
        
        /// Numerator in time signature fraction: Literal numerator
        public var numerator: UInt8 = 4

        /// Denominator in time signature fraction.
        /// Expressed as a power of 2. (2 = 2^2 (4); 3 = 2^3 (8); etc.)
        public var denominator: UInt8 = 2

        /// Number of MIDI clocks between metronome clicks.
        public var midiClocksBetweenMetronomeClicks: UInt8 = 0x18

        /// Number of notated 32nd-notes in a MIDI quarter-note.
        /// The usual value for this parameter is 8, though some sequencers allow the user to specify that what MIDI thinks of as a quarter note, should be notated as something else.
        public var numberOf32ndNotesInAQuarterNote: UInt8 = 8
        
    }
    
}

extension MIDI.File.Event.TimeSignature : MIDIFileEvent {
    
    public static let smfEventType: MIDI.File.Event.EventType = .timeSignature
    
    public init(midi1SMFRawBytes rawBytes: [MIDI.Byte]) throws {
        
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDI.File.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        // 3-byte preamble
        guard rawBytes.starts(with: MIDI.File.kEventHeaders[.timeSignature]!) else {
            throw MIDI.File.DecodeError.malformed(
                "Event does not start with expected bytes."
            )
        }
        
        let readNumerator = rawBytes[3]
        let readDenominator = rawBytes[4]
        let readMidiClocksBetweenMetronomeClicks = rawBytes[5]
        let readNumberOf32ndNotesInAQuarterNote = rawBytes[6]
        
        numerator = readNumerator
        denominator = readDenominator
        midiClocksBetweenMetronomeClicks = readMidiClocksBetweenMetronomeClicks
        numberOf32ndNotesInAQuarterNote = readNumberOf32ndNotesInAQuarterNote
        
    }
    
    public var midi1SMFRawBytes: [MIDI.Byte] {
        
        // FF 58 04 nn dd cc bb
        
        var data: [MIDI.Byte] = []
        
        data += MIDI.File.kEventHeaders[.timeSignature]!
        
        data += [numerator, denominator]
        
        // number of MIDI Clocks in a metronome click
        data += [midiClocksBetweenMetronomeClicks]
        
        // number of notated 32nd-notes in a MIDI quarter-note (24 MIDI Clocks)
        // The usual value for this parameter is 8, though some sequencers allow the user to specify that what MIDI thinks of as a quarter note, should be notated as something else.
        data += [numberOf32ndNotesInAQuarterNote] // 8 32nd-notes
        
        return data
        
    }
    
    static let midi1SMFFixedRawBytesLength = 7

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
        
        let denom = pow(2 as Decimal, Int(denominator))

        return "timeSig: \(numerator)/\(denom)"
        
    }

    public var smfDebugDescription: String {
        
        "TimeSignature(" + smfDescription + ". clocks:\(midiClocksBetweenMetronomeClicks), 32ndsToAQuarter:\(numberOf32ndNotesInAQuarterNote))"
        
    }
    
}
