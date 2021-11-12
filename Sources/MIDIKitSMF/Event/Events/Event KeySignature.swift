//
//  Event KeySignature.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

// MARK: - KeySignature

extension MIDI.File.Event {
    
    /// Key Signature event.
    ///
    /// For a format 1 MIDI file, Key Signature Meta events should only occur within the first MTrk chunk.
    ///
    /// If there are no key signature events in a MIDI file, C major is assumed.
    public struct KeySignature: Equatable, Hashable {
        
        /// Number of flats that identifies the key signature
        /// (-7 = 7 flats, -1 = 1 flat, 0 = key of C, 1 = 1 sharp, etc).
        public var flatsOrSharps: Int8 = 0 {
            didSet {
                if oldValue != flatsOrSharps { flatsOrSharps_Validate() }
            }
        }

        private mutating func flatsOrSharps_Validate() {
            
            flatsOrSharps = flatsOrSharps.clamped(to: -7 ... 7)
            
        }

        /// Major (true) or Minor (false) key.
        public var majorKey: Bool = true
        
        // MARK: - Init
        
        public init(flatsOrSharps: Int8,
                    majorKey: Bool) {
            
            self.flatsOrSharps = flatsOrSharps
            self.majorKey = majorKey
            
        }
        
    }
    
}

extension MIDI.File.Event.KeySignature: MIDIFileEvent {
    
    public static let smfEventType: MIDI.File.Event.EventType = .keySignature
    
    public init(midi1SMFRawBytes rawBytes: [MIDI.Byte]) throws {
        
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDI.File.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        // 3-byte preamble
        guard rawBytes.starts(with: MIDI.File.kEventHeaders[.keySignature]!) else {
            throw MIDI.File.DecodeError.malformed(
                "Event does not start with expected bytes."
            )
        }
        
        // flats/sharps - two's complement signed Int8
        let readFlatsOrSharps = Int8(bitPattern: rawBytes[3])
        // major/minor key - 1 or 0
        let readMajorKey = rawBytes[4]
        
        guard readFlatsOrSharps.isContained(in: -7 ... 7) else {
            throw MIDI.File.DecodeError.malformed(
                "Illegal value found when reading Key Signature event sharps/flats byte. Got \(readFlatsOrSharps.int) but value must be between -7...7."
            )
        }
        
        guard readMajorKey.isContained(in: 0 ... 1) else {
            throw MIDI.File.DecodeError.malformed(
                "Illegal value found when reading Key Signature event major/minor key byte. Got \(readFlatsOrSharps) but value must be between 0...1."
            )
        }
        
        flatsOrSharps = readFlatsOrSharps
        majorKey = !readMajorKey.boolValue
        
    }
    
    public var midi1SMFRawBytes: [MIDI.Byte] {
        
        // FF 59 02(length) sf mi
        // sf is a byte specifying the number of flats (-ve) or sharps (+ve) that identifies the key signature (-7 = 7 flats, -1 = 1 flat, 0 = key of C, 1 = 1 sharp, etc).
        // mi is a byte specifying a major (0) or minor (1) key.
        
        MIDI.File.kEventHeaders[.keySignature]! +
        // flats/sharps - two's complement signed Int8
        [flatsOrSharps.twosComplement] +
        // major/minor key - 1 or 0
        [majorKey ? 0x00 : 0x01]
        
    }
    
    static let midi1SMFFixedRawBytesLength = 5 

    public static func initFrom(midi1SMFRawBytesStream rawBuffer: Data) throws -> InitFromMIDI1SMFRawBytesStreamResult {
        
        let requiredData = rawBuffer.prefix(midi1SMFFixedRawBytesLength).bytes

        guard requiredData.count == midi1SMFFixedRawBytesLength else {
            throw MIDI.File.DecodeError.malformed(
                "Unexpected byte length."
            )
        }

        let newInstance = try Self(midi1SMFRawBytes: requiredData)

        return (newEvent: newInstance,
                bufferLength: midi1SMFFixedRawBytesLength)
        
    }
    
    public var smfDescription: String {
        
        stringValue
        
    }
    
    public var smfDebugDescription: String {
        
        "KeySignature(" + smfDescription + ")"
        
    }
    
}

extension MIDI.File.Event.KeySignature {
    
    public var stringValue: String {
        var outputString = ""

        switch flatsOrSharps {
        case ..<0:
            outputString += "\(abs(flatsOrSharps))♭"
        case 0:
            outputString += "No signature"
        case 1...:
            outputString += "\(flatsOrSharps)♯"
        default:
            // this should never happen
            outputString += "?"
        }

        switch majorKey {
        case true:
            outputString += " Major"
        case false:
            outputString += " Minor"
        }

        return outputString
    }
    
}
