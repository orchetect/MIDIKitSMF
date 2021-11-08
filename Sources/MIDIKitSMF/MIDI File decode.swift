//
//  MIDI File decode.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
import SwiftASCII
@_implementationOnly import SwiftRadix

extension MIDI.File {
    
    mutating func decode(rawData data: Data) throws {
        
        // basic checks

        guard !data.isEmpty else {
            throw DecodeError.malformed(
                "MIDI data is empty / contains no bytes."
            )
        }

        // reset values to a known state

        chunks = []
        header = .init() // resets format and timing

        // begin parse

        var dataReader = DataReader(data)

        // ____ Header ____

        guard let readHeader = dataReader.read(bytes: Chunk.Header.staticRawBytesLength) else {
            throw MIDI.File.DecodeError.malformed(
                "Header is not correct. File may not be a MIDI file."
            )
        }

        header = try Chunk.Header(midi1SMFRawBytes: readHeader)

        // chunks

        var tracksEncountered = 0
        var endOfFile = false

        var newChunks: [Chunk] = []

        while !endOfFile {
            // chunk header

            guard let chunkType = dataReader.read(bytes: 4) else {
                throw DecodeError.malformed(
                    "There was a problem reading chunk header. Encountered end of file early."
                )
            }

            guard let chunkLength = dataReader.read(bytes: 4)?
                    .toUInt32(from: .bigEndian)?
                    .int
            else {
                throw DecodeError.malformed(
                    "There was a problem reading chunk length. Encountered end of file early."
                )
            }

            let chunkTypeString = ASCIIString(exactly: chunkType) ?? "????"

            switch chunkTypeString {
            case MIDI.File.Chunk.Track.staticIdentifier:

                tracksEncountered += 1

                // chunk length

                guard let trackData = dataReader.read(bytes: chunkLength) else {
                    throw DecodeError.malformed(
                        "There was a problem reading track data blob for track \(tracksEncountered). Encountered end of file early."
                    )
                }

                let newTrack: Chunk.Track

                do {
                    newTrack = try Chunk.Track(midi1SMFRawBytes: trackData.bytes)
                } catch let error as DecodeError {
                    // append some context for the error and rethrow it

                    switch error {
                    case .malformed(let verboseError):
                        throw DecodeError.malformed(
                            "There was a problem reading track data for track \(tracksEncountered). " + verboseError
                        )

                    default:
                        throw error
                    }
                }

                newChunks += .track(newTrack)

            default:
                // as per Standard MIDI File Spec 1.0,
                // unrecognized chunks should be skipped and not throw an error

                Log.debug("Encountered unrecognized MIDI file chunk identifier: \(chunkTypeString)")

                let readRawData = dataReader.read(bytes: chunkLength)

                let newUnrecognizedChunk = Chunk.UnrecognizedChunk(id: chunkTypeString,
                                                                   rawData: readRawData)

                newChunks += .other(newUnrecognizedChunk)
            }

            if dataReader.readPosition >= dataReader.base.count {
                endOfFile = true
            }
        }

        chunks = newChunks
        
    }
    
}
