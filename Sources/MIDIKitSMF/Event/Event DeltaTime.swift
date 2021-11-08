//
//  Event DeltaTime.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Darwin
import MIDIKit

// MARK: - DeltaTime

extension MIDI.File {
    
    /// Delta time advancement.
    public enum DeltaTime {
        
        case none

        case ticks(UInt32)

        // TODO: ***** Could add milliseconds calculation later
        // case milliseconds(Double)

        case wholeNote
        case halfNote
        case quarterNote
        case _8thNote
        case _16thNote
        case _32ndNote
        case _64thNote
        case _128thNote
        case _256thNote
        
    }
    
}

extension MIDI.File.DeltaTime {
    
    public init?(ticks: UInt32,
                 using timeBase: MIDI.File.TimeBase) {
        
        #warning("> TODO: add init here that sets self = a certain enum case based on provided ticks and provided timing mode")
        
        self = .ticks(ticks)
        
    }
    
}

// MARK: - Equatable

extension MIDI.File.DeltaTime: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        let timing = MIDI.File.TimeBase.musical(ticksPerQuarterNote: 960)

        return lhs.ticksValue(using: timing) == rhs.ticksValue(using: timing)
        
    }
    
}

extension MIDI.File.DeltaTime: Hashable {
    
    // synthesized
    
}

// MARK: - CustomStringConvertible

extension MIDI.File.DeltaTime: CustomStringConvertible,
                               CustomDebugStringConvertible {
    
    public var description: String {
        
        switch self {
        case .none:             return "none"
        case let .ticks(ticks): return "ticks:\(ticks)"
        case .wholeNote:        return "wholeNote"
        case .halfNote:         return "halfNote"
        case .quarterNote:      return "quarterNote"
        case ._8thNote:         return "8thNote"
        case ._16thNote:        return "16thNote"
        case ._32ndNote:        return "32ndNote"
        case ._64thNote:        return "64thNote"
        case ._128thNote:       return "128thNote"
        case ._256thNote:       return "256thNote"
        }
        
    }

    public var debugDescription: String {
        
        "DeltaTime(" + description + ")"
        
    }
    
}

// MARK: - ticksValue

public extension MIDI.File.DeltaTime {
    
    func ticksValue(using timing: MIDI.File.TimeBase) -> UInt32 {
        
        let midiFileTicksPerQuarter: UInt32

        switch timing {
        case let .musical(ticksPerQuarterNote):
            midiFileTicksPerQuarter = UInt32(ticksPerQuarterNote)

        case let .timecode(smpteFormat, ticksPerFrame):
            _ = smpteFormat
            _ = ticksPerFrame
            fatalError("Timecode timing mode not implemented yet.")
        }

        switch self {
        case .none:
            return 0

        case let .ticks(val):
            return val

        case .wholeNote:
            return midiFileTicksPerQuarter * UInt32(pow(2.0, 2.0))

        case .halfNote:
            return midiFileTicksPerQuarter * 2

        case .quarterNote:
            return midiFileTicksPerQuarter

        case ._8thNote:
            return midiFileTicksPerQuarter / 2

        case ._16thNote:
            return midiFileTicksPerQuarter / UInt32(pow(2.0, 2.0))

        case ._32ndNote:
            return midiFileTicksPerQuarter / UInt32(pow(2.0, 3.0))

        case ._64thNote:
            return midiFileTicksPerQuarter / UInt32(pow(2.0, 4.0))

        case ._128thNote:
            return midiFileTicksPerQuarter / UInt32(pow(2.0, 5.0))

        case ._256thNote:
            return midiFileTicksPerQuarter / UInt32(pow(2.0, 6.0))
        }
        
    }
    
}
