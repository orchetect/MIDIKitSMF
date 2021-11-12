//
//  Event KeySignature Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF

final class Event_KeySignature_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes_A() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x59, 0x02, 4, 0x00]
        
        let event = try MIDI.File.Event.KeySignature(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.flatsOrSharps, 4)
        XCTAssertEqual(event.majorKey, true)
        
    }
    
    func testMIDI1SMFRawBytes_A() {
        
        let event = MIDI.File.Event.KeySignature(flatsOrSharps: 4, majorKey: true)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x59, 0x02, 4, 0x00])
        
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x59, 0x02, 0xFD, 0x01]
        
        let event = try MIDI.File.Event.KeySignature(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.flatsOrSharps, -3)
        XCTAssertEqual(event.majorKey, false)
        
    }
    
    func testMIDI1SMFRawBytes_B() {
        
        let event = MIDI.File.Event.KeySignature(flatsOrSharps: -3, majorKey: false)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x59, 0x02, 0xFD, 0x01])
        
    }
    
}

#endif
