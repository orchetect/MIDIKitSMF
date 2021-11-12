//
//  Header Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSMF
import OTCore

final class Chunk_Header_Tests: XCTestCase {
    
    func testInit_Type0() throws {
        
        let header = MIDI.File.Chunk.Header(format: .singleTrack,
                                            timeBase: .musical(ticksPerQuarterNote: 720))
        
        XCTAssertEqual(header.format, .singleTrack)
        XCTAssertEqual(header.timeBase, .musical(ticksPerQuarterNote: 720))
        
        let rawData: [MIDI.Byte] = [0x4D, 0x54, 0x68, 0x64,
                                    0x00, 0x00, 0x00, 0x06,
                                    0x00, 0x00,
                                    0x00, 0x01,
                                    0x02, 0xD0]
        
        XCTAssertEqual(try header.midi1SMFRawBytes(withChunkCount: 1).bytes, rawData)
        
    }
    
    func testInit_Type0_rawData() throws {
        
        let rawData: [MIDI.Byte] = [0x4D, 0x54, 0x68, 0x64,
                                    0x00, 0x00, 0x00, 0x06,
                                    0x00, 0x00,
                                    0x00, 0x01,
                                    0x02, 0xD0]
        
        let header = try MIDI.File.Chunk.Header(midi1SMFRawBytes: rawData.data)
        
        XCTAssertEqual(header.format, .singleTrack)
        XCTAssertEqual(header.timeBase, .musical(ticksPerQuarterNote: 720))
        
    }
    
    func testInit_Type1() throws {
        
        let header = MIDI.File.Chunk.Header(format: .multipleTracksSynchronous,
                                            timeBase: .musical(ticksPerQuarterNote: 720))
        
        XCTAssertEqual(header.format, .multipleTracksSynchronous)
        XCTAssertEqual(header.timeBase, .musical(ticksPerQuarterNote: 720))
        
        let rawData: [MIDI.Byte] = [0x4D, 0x54, 0x68, 0x64,
                                    0x00, 0x00, 0x00, 0x06,
                                    0x00, 0x01,
                                    0x00, 0x02,
                                    0x02, 0xD0]
        
        XCTAssertEqual(try header.midi1SMFRawBytes(withChunkCount: 2).bytes, rawData)
        
    }
    
    func testInit_Type1_rawData() throws {
        
        let rawData: [MIDI.Byte] = [0x4D, 0x54, 0x68, 0x64,
                                    0x00, 0x00, 0x00, 0x06,
                                    0x00, 0x01,
                                    0x00, 0x02,
                                    0x02, 0xD0]
        
        let header = try MIDI.File.Chunk.Header(midi1SMFRawBytes: rawData.data)
        
        XCTAssertEqual(header.format, .multipleTracksSynchronous)
        XCTAssertEqual(header.timeBase, .musical(ticksPerQuarterNote: 720))
        
    }
    
    func testInit_Type2() throws {
        
        let header = MIDI.File.Chunk.Header(format: .multipleTracksAsynchronous,
                                            timeBase: .musical(ticksPerQuarterNote: 720))
        
        XCTAssertEqual(header.format, .multipleTracksAsynchronous)
        XCTAssertEqual(header.timeBase, .musical(ticksPerQuarterNote: 720))
        
        let rawData: [MIDI.Byte] = [0x4D, 0x54, 0x68, 0x64,
                                    0x00, 0x00, 0x00, 0x06,
                                    0x00, 0x02,
                                    0x00, 0x02,
                                    0x02, 0xD0]
        
        XCTAssertEqual(try header.midi1SMFRawBytes(withChunkCount: 2).bytes, rawData)
        
    }
    
    func testInit_Type2_rawData() throws {
        
        let rawData: [MIDI.Byte] = [0x4D, 0x54, 0x68, 0x64,
                                    0x00, 0x00, 0x00, 0x06,
                                    0x00, 0x02,
                                    0x00, 0x02,
                                    0x02, 0xD0]
        
        let header = try MIDI.File.Chunk.Header(midi1SMFRawBytes: rawData.data)
        
        XCTAssertEqual(header.format, .multipleTracksAsynchronous)
        XCTAssertEqual(header.timeBase, .musical(ticksPerQuarterNote: 720))
        
    }
    
}

#endif
