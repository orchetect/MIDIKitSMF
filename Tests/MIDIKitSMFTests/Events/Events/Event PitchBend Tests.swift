//
//  Event PitchBend Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF

final class Event_PitchBend_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes_A() throws {
        
        let bytes: [MIDI.Byte] = [0xE0, 0x00, 0x40]
        
        let event = try MIDI.File.Event.PitchBend(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.value, .midi1(.midpoint))
        XCTAssertEqual(event.channel, 0)
        
    }
    
    func testMIDI1SMFRawBytes_A() {
        
        let event = MIDI.File.Event.PitchBend(value: .midi1(.midpoint),
                                              channel: 0)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xE0, 0x00, 0x40])
        
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        
        let bytes: [MIDI.Byte] = [0xE1, 0x7F, 0x7F]
        
        let event = try MIDI.File.Event.PitchBend(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.value, .midi1(.max))
        XCTAssertEqual(event.channel, 1)
        
    }
    
    func testMIDI1SMFRawBytes_B() {
        
        let event = MIDI.File.Event.PitchBend(value: .midi1(.max),
                                              channel: 1)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xE1, 0x7F, 0x7F])
        
    }
    
    // MARK: - Edge Cases
    
}

#endif
