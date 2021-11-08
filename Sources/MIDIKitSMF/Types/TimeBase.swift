//
//  TimeBase.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore

// MARK: - timeBase

extension MIDI.File {
    
    /// MIDI file timbase as described in the MIDI file header.
    public enum TimeBase: Equatable {
        
        /// Musical: Delta-time ticks per quarter note (PPQN / PPQ / PPQBase).
        ///
        /// Common values: 96, 120, 480, 960. Cubase exports at 480 by default.
        /// Can also be a larger value if needed.
        /// Consider evenly divisible sub-divisions when determining this value.
        case musical(ticksPerQuarterNote: UInt16)
        
        /// Timecode
        ///
        /// Typical `ticksPerFrame` values are 4 (corresponding to MIDI Timecode), 8, 10, 80 (corresponding to SMPTE bit resolution), or 100.
        ///
        /// (A timing resolution of 1 ms can be achieved by specifying 25 fps and 40 sub-frames, which would be encoded in hex as E7 28.)
        case timecode(smpteFormat: FrameRate, ticksPerFrame: UInt8)
        
    }
    
}

extension MIDI.File.TimeBase {
    
    var rawData: Data {
        
        switch self {
        case let .musical(TicksPerQuarterNote):
            return (TicksPerQuarterNote & 0b0111_1111_1111_1111)
                .toData(.bigEndian)
            
        case let .timecode(smpteFormat, ticksPerFrame):
            return [smpteFormat.rawValue + 0b1000_0000,
                    ticksPerFrame]
                .data
        }
        
    }
    
}

extension MIDI.File.TimeBase {
    
    public init?(rawData: Data) {
        
        guard rawData.count == 2 else {
            return nil
        }
        
        self.init(rawBytes: Array(rawData.bytes.prefix(2)))
        
    }
    
    public init?(rawBytes bytes: [MIDI.Byte]) {
        
        guard bytes.count == 2 else {
            return nil
        }
        
        let byte1 = bytes[0]
        let byte2 = bytes[1]
        
        switch (byte1 & 0b1000_0000) >> 7 {
        case 0b0: // musical
            let ticks = ((UInt16(byte1) & 0b0111_1111) << 8) + UInt16(byte2)
            self = .musical(ticksPerQuarterNote: ticks)
            
        case 0b1: // timecode
            guard let fr = MIDI.File.FrameRate(rawValue: byte1 & 0b0111_1111) else {
                return nil
            }
            let ticks = byte2
            
            self = .timecode(smpteFormat: fr, ticksPerFrame: ticks)
            
        default:
            return nil
        }
        
    }
    
}

extension MIDI.File.TimeBase: CustomStringConvertible,
                              CustomDebugStringConvertible {
    
    public var description: String {
        
        switch self {
        case let .musical(ticksPerQuarterNote):
            return "Musical: \(ticksPerQuarterNote) ticks per quarter"
            
        case let .timecode(smpteFormat, ticksPerFrame):
            return "Timecode: \(smpteFormat) \(ticksPerFrame) ticks per frame"
        }
        
    }
    
    public var debugDescription: String {
        
        "timeBase(" + description + ")"
        
    }
    
}
