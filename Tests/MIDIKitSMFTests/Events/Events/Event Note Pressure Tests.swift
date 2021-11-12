//
//  Event Note Pressure Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF

final class Event_NotePressure_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes_A() throws {
        
        let bytes: [MIDI.Byte] = [0xA0, 0x01, 0x40]
        
        let event = try MIDI.File.Event.NotePressure(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.note, 1)
        XCTAssertEqual(event.amount, .midi1(0x40))
        XCTAssertEqual(event.channel, 0)
        
    }
    
    func testMIDI1SMFRawBytes_A() {
        
        let event = MIDI.File.Event.NotePressure(note: 1,
                                                 amount: .midi1(0x40),
                                                 channel: 0)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xA0, 0x01, 0x40])
        
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        
        let bytes: [MIDI.Byte] = [0xA1, 0x3C, 0x7F]
        
        let event = try MIDI.File.Event.NotePressure(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.note, 60)
        XCTAssertEqual(event.amount, .midi1(0x7F))
        XCTAssertEqual(event.channel, 1)
        
    }
    
    func testMIDI1SMFRawBytes_B() {
        
        let event = MIDI.File.Event.NotePressure(note: 60,
                                                 amount: .midi1(0x7F),
                                                 channel: 1)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xA1, 0x3C, 0x7F])
        
    }
    
}

#endif
