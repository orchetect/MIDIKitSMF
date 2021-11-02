//
//  Timing Tests.swift
//  MIDIKitSMF
//
//  Created by Steffan Andrews on 2021-02-03.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

    @testable import MIDIKitSMF
    import OTCore
    import XCTest

    final class Timing_Tests: XCTestCase {
        func testInitMusical() {
            let timing = MIDIFile.Timing.musical(ticksPerQuarterNote: 480)

            let rawData: [UInt8] = [0x01, 0xE0]

            XCTAssertEqual(timing.rawData.bytes, rawData)

            do {
                guard case let .musical(tpq)
                    = MIDIFile.Timing(rawBytes: rawData)!
                else { XCTFail(); return }

                XCTAssertEqual(tpq, 480)
            }

            do {
                guard case let .musical(tpq)
                    = MIDIFile.Timing(rawData: rawData.data)!
                else { XCTFail(); return }

                XCTAssertEqual(tpq, 480)
            }
        }

        func testInitTimecode() {
            let timing = MIDIFile.Timing.timecode(smpteFormat: ._25fps, ticksPerFrame: 80)

            let rawData: [UInt8] = [0b1110_0111, 0x50]

            XCTAssertEqual(timing.rawData.bytes, rawData)

            do {
                guard case let .timecode(smpteFormat, ticksPerFrame)
                    = MIDIFile.Timing(rawBytes: rawData)
                else { XCTFail(); return }

                XCTAssertEqual(smpteFormat, ._25fps)
                XCTAssertEqual(ticksPerFrame, 80)
            }

            do {
                guard case let .timecode(smpteFormat, ticksPerFrame)
                    = MIDIFile.Timing(rawData: rawData.data)
                else { XCTFail(); return }

                XCTAssertEqual(smpteFormat, ._25fps)
                XCTAssertEqual(ticksPerFrame, 80)
            }
        }
    }

#endif
