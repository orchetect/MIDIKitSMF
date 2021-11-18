//
//  Event CC Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF

final class Event_CC_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes_A() throws {
        
        let bytes: [MIDI.Byte] = [0xB0, 0x01, 0x40]
        
        let event = try MIDI.File.Event.CC(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.controller, .modWheel) // CC 1
        XCTAssertEqual(event.value, .midi1(0x40))
        XCTAssertEqual(event.channel, 0)
        
    }
    
    func testMIDI1SMFRawBytes_A() {
        
        let event = MIDI.File.Event.CC(controller: .modWheel,
                                       value: .midi1(0x40),
                                       channel: 0)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xB0, 0x01, 0x40])
        
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        
        let bytes: [MIDI.Byte] = [0xB1, 0x0B, 0x7F]
        
        let event = try MIDI.File.Event.CC(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.controller, .expression) // CC 11
        XCTAssertEqual(event.value, .midi1(0x7F))
        XCTAssertEqual(event.channel, 1)
        
    }
    
    func testMIDI1SMFRawBytes_B() {
        
        let event = MIDI.File.Event.CC(controller: .expression,
                                       value: .midi1(0x7F),
                                       channel: 1)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xB1, 0x0B, 0x7F])
        
    }
    
}

#endif
