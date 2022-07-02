//
//  Event SequencerSpecific Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class Event_SequencerSpecific_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes_Empty() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x7F, 0x00]
        
        let event = try MIDI.File.Event.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.data, [])
        
    }
    
    func testMIDI1SMFRawBytes_Empty() {
        
        let event = MIDI.File.Event.SequencerSpecific(data: [])
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x7F, 0x00])
        
    }
    
    func testInit_midi1SMFRawBytes_OneByte() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x7F, 0x01, 0x34]
        
        let event = try MIDI.File.Event.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.data, [0x34])
        
    }
    
    func testMIDI1SMFRawBytes_OneByte() {
        
        let event = MIDI.File.Event.SequencerSpecific(data: [0x34])
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x7F, 0x01, 0x34])
        
    }
    
    func testInit_midi1SMFRawBytes_127Bytes() throws {
        
        let data: [MIDI.Byte] = .init(repeating: 0x12, count: 127)
        
        let bytes: [MIDI.Byte] =
        [0xFF, 0x7F, // header
         0x7F]       // length: 127 bytes to follow
        + data       // data
        
        let event = try MIDI.File.Event.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.data, data)
        
    }
    
    func testMIDI1SMFRawBytes_127Bytes() {
        
        let data: [MIDI.Byte] = .init(repeating: 0x12, count: 127)
        
        let event = MIDI.File.Event.SequencerSpecific(data: data)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(
            bytes,
            [0xFF, 0x7F, // header
             0x7F]       // length: 127 bytes to follow
            + data       // data
        )
        
    }
    
    func testInit_midi1SMFRawBytes_128Bytes() throws {
        
        let data: [MIDI.Byte] = .init(repeating: 0x12, count: 128)
        
        let bytes: [MIDI.Byte] =
        [0xFF, 0x7F, // header
         0x81, 0x00] // length: 128 bytes to follow
        + data       // data
        
        let event = try MIDI.File.Event.SequencerSpecific(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.data, data)
        
    }
    
    func testMIDI1SMFRawBytes_128Bytes() {
        
        let data: [MIDI.Byte] = .init(repeating: 0x12, count: 128)
        
        let event = MIDI.File.Event.SequencerSpecific(data: data)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(
            bytes,
            [0xFF, 0x7F, // header
             0x81, 0x00] // length: 128 bytes to follow
            + data       // data
        )
        
    }
    
}

#endif
