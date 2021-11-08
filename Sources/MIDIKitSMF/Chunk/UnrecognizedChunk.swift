//
//  UnrecognizedChunk.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
import SwiftASCII
@_implementationOnly import SwiftRadix

extension MIDI.File.Chunk {
    
    public struct UnrecognizedChunk: MIDIFileChunk, Equatable {
        
        public let identifier: ASCIIString

        /// Contains the raw bytes of the chunk's data portion
        /// (NOT including the 4-character identifier or the length integer.)
        public var rawData: Data

        public init(id: ASCIIString, rawData: Data? = nil) {
            // identifier validation

            if id == Track().identifier ||
                id == Header().identifier
            {
                // don't allow non-track chunks to use SMF header or track identifier
                identifier = "----"

            } else if id.stringValue.count < 4 {
                identifier =
                    id.stringValue
                        .appending(String(repeating: "-",
                                          count: 4 - id.stringValue.count))
                        .asciiStringLossy

            } else if id.stringValue.count > 4 {
                identifier =
                    id.stringValue
                        .prefix(4)
                        .asciiStringLossy

            } else {
                identifier = id
            }

            // store raw data

            self.rawData = rawData ?? Data()
        }
        
    }
    
}

extension MIDI.File.Chunk.UnrecognizedChunk: CustomStringConvertible,
                                             CustomDebugStringConvertible {
    
    public var description: String {
        
        var outputString = ""

        outputString += "UnrecognizedChunk(".newLined
        outputString += "  identifier: \(identifier.stringValue)".newLined
        outputString += "  data: \(rawData.count) bytes".newLined
        outputString += ")"

        return outputString
        
    }

    public var debugDescription: String {
        
        let rawDataBlock = rawData.hex
            .stringValues(padTo: 2)
            .joined(separator: " ")
            .split(every: 3 * 16) // 16 bytes wide
            .reduce("") {
                $0 + "      " + $1.trimmed
            }

        var outputString = ""

        outputString += "UnrecognizedChunk(".newLined
        outputString += "  identifier: \(identifier.stringValue)".newLined
        outputString += "  data: \(rawData.count) bytes".newLined
        outputString += "    ("
        outputString += rawDataBlock
        outputString += "    )"
        outputString += ")"

        return outputString
    }
    
}
