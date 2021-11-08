//
//  Chunk.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit

public extension MIDI.File {
    
    enum Chunk: Equatable {
        
        case track(Track)
        case other(UnrecognizedChunk)
        
    }
    
}

public extension MIDI.File.Chunk {
    
    static func track(_ events: [MIDI.File.Event]) -> Self {
        
        .track(.init(events: events))
        
    }
    
    static func other(id: ASCIIString, rawData: Data? = nil) -> Self {
        
        .other(.init(id: id, rawData: rawData))
        
    }
    
}

extension MIDI.File.Chunk: CustomStringConvertible,
                           CustomDebugStringConvertible {
    
    public var description: String {
        
        switch self {
        case let .track(track):
            return track.description
            
        case let .other(unrecognizedChunk):
            return unrecognizedChunk.description
        }
        
    }
    
    public var debugDescription: String {
        
        switch self {
        case let .track(track):
            return track.debugDescription
            
        case let .other(unrecognizedChunk):
            return unrecognizedChunk.debugDescription
        }
        
    }
    
}

public extension MIDI.File.Chunk {
    
    /// Unwraps the enum case and returns the `MIDI.File.Chunk` contained within, typed as `MIDI.FileChunk` protocol.
    var unwrapped: MIDIFileChunk {
        
        switch self {
        case let .track(chunk):
            return chunk
            
        case let .other(chunk):
            return chunk
        }
        
    }
    
}

public extension MIDIFileChunk {
    
    /// Wraps the concrete struct in its corresponding `MIDI.File.Chunk` enum case wrapper.
    var wrapped: MIDI.File.Chunk {
        
        switch self {
        case let chunk as MIDI.File.Chunk.Track:
            return .track(chunk)
            
        case let chunk as MIDI.File.Chunk.UnrecognizedChunk:
            return .other(chunk)
            
        default:
            fatalError()
        }
        
    }
    
}
