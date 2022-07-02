//
//  Event Note Off Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class Event_NoteOff_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes_A() throws {
        
        let bytes: [MIDI.Byte] = [0x80, 0x01, 0x40]
        
        let event = try MIDI.File.Event.NoteOff(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.note.number, 1)
        XCTAssertEqual(event.velocity, .midi1(0x40))
        XCTAssertEqual(event.channel, 0)
        
    }
    
    func testMIDI1SMFRawBytes_A() {
        
        let event = MIDI.File.Event.NoteOff(note: 1,
                                            velocity: .midi1(0x40),
                                            channel: 0)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0x80, 0x01, 0x40])
        
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        
        let bytes: [MIDI.Byte] = [0x81, 0x3C, 0x7F]
        
        let event = try MIDI.File.Event.NoteOff(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.note.number, 60)
        XCTAssertEqual(event.velocity, .midi1(0x7F))
        XCTAssertEqual(event.channel, 1)
        
    }
    
    func testMIDI1SMFRawBytes_B() {
        
        let event = MIDI.File.Event.NoteOff(note: 60,
                                            velocity: .midi1(0x7F),
                                            channel: 1)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0x81, 0x3C, 0x7F])
        
    }
    
}

#endif
