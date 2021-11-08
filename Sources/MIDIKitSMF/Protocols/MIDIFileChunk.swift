//
//  MIDIFileChunk.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import SwiftASCII

public protocol MIDIFileChunk {
    
    /// 4-character ASCII string identifying the chunk.
    ///
    /// For standard MIDI tracks, this is MTrk.
    /// For non-track chunks, any 4-character identifier can be used except for "MTrk".
    var identifier: ASCIIString { get }

    #warning("> TODO: add init from raw data, passing in midi header timing info etc.")
    
}
