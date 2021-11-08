//
//  MIDIFile Errors.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import MIDIKit

public extension MIDI.File {
    
    enum DecodeError: Error {
        
        // more cases will be added later when MIDI file reading/decoding is added to the library

        case fileNotFound
        case malformedURL
        case fileReadError

        case malformed(_ verboseError: String)
        
    }

    enum EncodeError: Error {
        
        /// Internal Inconsistency. `verboseError` contains the specific reason.
        case internalInconsistency(_ verboseError: String)
        
    }
    
}
