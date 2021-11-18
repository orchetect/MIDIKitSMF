//
//  Event ProgramChange Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF

final class Event_ProgramChange_Tests: XCTestCase {
    
    func testInit_midi1SMFRawBytes_A() throws {
        
        let bytes: [MIDI.Byte] = [0xC0, 0x40]
        
        let event = try MIDI.File.Event.ProgramChange(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.program, 0x40)
        XCTAssertEqual(event.channel, 0)
        
    }
    
    func testMIDI1SMFRawBytes_A() {
        
        let event = MIDI.File.Event.ProgramChange(program: 0x40,
                                                  bank: .noBankSelect,
                                                  channel: 0)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xC0, 0x40])
        
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        
        let bytes: [MIDI.Byte] = [0xC1, 0x7F]
        
        let event = try MIDI.File.Event.ProgramChange(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.program, 0x7F)
        XCTAssertEqual(event.channel, 1)
        
    }
    
    func testMIDI1SMFRawBytes_B() {
        
        let event = MIDI.File.Event.ProgramChange(program: 0x7F,
                                                  bank: .noBankSelect,
                                                  channel: 1)
        
        let bytes = event.midi1SMFRawBytes
        
        XCTAssertEqual(bytes, [0xC1, 0x7F])
        
    }
    
}

#endif
