//
//  Event Note On Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class Event_NoteOn_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes_A() throws {
        
        let bytes: [MIDI.Byte] = [0x90, 0x01, 0x40]
        
        let event = try MIDI.File.Event.NoteOn(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.note.number, 1)
        XCTAssertEqual(event.velocity, .midi1(0x40))
        XCTAssertEqual(event.channel, 0)
        
    }
    
    func testMIDI1SMFRawBytes_A() {
        
        let event = MIDI.File.Event.NoteOn(note: 1,
                                           velocity: .midi1(0x40),
                                           channel: 0)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0x90, 0x01, 0x40])
        
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        
        let bytes: [MIDI.Byte] = [0x91, 0x3C, 0x7F]
        
        let event = try MIDI.File.Event.NoteOn(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.note.number, 60)
        XCTAssertEqual(event.velocity, .midi1(0x7F))
        XCTAssertEqual(event.channel, 1)
        
    }
    
    func testMIDI1SMFRawBytes_B() {
        
        let event = MIDI.File.Event.NoteOn(note: 60,
                                           velocity: .midi1(0x7F),
                                           channel: 1)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0x91, 0x3C, 0x7F])
        
    }
    
    // MARK: - Edge Cases
    
    func testInit_midi1SMFRawBytes_Velocity0() throws {
        
        let bytes: [MIDI.Byte] = [0x90, 0x3C, 0x00]
        
        let event = try MIDI.File.Event.NoteOn(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.note.number, 60)
        XCTAssertEqual(event.velocity, .midi1(0x00))
        XCTAssertEqual(event.channel, 0)
        
    }
    
    func testMIDI1SMFRawBytes_Velocity0_Defaulted() {
        
        let event = MIDI.File.Event.NoteOn(note: 60,
                                           velocity: .midi1(0x00),
                                           channel: 0)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0x80, 0x3C, 0x00]) // interpreted as Note Off
        
    }
    
    func testMIDI1SMFRawBytes_Velocity0_TranslateOff() {
        
        let event = MIDI.File.Event.NoteOn(note: 60,
                                           velocity: .midi1(0x00),
                                           channel: 0,
                                           midi1ZeroVelocityAsNoteOff: false)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0x90, 0x3C, 0x00])
        
    }
    
    
}

#endif
