//
//  Event Tempo Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class Event_Tempo_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes_A() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x51, 0x03, // header
                                  0x07, 0xA1, 0x20] // 24-bit tempo encoding
        
        let event = try MIDI.File.Event.Tempo(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.bpm, 120.0)
        
    }
    
    func testMIDI1SMFRawBytes_A() {
        
        let event = MIDI.File.Event.Tempo(bpm: 120.0)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x51, 0x03,  // header
                               0x07, 0xA1, 0x20]) // 24-bit tempo encoding
        
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x51, 0x03, // header
                                  0x0F, 0x42, 0x40] // 24-bit tempo encoding
        
        let event = try MIDI.File.Event.Tempo(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.bpm, 60.0)
        
    }
    
    func testMIDI1SMFRawBytes_B() {
        
        let event = MIDI.File.Event.Tempo(bpm: 60.0)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x51, 0x03,  // header
                               0x0F, 0x42, 0x40]) // 24-bit tempo encoding
        
    }
    
}

#endif
