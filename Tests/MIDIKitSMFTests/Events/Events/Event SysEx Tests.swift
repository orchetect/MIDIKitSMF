//
//  Event SysEx Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF

final class Event_SysEx_Tests: XCTestCase {
    
    // MARK: - MIDI.Event.sysEx(midi1SMFRawBytes:)
    
    func testMIDIEventSysEx_midi1SMFRawBytes_Empty() {
        
        XCTAssertThrowsError(
            try MIDI.Event.sysEx(midi1SMFRawBytes: [])
        )
        
    }
    
    func testMIDIEventSysEx_midi1SMFRawBytes_EmptyOrShort() throws {
        
        // 0xF7 termination byte is required in SMF for all syntactically complete sysex messages
        
        // not syntactically complete, but could be valid in multi-part sysex context
        XCTAssertThrowsError(
            try MIDI.Event.sysEx(midi1SMFRawBytes: [0xF0,  // start byte
                                                    0x00]) // length: 0 bytes to follow
        )
        
        // invalid length
        XCTAssertThrowsError(
            try MIDI.Event.sysEx(midi1SMFRawBytes: [0xF0,  // start byte
                                                    0x00,  // length: 0 bytes to follow (wrong)
                                                    0xF7]) // termination byte
        )
        
        // not valid sysex (should contain at least one internal byte - the manufacturer ID)
        XCTAssertThrowsError(
            try MIDI.Event.sysEx(midi1SMFRawBytes: [0xF0,  // start byte
                                                    0x01,  // length: 1 byte to follow
                                                    0xF7]) // termination byte
        )
        
    }
    
    func testMIDIEventSysEx_midi1SMFRawBytes_WrongLength() {
        
        // length must include data length and termination byte
        
        XCTAssertThrowsError(
            try MIDI.Event.sysEx(midi1SMFRawBytes: [0xF0,  // start byte
                                                    0x01,  // length: 1 byte to follow (wrong)
                                                    0x7D,  // manufacturer ID
                                                    0xF7]) // termination byte
        )
        
    }
    
    func testMIDIEventSysEx_midi1SMFRawBytes_SysEx_EmptyData() throws {
        
        let sysEx = try MIDI.Event.sysEx(midi1SMFRawBytes: [0xF0,  // start byte
                                                            0x02,  // length: 2 bytes to follow
                                                            0x7D,  // manufacturer ID
                                                            0xF7]) // termination byte
        
        guard case .sysEx(let event) = sysEx else {
            XCTFail() ; return
        }
        
        XCTAssertEqual(event.manufacturer, .oneByte(0x7D))
        XCTAssertEqual(event.data, [])
        
    }
    
    
    
    func testMIDIEventSysEx_midi1SMFRawBytes_SysEx_WithData() throws {
        
        let sysEx = try MIDI.Event.sysEx(midi1SMFRawBytes: [0xF0,  // start byte
                                                            0x04,  // length: 4 bytes to follow
                                                            0x7D,  // manufacturer ID
                                                            0x12,  // data byte 1
                                                            0x34,  // data byte 2
                                                            0xF7]) // termination byte
        
        guard case .sysEx(let event) = sysEx else {
            XCTFail() ; return
        }
        
        XCTAssertEqual(event.manufacturer, .oneByte(0x7D))
        XCTAssertEqual(event.data, [0x12, 0x34])
        
    }
    
    func testMIDIEventSysEx_midi1SMFRawBytes_UniversalSysEx_EmptyData() throws {
        
        let sysEx = try MIDI.Event.sysEx(midi1SMFRawBytes: [0xF0,  // start byte
                                                            0x05,  // length: 5 bytes to follow
                                                            0x7F,  // realtime universal sysex
                                                            0x01,  // device ID
                                                            0x02,  // subID 1
                                                            0x03,  // subID 2
                                                            0xF7]) // termination byte
        
        guard case .universalSysEx(let event) = sysEx else {
            XCTFail() ; return
        }
        
        XCTAssertEqual(event.universalType, .realTime)
        XCTAssertEqual(event.deviceID, 0x01)
        XCTAssertEqual(event.subID1, 0x02)
        XCTAssertEqual(event.subID2, 0x03)
        XCTAssertEqual(event.data, [])
        
    }
    
