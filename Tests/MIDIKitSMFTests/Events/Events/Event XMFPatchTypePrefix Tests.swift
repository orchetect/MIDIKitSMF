//
//  Event XMFPatchTypePrefix Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF

final class Event_XMFPatchTypePrefix_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes_A() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x60, // header
                                  0x01,       // length (always 1)
                                  0x01]       // param
        
        let event = try MIDI.File.Event.XMFPatchTypePrefix(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.patchSet, .generalMIDI1)
        
    }
    
    func testMIDI1SMFRawBytes_A() {
        
        let event = MIDI.File.Event.XMFPatchTypePrefix(patchSet: .generalMIDI1)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x60, // header
                               0x01,       // length (always 1)
                               0x01])      // param
        
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x60, // header
                                  0x01,       // length (always 1)
                                  0x02]       // param
        
        let event = try MIDI.File.Event.XMFPatchTypePrefix(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.patchSet, .generalMIDI2)
        
    }
    
    func testMIDI1SMFRawBytes_B() {
        
        let event = MIDI.File.Event.XMFPatchTypePrefix(patchSet: .generalMIDI2)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x60, // header
                               0x01,       // length (always 1)
                               0x02])      // param
        
    }
    
    // MARK: - Edge Cases
    
    func testUndefinedParam() {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x60, // header
                                  0x01,       // length (always 1)
                                  0x20]       // param (undefined)
        
        XCTAssertThrowsError(
            try MIDI.File.Event.XMFPatchTypePrefix(midi1SMFRawBytes: bytes)
        )
        
    }
    
}

#endif
