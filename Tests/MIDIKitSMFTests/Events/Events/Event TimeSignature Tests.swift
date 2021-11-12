//
//  Event TimeSignature Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF

final class Event_TimeSignature_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x58, 0x04, // header
                                  0x02, // numerator
                                  0x01, // denominator
                                  0x18, // midiClocksBetweenMetronomeClicks
                                  0x08] // numberOf32ndNotesInAQuarterNote
        
        let event = try MIDI.File.Event.TimeSignature(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.numerator, 2)
        XCTAssertEqual(event.denominator, 1)
        XCTAssertEqual(event.midiClocksBetweenMetronomeClicks, 0x18)
        XCTAssertEqual(event.numberOf32ndNotesInAQuarterNote, 0x08)
        
    }
    
    func testMIDI1SMFRawBytes() {
        
        let event = MIDI.File.Event.TimeSignature(numerator: 2,
                                                  denominator: 1)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x58, 0x04, // header
                               0x02,  // numerator
                               0x01,  // denominator
                               0x18,  // midiClocksBetweenMetronomeClicks
                               0x08]) // numberOf32ndNotesInAQuarterNote
        
    }
    
}

#endif
