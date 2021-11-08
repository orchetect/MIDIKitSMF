//
//  Format.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import MIDIKit

// MARK: - Format

public extension MIDI.File {
    
    enum Format: UInt8, CaseIterable, Equatable {
        
        /// Type 0:
        /// MIDI file contains one single track containing midi data on possibly all 16 midi channels.
        case singleTrack = 0

        /// Type 1:
        /// MIDI file contains one or more simultaneous (ie, all start from an assumed time of 0) tracks, perhaps each on a single midi channel. Together, all of these tracks are considered one sequence or pattern.
        case multipleTracksSynchronous = 1

        /// Type 2:
        /// MIDI file contains one or more sequentially independent single-track patterns.
        case multipleTracksAsynchronous = 2
        
    }
    
}

extension MIDI.File.Format: CustomStringConvertible,
                            CustomDebugStringConvertible {
    
    public var description: String {
        
        switch self {
        case .singleTrack:
            return "Type 0 (single track)"
            
        case .multipleTracksSynchronous:
            return "Type 1 (multiple tracks synchronous)"
            
        case .multipleTracksAsynchronous:
            return "Type 2 (multiple tracks asynchronous)"
        }
        
    }

    public var debugDescription: String {
        
        "Format(" + description + ")"
        
    }
    
}
