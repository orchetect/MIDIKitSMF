//
//  MIDIFile encode.swift
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

        try data += header.rawData(withChunkCount: chunks.count)

        // ____ Chunks ____

        for chunk in chunks {
            var chunkData = Data()
            var chunkIdentifier: ASCIIString

            switch chunk {
            case let .track(track):
                chunkIdentifier = track.identifier
                chunkData += track.rawData(using: timing)

            case let .other(unrecognizedChunk):
                chunkIdentifier = unrecognizedChunk.identifier
                chunkData += unrecognizedChunk.rawData
            }

            // 4-byte chunk identifier
            data += chunkIdentifier.rawData

            // Chunk data length (32-bit 4 byte big endian integer)
            if let trackLength = UInt32(exactly: chunkData.count) {
                data += trackLength.toData(.bigEndian)
            } else {
                // track length overflows max length integer size
                // maximum track data size is 4.294967296 GB (UInt32.max bytes)
                throw EncodeError.internalInconsistency(
                    "Chunk length overflowed maximum size."
                )
            }

            // Track events
            data += chunkData
        }

        return data
        
    }
    
}
