//
//  MIDI File encode.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
import SwiftASCII

extension MIDI.File {
    
    func encode() throws -> Data {
        
        // basic validation checks

        guard chunks.count <= UInt16.max else {
            throw EncodeError.internalInconsistency(
                "Chunk count exceeds maximum."
            )
        }

        var data = Data()

        // ____ Header ____

        data += try header.midi1SMFRawBytes(withChunkCount: chunks.count)

        // ____ Chunks ____

        for chunk in chunks {
            switch chunk {
            case let .track(track):
                data += try track.midi1SMFRawBytes(using: timeBase)

            case let .other(unrecognizedChunk):
                data += try unrecognizedChunk.midi1SMFRawBytes(using: timeBase)
            }
        }

        return data
        
    }
    
}
