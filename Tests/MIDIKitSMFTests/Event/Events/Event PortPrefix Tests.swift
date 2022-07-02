//
//  Event PortPrefix Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class Event_PortPrefix_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x21, 0x01, 0x02]
        
        let event = try MIDI.File.Event.PortPrefix(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.port, 2)
        
    }
    
    func testMIDI1SMFRawBytes() {
        
        let event = MIDI.File.Event.PortPrefix(port: 2)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x21, 0x01, 0x02])
        
    }
    
}

#endif
