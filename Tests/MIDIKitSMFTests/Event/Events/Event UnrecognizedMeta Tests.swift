//
//  Event UnrecognizedMeta Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF

final class Event_UnrecognizedMeta_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes_EmptyData() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x30, // unknown/undefined meta type 0x30
                                  0x00]       // length: 0 bytes to follow
        
        let event = try MIDI.File.Event.UnrecognizedMeta(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.metaType, 0x30)
        XCTAssertEqual(event.data, [])
        
    }
    
    func testMIDI1SMFRawBytes_EmptyData() {
        
        let event = MIDI.File.Event.UnrecognizedMeta(metaType: 0x30,
                                                     data: [])
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x30, // unknown/undefined meta type 0x30
                               0x00])      // length: 0 bytes to follow
        
    }
    
    func testInit_midi1SMFRawBytes_WithData() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x30, // unknown/undefined meta type 0x30
                                  0x01,       // length: 1 bytes to follow
                                  0x12]       // data byte
        
        let event = try MIDI.File.Event.UnrecognizedMeta(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.metaType, 0x30)
        XCTAssertEqual(event.data, [0x12])
        
    }
    
    func testMIDI1SMFRawBytes_WithData() {
        
        let event = MIDI.File.Event.UnrecognizedMeta(metaType: 0x30,
                                                     data: [0x12])
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x30, // unknown/undefined meta type 0x30
                               0x01,       // length: 1 bytes to follow
                               0x12])      // data byte
        
    }
    
    func testInit_midi1SMFRawBytes_127Bytes() throws {
        
        let data: [MIDI.Byte] = .init(repeating: 0x12, count: 127)
        
        let bytes: [MIDI.Byte] =
        [0xFF, 0x30, // unknown/undefined meta type 0x30
         0x7F]       // length: 127 bytes to follow
        + data       // data
        
        let event = try MIDI.File.Event.UnrecognizedMeta(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.metaType, 0x30)
        XCTAssertEqual(event.data, data)
        
    }
    
    func testMIDI1SMFRawBytes_127Bytes() {
        
        let data: [MIDI.Byte] = .init(repeating: 0x12, count: 127)
        
        let event = MIDI.File.Event.UnrecognizedMeta(metaType: 0x30,
                                                     data: data)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(
            bytes,
            [0xFF, 0x30, // unknown/undefined meta type 0x30
             0x7F]       // length: 127 bytes to follow
            + data       // data
        )
        
    }
    
    func testInit_midi1SMFRawBytes_128Bytes() throws {
        
        let data: [MIDI.Byte] = .init(repeating: 0x12, count: 128)
        
        let bytes: [MIDI.Byte] =
        [0xFF, 0x30, // unknown/undefined meta type 0x30
         0x81, 0x00] // length: 128 bytes to follow
        + data       // data
        
        let event = try MIDI.File.Event.UnrecognizedMeta(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.metaType, 0x30)
        XCTAssertEqual(event.data, data)
        
    }
    
    func testMIDI1SMFRawBytes_128Bytes() {
        
        let data: [MIDI.Byte] = .init(repeating: 0x12, count: 128)
        
        let event = MIDI.File.Event.UnrecognizedMeta(metaType: 0x30,
                                                     data: data)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(
            bytes,
            [0xFF, 0x30, // unknown/undefined meta type 0x30
             0x81, 0x00] // length: 128 bytes to follow
            + data       // data
        )
        
    }
    
}

#endif
