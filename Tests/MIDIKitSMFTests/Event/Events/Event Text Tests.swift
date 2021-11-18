//
//  Event Text Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF

final class Event_Text_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes_EmptyString() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x01,  // header
                                  0x00]        // length: 0 bytes
        
        let event = try MIDI.File.Event.Text(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.textType, .text)
        XCTAssertEqual(event.text, "")
        
    }
    
    func testMIDI1SMFRawBytes_EmptyString() {
        
        let event = MIDI.File.Event.Text(type: .text, string: "")
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x01,  // header
                               0x00])       // length: 0 bytes
        
    }
    
    func testInit_midi1SMFRawBytes_WithString() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x01,  // header
                                  0x04,        // length: 4 bytes
                                  0x61, 0x62, 0x63, 0x64] // string characters
        
        let event = try MIDI.File.Event.Text(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.textType, .text)
        XCTAssertEqual(event.text, "abcd")
        
    }
    
    func testMIDI1SMFRawBytes_WithString() {
        
        let event = MIDI.File.Event.Text(type: .text, string: "abcd")
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x01,  // header
                               0x04,        // length: 4 bytes
                               0x61, 0x62, 0x63, 0x64]) // string characters
        
    }
    
    // MARK: Text Types
    
    func testTextHeaders() {
        
        // ensure all text event header IDs exist
        
        MIDI.File.Event.Text.EventType.allCases.forEach {
            XCTAssertNotNil(MIDI.File.kTextEventHeaders[$0])
        }
        
    }
    
    func testTextTypes() throws {
        
        func textTypeTest(eventType: MIDI.File.Event.Text.EventType,
                          eventID: MIDI.Byte) throws {
            
            let bytes: [MIDI.Byte] = [0xFF, eventID, // header
                                      0x01,          // length: 1 bytes
                                      0x61]          // string characters
            
            let event1 = MIDI.File.Event.Text(type: eventType, string: "a")
            XCTAssertEqual(event1.midi1SMFRawBytes, bytes)
            
            let event2 = try MIDI.File.Event.Text(midi1SMFRawBytes: bytes)
            XCTAssertEqual(event1, event2)
            
        }
        
        let textTypes: [MIDI.File.Event.Text.EventType: MIDI.Byte] = [
            .text                : 0x01,
            .copyright           : 0x02,
            .trackOrSequenceName : 0x03,
            .instrumentName      : 0x04,
            .lyric               : 0x05,
            .marker              : 0x06,
            .cuePoint            : 0x07,
            .programName         : 0x08,
            .deviceName          : 0x09
        ]
        
        try textTypes.forEach {
            try textTypeTest(eventType: $0.key, eventID: $0.value)
        }
        
    }
    
    #warning("> TODO: add tests") // edge cases etc.
    
}

#endif
