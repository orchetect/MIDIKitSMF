//
//  MIDIFile encode Tests.swift
//  MIDIKitSMF
//
//  Created by Steffan Andrews on 2021-02-01.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

    import MIDIKitSMF
    import SwiftRadix
    import XCTest

    final class MIDIFileEncodeTests: XCTestCase {
        func testType0() {
            var midiFile = MIDIFile()

            midiFile.format = .singleTrack // Type 1
            midiFile.timing = .musical(ticksPerQuarterNote: 480)

            midiFile.chunks = [
                .track([
                    .text(.none, type: .trackOrSequenceName, string: "Seq-1"),
                ]),
            ]

            let constructedData = try! midiFile.rawData()
        }

        func testEncodeDP8Markers() {
            var midiFile = MIDIFile()

            midiFile.format = .multipleTracksSynchronous // Type 1
            midiFile.timing = .musical(ticksPerQuarterNote: 480)

            // 3 tracks

            midiFile.chunks = [
                .track([
                    .text(.none, type: .trackOrSequenceName, string: "Seq-1"),
                    .smpteOffset(.none, hr: 0, min: 0, sec: 0, fr: 0, subFr: 0, frRate: ._2997dfps),
                    .timeSignature(.none, numerator: 4, denominator: 2),
                    .tempo(.none, bpm: 120.0),
                    .text(.ticks(3_456_000), type: .marker, string: "Unlocked Marker 1_00_00_00"),
                    .text(.ticks(960), type: .cuePoint, string: "Locked Marker 1_00_01_00"),
                    .text(.ticks(960), type: .marker, string: "Unlocked Marker 1_00_02_00"),
                    .text(.ticks(960), type: .cuePoint, string: "Locked Marker 1_00_03_00"),
                    .text(.ticks(960), type: .marker, string: "Unlocked Marker 1_00_04_00"),
                ]),

                .track([
                    .text(.none, type: .trackOrSequenceName, string: "MIDI-1"),
                    .noteOn(.ticks(3_458_935), noteNum: 59, velocity: 64, channel: 0),
                    .noteOff(.ticks(864), noteNum: 59, velocity: 64, channel: 0),
                ]),

                .track([
                    .text(.none, type: .trackOrSequenceName, string: "MIDI-2"),
                    .midiChannelPrefix(.none, channel: 0),
                ]),
            ]

            // test if midiFile structs are equal by way of Equatable

            let dp8MarkersRawData = try! MIDIFile(rawData: kMIDIFile.DP8Markers.data)
            XCTAssertEqual(midiFile, dp8MarkersRawData)

            // test if raw data is equal

            let constructedData = try! midiFile.rawData()
            XCTAssertEqual(constructedData, kMIDIFile.DP8Markers.data)
        }
    }

#endif
