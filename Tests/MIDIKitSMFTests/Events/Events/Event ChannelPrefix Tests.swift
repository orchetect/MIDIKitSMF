//
//  Event ChannelPrefix Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF

final class Event_ChannelPrefix_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes() throws {
        
        let bytes: [MIDI.Byte] = [0xFF, 0x20, 0x01, 0x02]
        
        let event = try MIDI.File.Event.ChannelPrefix(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.channel, 2)
        
    }
    
    func testMIDI1SMFRawBytes() {
        
        let event = MIDI.File.Event.ChannelPrefix(channel: 2)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xFF, 0x20, 0x01, 0x02])
        
    }
    
}

#endif
