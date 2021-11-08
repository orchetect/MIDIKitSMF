//
//  SMPTEOffsetFrameRate.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import MIDIKit

// MARK: - SMPTEOffsetFrameRate

public extension MIDI.File {
    
    /// For use in SMPTE Offset track events
    enum SMPTEOffsetFrameRate: MIDI.Byte, CaseIterable, Equatable, Hashable {

        case _24fps    = 0b00 // 0 decimal
        case _25fps    = 0b01 // 1 decimal
        case _2997dfps = 0b10 // 2 decimal
        case _30fps    = 0b11 // 3 decimal
        
    }
    
}

extension MIDI.File.SMPTEOffsetFrameRate: CustomStringConvertible,
                                          CustomDebugStringConvertible {
    
    public var description: String {
        
        switch self {
        case ._24fps:
            return "24fps"
            
        case ._25fps:
            return "25fps"
            
        case ._2997dfps:
            return "29.97dfps"
            
        case ._30fps:
            return "30fps"
        }
        
    }

    public var debugDescription: String {
        
        "SMPTEOffsetFrameRate(" + description + ")"
        
    }
    
}
