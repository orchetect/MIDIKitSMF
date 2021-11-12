//
//  Event SequenceNumber Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF

final class Event_SequenceNumber_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes_A() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x00, 0x02, 0x00, 0x00]
        
        let event = try MIDI.File.Event.SequenceNumber(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.sequence, 0x00)
        
    }
    
    func testMIDI1SMFRawBytes_A() {
        
        let event = MIDI.File.Event.SequenceNumber(sequence: 0x00)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x00, 0x02, 0x00, 0x00])
        
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x00, 0x02, 0x7F, 0xFF]
        
        let event = try MIDI.File.Event.SequenceNumber(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.sequence, 0x7FFF)
        
    }
    
    func testMIDI1SMFRawBytes_B() {
        
        let event = MIDI.File.Event.SequenceNumber(sequence: 0x7FFF)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x00, 0x02, 0x7F, 0xFF])
        
    }
    
}

#endif
