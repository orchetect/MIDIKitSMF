//
//  MIDI File encode Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitSMF
import SwiftRadix

final class MIDIFileEncodeTests: XCTestCase {
    
    func testType0() {
        
        var midiFile = MIDI.File()
        
        midiFile.format = .singleTrack // Type 1
        midiFile.timeBase = .musical(ticksPerQuarterNote: 480)
        
        midiFile.chunks = [
            .track([
                .text(delta: .none, type: .trackOrSequenceName, string: "Seq-1"),
            ]),
        ]
        
        XCTAssertNoThrow {
            try midiFile.rawData()
        }
        
    }
    
    func testEncodeDP8Markers() throws {
        
        var midiFile = MIDI.File()
        
        midiFile.timeBase = .musical(ticksPerQuarterNote: 480)
        
        // 3 tracks
        
        midiFile.chunks = [
            .track([
                .text(delta: .none, type: .trackOrSequenceName, string: "Seq-1"),
                .smpteOffset(delta: .none, hr: 0, min: 0, sec: 0, fr: 0, subFr: 0, frRate: ._2997dfps),
                .timeSignature(delta: .none, numerator: 4, denominator: 2),
                .tempo(delta: .none, bpm: 120.0),
                .text(delta: .ticks(3_456_000), type: .marker, string: "Unlocked Marker 1_00_00_00"),
                .text(delta: .ticks(960), type: .cuePoint, string: "Locked Marker 1_00_01_00"),
                .text(delta: .ticks(960), type: .marker, string: "Unlocked Marker 1_00_02_00"),
                .text(delta: .ticks(960), type: .cuePoint, string: "Locked Marker 1_00_03_00"),
                .text(delta: .ticks(960), type: .marker, string: "Unlocked Marker 1_00_04_00")
            ]),
            
                .track([
                    .text(delta: .none, type: .trackOrSequenceName, string: "MIDI-1"),
                    .noteOn(delta: .ticks(3_458_935), note: 59, velocity: .midi1(64), channel: 0),
                    .noteOff(delta: .ticks(864), note: 59, velocity: .midi1(64), channel: 0)
                ]),
            
                .track([
                    .text(delta: .none, type: .trackOrSequenceName, string: "MIDI-2"),
                    .channelPrefix(delta: .none, channel: 0)
                ]),
        ]
        
        // test if midiFile structs are equal by way of Equatable
        
        let dp8MarkersRawData = try MIDI.File(rawData: kMIDIFile.DP8Markers.data)
        XCTAssertEqual(midiFile, dp8MarkersRawData)
        
        // test if raw data is equal
        
        let constructedData = try midiFile.rawData()
        XCTAssertEqual(constructedData, kMIDIFile.DP8Markers.data)
        
    }
    
}

#endif
