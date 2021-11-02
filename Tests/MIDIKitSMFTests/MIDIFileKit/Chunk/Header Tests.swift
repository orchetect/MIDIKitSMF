//
//  Header Tests.swift
//  MIDIKitSMF
//
//  Created by Steffan Andrews on 2021-02-03.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

    @testable import MIDIKitSMF
    import OTCore
    import XCTest

    final class Chunk_Header_Tests: XCTestCase {
        func testInit_Type0() {
            let header = MIDIFile.Chunk.Header(format: .singleTrack,
                                               timing: .musical(ticksPerQuarterNote: 720))

            XCTAssertEqual(header.format, .singleTrack)
            XCTAssertEqual(header.timing, .musical(ticksPerQuarterNote: 720))

            let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64,
                                    0x00, 0x00, 0x00, 0x06,
                                    0x00, 0x00,
                                    0x00, 0x01,
                                    0x02, 0xD0]

            XCTAssertEqual(try! header.rawData(withChunkCount: 1).bytes, rawData)
        }

        func testInit_Type0_rawData() {
            let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64,
                                    0x00, 0x00, 0x00, 0x06,
                                    0x00, 0x00,
                                    0x00, 0x01,
                                    0x02, 0xD0]

            let header = try! MIDIFile.Chunk.Header(rawBuffer: rawData.data)

            XCTAssertEqual(header.format, .singleTrack)
            XCTAssertEqual(header.timing, .musical(ticksPerQuarterNote: 720))
        }

        func testInit_Type1() {
            let header = MIDIFile.Chunk.Header(format: .multipleTracksSynchronous,
                                               timing: .musical(ticksPerQuarterNote: 720))

            XCTAssertEqual(header.format, .multipleTracksSynchronous)
            XCTAssertEqual(header.timing, .musical(ticksPerQuarterNote: 720))

            let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64,
                                    0x00, 0x00, 0x00, 0x06,
                                    0x00, 0x01,
                                    0x00, 0x02,
                                    0x02, 0xD0]

            XCTAssertEqual(try! header.rawData(withChunkCount: 2).bytes, rawData)
        }

        func testInit_Type1_rawData() {
            let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64,
                                    0x00, 0x00, 0x00, 0x06,
                                    0x00, 0x01,
                                    0x00, 0x02,
                                    0x02, 0xD0]

            let header = try! MIDIFile.Chunk.Header(rawBuffer: rawData.data)

            XCTAssertEqual(header.format, .multipleTracksSynchronous)
            XCTAssertEqual(header.timing, .musical(ticksPerQuarterNote: 720))
        }

        func testInit_Type2() {
            let header = MIDIFile.Chunk.Header(format: .multipleTracksAsynchronous,
                                               timing: .musical(ticksPerQuarterNote: 720))

            XCTAssertEqual(header.format, .multipleTracksAsynchronous)
            XCTAssertEqual(header.timing, .musical(ticksPerQuarterNote: 720))

            let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64,
                                    0x00, 0x00, 0x00, 0x06,
                                    0x00, 0x02,
                                    0x00, 0x02,
                                    0x02, 0xD0]

            XCTAssertEqual(try! header.rawData(withChunkCount: 2).bytes, rawData)
        }

        func testInit_Type2_rawData() {
            let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64,
                                    0x00, 0x00, 0x00, 0x06,
                                    0x00, 0x02,
                                    0x00, 0x02,
                                    0x02, 0xD0]

            let header = try! MIDIFile.Chunk.Header(rawBuffer: rawData.data)

            XCTAssertEqual(header.format, .multipleTracksAsynchronous)
            XCTAssertEqual(header.timing, .musical(ticksPerQuarterNote: 720))
        }
    }

#endif
