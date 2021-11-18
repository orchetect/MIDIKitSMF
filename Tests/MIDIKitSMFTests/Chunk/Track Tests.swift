//
//  Track Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF
import OTCore

final class Chunk_Track_Tests: XCTestCase {
    
    func testEmptyEvents() throws {
        
        let events: [MIDI.File.Event] = []
        
        let track = MIDI.File.Chunk.Track(events: events)
        
        XCTAssertEqual(track.events, events)
        
        let bytes: [MIDI.Byte] = [
            0x4D, 0x54, 0x72, 0x6B, // MTrk
            0x00, 0x00, 0x00, 0x04, // length: 4 bytes to follow
            0x00,                   // delta time prior to chunk end
            0xFF, 0x2F, 0x00        // chunk end
        ]
        
        // generate raw bytes
        
        let generatedBytes = try track.midi1SMFRawBytes(
            using: .musical(ticksPerQuarterNote: 960)
        ).bytes
        
        XCTAssertEqual(generatedBytes, bytes)
        
        // parse raw bytes
        
        let parsedTrack = try MIDI.File.Chunk.Track(midi1SMFRawBytesStream: generatedBytes)
        
        XCTAssertEqual(parsedTrack, parsedTrack)
        
    }
    
    func testWithEvents() throws {
        
        let events: [MIDI.File.Event] = [
            .noteOn(delta: .none, note: 60, velocity: .midi1(64), channel: 0),
            .cc(delta: .ticks(240), controller: .expression, value: .midi1(20), channel: 1)
        ]
        
        let track = MIDI.File.Chunk.Track(events: events)
        
        XCTAssertEqual(track.events, events)
        
        let bytes: [MIDI.Byte] = [
            0x4D, 0x54, 0x72, 0x6B, // MTrk
            0x00, 0x00, 0x00, 0x0D, // length: 13 bytes to follow
            0x00,                   // delta time
            0x90, 0x3C, 0x40,       // note on event
            0x81, 0x70,             // delta time
            0xB1, 0x0B, 0x14,       // cc event
            0x00,                   // delta time prior to chunk end
            0xFF, 0x2F, 0x00        // chunk end
        ]
        
        // generate raw bytes
        
        let generatedBytes = try track.midi1SMFRawBytes(
            using: .musical(ticksPerQuarterNote: 960)
        ).bytes
        
        XCTAssertEqual(generatedBytes, bytes)
        
        // parse raw bytes
        
        let parsedTrack = try MIDI.File.Chunk.Track(midi1SMFRawBytesStream: generatedBytes)
        
        XCTAssertEqual(parsedTrack, parsedTrack)
        
        
    }
    
    // MARK: - Edge Cases
    
}

#endif
