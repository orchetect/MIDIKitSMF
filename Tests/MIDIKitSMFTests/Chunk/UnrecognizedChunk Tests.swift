//
//  UnrecognizedChunk Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF
import OTCore

final class Chunk_UnrecognizedChunk_Tests: XCTestCase {
    
    func testEmptyData() throws {
        
        let id: ASCIIString = "ABCD"
        
        let track = MIDI.File.Chunk.UnrecognizedChunk(id: id)
        
        XCTAssertEqual(track.identifier, id)
        
        let bytes: [MIDI.Byte] = [
            0x41, 0x42, 0x43, 0x44, // ABCD
            0x00, 0x00, 0x00, 0x00, // length: 0 bytes to follow
        ]
        
        // generate raw bytes
        
        let generatedBytes = try track.midi1SMFRawBytes(
            using: .musical(ticksPerQuarterNote: 960)
        ).bytes
        
        XCTAssertEqual(generatedBytes, bytes)
        
        // parse raw bytes
        
        let parsedTrack = try MIDI.File.Chunk.UnrecognizedChunk(midi1SMFRawBytesStream: generatedBytes)

        XCTAssertEqual(parsedTrack, parsedTrack)
        
    }
    
    func testWithData() throws {
        
        let data: [MIDI.Byte] = [0x12, 0x34, 0x56, 0x78]
        
        let id: ASCIIString = "ABCD"
        
        let track = MIDI.File.Chunk.UnrecognizedChunk(id: id,
                                                      rawData: data.data)
        
        XCTAssertEqual(track.identifier, id)
        
        let bytes: [MIDI.Byte] = [
            0x41, 0x42, 0x43, 0x44, // ABCD
            0x00, 0x00, 0x00, 0x04] // length: 4 bytes to follow
        + data  // data bytes
        
        // generate raw bytes
        
        let generatedBytes = try track.midi1SMFRawBytes(
            using: .musical(ticksPerQuarterNote: 960)
        ).bytes
        
        XCTAssertEqual(generatedBytes, bytes)
        
        // parse raw bytes
        
        let parsedTrack = try MIDI.File.Chunk.UnrecognizedChunk(midi1SMFRawBytesStream: generatedBytes)

        XCTAssertEqual(parsedTrack, parsedTrack)
        
    }
    
    // MARK: - Edge Cases
    
}

#endif
