//
//  Event Pressure Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class Event_Pressure_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes_A() throws {
        
        let bytes: [MIDI.Byte] = [0xD0, 0x40]
        
        let event = try MIDI.File.Event.Pressure(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.amount, .midi1(0x40))
        XCTAssertEqual(event.channel, 0)
        
    }
    
    func testMIDI1SMFRawBytes_A() {
        
        let event = MIDI.File.Event.Pressure(amount: .midi1(0x40),
                                             channel: 0)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xD0, 0x40])
        
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        
        let bytes: [MIDI.Byte] = [0xD1, 0x7F]
        
        let event = try MIDI.File.Event.Pressure(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.amount, .midi1(0x7F))
        XCTAssertEqual(event.channel, 1)
        
    }
    
    func testMIDI1SMFRawBytes_B() {
        
        let event = MIDI.File.Event.Pressure(amount: .midi1(0x7F),
                                             channel: 1)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xD1, 0x7F])
        
    }
    
}

#endif
