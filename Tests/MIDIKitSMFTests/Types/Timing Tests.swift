//
//  TimeBase Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if !os(watchOS)

@testable import MIDIKitSMF
import OTCore
import XCTest

final class TimeBase_Tests: XCTestCase {
    
    func testInitMusical() {
        
        let timeBase = MIDI.File.TimeBase.musical(ticksPerQuarterNote: 480)
        
        let rawData: [MIDI.Byte] = [0x01, 0xE0]
        
        XCTAssertEqual(timeBase.rawData.bytes, rawData)
        
        do {
            guard case let .musical(tpq)
                    = MIDI.File.TimeBase(rawBytes: rawData)!
            else { XCTFail(); return }
            
            XCTAssertEqual(tpq, 480)
        }
        
        do {
            guard case let .musical(tpq)
                    = MIDI.File.TimeBase(rawData: rawData.data)!
            else { XCTFail(); return }
            
            XCTAssertEqual(tpq, 480)
        }
        
    }
    
    func testInitTimecode() {
        
        let timeBase = MIDI.File.TimeBase.timecode(smpteFormat: ._25fps, ticksPerFrame: 80)
        
        let rawData: [MIDI.Byte] = [0b1110_0111, 0x50]
        
        XCTAssertEqual(timeBase.rawData.bytes, rawData)
        
        do {
            guard case let .timecode(smpteFormat, ticksPerFrame)
                    = MIDI.File.TimeBase(rawBytes: rawData)
            else { XCTFail(); return }
            
            XCTAssertEqual(smpteFormat, ._25fps)
            XCTAssertEqual(ticksPerFrame, 80)
        }
        
        do {
            guard case let .timecode(smpteFormat, ticksPerFrame)
                    = MIDI.File.TimeBase(rawData: rawData.data)
            else { XCTFail(); return }
            
            XCTAssertEqual(smpteFormat, ._25fps)
            XCTAssertEqual(ticksPerFrame, 80)
        }
        
    }
    
}

#endif