    func testMIDIEventSysEx_midi1SMFRawBytes_UniversalSysEx_WithData() throws {
        
        let sysEx = try MIDI.Event.sysEx(midi1SMFRawBytes: [0xF0,  // start byte
                                                            0x07,  // length: 7 bytes to follow
                                                            0x7E,  // non-realtime universal sysex
                                                            0x7F,  // device ID
                                                            0x00,  // subID 1
                                                            0x00,  // subID 2
                                                            0x12,  // data byte 1
                                                            0x34,  // data byte 2
                                                            0xF7]) // termination byte
        
        guard case .universalSysEx(let event) = sysEx else {
            XCTFail() ; return
        }
        
        
        XCTAssertEqual(event.universalType, .nonRealTime)
        XCTAssertEqual(event.deviceID, 0x7F)
        XCTAssertEqual(event.subID1, 0x00)
        XCTAssertEqual(event.subID2, 0x00)
        XCTAssertEqual(event.data, [0x12, 0x34])
        
    }
    
    // MARK: - MIDI.File.Event.SysEx
    
    func testSysEx_midi1SMFRawBytes_EmptyData() {
        
        let sysEx = MIDI.File.Event.SysEx(manufacturer: .oneByte(0x7D),
                                          data: [])
        
        let bytes = sysEx.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xF0,  // start byte
                               0x02,  // length: 2 bytes to follow
                               0x7D,  // manufacturer ID
                               0xF7]) // termination byte
        
    }
    
    func testSysEx_midi1SMFRawBytes_WithData() {
        
        let sysEx = MIDI.File.Event.SysEx(manufacturer: .oneByte(0x7D),
                                          data: [0x12, 0x34])
        
        let bytes = sysEx.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xF0,  // start byte
                               0x04,  // length: 4 bytes to follow
                               0x7D,  // manufacturer ID
                               0x12,  // data byte 1
                               0x34,  // data byte 2
                               0xF7]) // termination byte
        
    }
    
    func testSysEx_midi1SMFRawBytes_128Bytes() {
        
        let data: [MIDI.Byte] = .init(repeating: 0x12, count: 128 - 2)
        
        let sysEx = MIDI.File.Event.SysEx(manufacturer: .oneByte(0x7D),
                                          data: data)
        
        let bytes = sysEx.midi1SMFRawBytes
        
        XCTAssertEqual(bytes,
                       [0xF0,       // start byte
                        0x81, 0x00, // length: 128 bytes to follow
                        0x7D]       // manufacturer ID
                       + data +     // data bytes
                       [0xF7])      // termination byte
        
    }
    
    // MARK: - MIDI.File.Event.UniversalSysEx
    
    func testUniversalSysEx_midi1SMFRawBytes_EmptyData() {
        
        let sysEx = MIDI.File.Event.UniversalSysEx(universalType: .realTime,
                                                   deviceID: 0x01,
                                                   subID1: 0x02,
                                                   subID2: 0x03,
                                                   data: [])
        
        let bytes = sysEx.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xF0,  // start byte
                               0x05,  // length: 5 bytes to follow
                               0x7F,  // realtime universal sysex
                               0x01,  // device ID
                               0x02,  // subID 1
                               0x03,  // subID 2
                               0xF7]) // termination byte
        
    }
    
    func testUniversalSysEx_midi1SMFRawBytes_WithData() {
        
        let sysEx = MIDI.File.Event.UniversalSysEx(universalType: .nonRealTime,
                                                   deviceID: 0x7F,
                                                   subID1: 0x00,
                                                   subID2: 0x00,
                                                   data: [0x12, 0x34])
        
        let bytes = sysEx.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xF0,  // start byte
                               0x07,  // length: 7 bytes to follow
                               0x7E,  // non-realtime universal sysex
                               0x7F,  // device ID
                               0x00,  // subID 1
                               0x00,  // subID 2
                               0x12,  // data byte 1
                               0x34,  // data byte 2
                               0xF7]) // termination byte
        
    }
    
    func testUniversalSysEx_midi1SMFRawBytes_128Bytes() {
        
        let data: [MIDI.Byte] = .init(repeating: 0x12, count: 128 - 5)
        
        let sysEx = MIDI.File.Event.UniversalSysEx(universalType: .nonRealTime,
                                                   deviceID: 0x7F,
                                                   subID1: 0x01,
                                                   subID2: 0x02,
                                                   data: data)
        
        let bytes = sysEx.midi1SMFRawBytes
        
        XCTAssertEqual(bytes,
                       [0xF0,  // start byte
                        0x81, 0x00, // length: 128 bytes to follow
                        0x7E,  // non-realtime universal sysex
                        0x7F,  // device ID
                        0x01,  // subID 1
                        0x02]  // subID 2
                       + data +     // data bytes
                       [0xF7]) // termination byte
        
    }
    
    // MARK: - Edge Cases
    
    // see RP-001_v1-0_Standard_MIDI_Files_Specification_96-1-4.pdf pages 6-7
    #warning("> TODO: SysEx 0xF7 escape message handling")
    
}

#endif
