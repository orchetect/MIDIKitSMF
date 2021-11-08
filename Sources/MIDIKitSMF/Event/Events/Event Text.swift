//
//  Event Text.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
import SwiftASCII
@_implementationOnly import SwiftRadix

// MARK: - Text

extension MIDI.File.Event {
    
    public struct Text: Equatable, Hashable {
        
        /// Type of text event.
        public var textType: TextEventType = .text
        
        /// Text content.
        ///
        /// ASCII text only. If extended characters or encodings are used, it will be converted to ASCII before encoding into the MIDI file.
        ///
        /// (Arbitrary limit imposed: truncates at 65,536 characters long.)
        public var text: ASCIIString = "" {
            didSet {
                if oldValue != text { text_Validate() }
            }
        }

        private mutating func text_Validate() {
            if text.stringValue.count > 65536 {
                text = ASCIIString(String(text.stringValue.prefix(65536)))
            }
        }

        // MARK: - Init

        public init() { }

        public init(type: TextEventType,
                    string: ASCIIString) {
            
            textType = type
            text = string
            
            text_Validate()
            
        }

        // MARK: - Init (types)

        public init(copyright: ASCIIString) {
            self.init(type: .copyright, string: copyright)
        }

        public init(marker: ASCIIString) {
            self.init(type: .marker, string: marker)
        }

        public init(cuePoint: ASCIIString) {
            self.init(type: .cuePoint, string: cuePoint)
        }

        public init(trackOrSequenceName: ASCIIString) {
            self.init(type: .trackOrSequenceName, string: trackOrSequenceName)
        }

        public init(instrumentName: ASCIIString) {
            self.init(type: .instrumentName, string: instrumentName)
        }

        public init(text: ASCIIString) {
            self.init(type: .text, string: text)
        }

        public init(programName: ASCIIString) {
            self.init(type: .programName, string: programName)
        }

        public init(deviceName: ASCIIString) {
            self.init(type: .deviceName, string: deviceName)
        }

        public init(lyric: ASCIIString) {
            self.init(type: .lyric, string: lyric)
        }

    }
    
}

extension MIDI.File.Event.Text: MIDIFileEvent {
    
    public static let smfEventType: MIDI.File.Event.EventType = .text
    
    public init(midi1SMFRawBytes rawBytes: [MIDI.Byte]) throws {
        
        let result = try Self.initFrom(rawBuffer: rawBytes).newEvent
        
        textType = result.textType
        text = result.text
        
    }
    
    public var midi1SMFRawBytes: [MIDI.Byte] {
        
        // FF 01 length text
        
        let stringData = text.rawData.bytes
        
        return MIDI.File.kTextEventHeaders[textType]! +
            // length
            MIDI.File.encodeVariableLengthValue(stringData.count) +
            // text
            stringData
        
    }

    public static func initFrom(midi1SMFRawBytesStream rawBuffer: Data) -> InitFromMIDI1SMFRawBytesStreamResult? {
        try? Self.initFrom(rawBuffer: rawBuffer.bytes)
    }

    internal static func initFrom(
        rawBuffer rawBytes: [MIDI.Byte]
    ) throws -> InitFromMIDI1SMFRawBytesStreamResult {
        
        guard rawBytes.count >= 3 else {
            throw MIDI.File.DecodeError.malformed(
                "Not enough bytes."
            )
        }

        // 2-byte preambles
        guard let textTypeMatch = MIDI.File.kTextEventHeaders
            .first(where: { rawBytes.starts(with: $0.value) })
        else {
            throw MIDI.File.DecodeError.malformed(
                "Event is not a textual event."
            )
        }

        guard let length = MIDI.File.decodeVariableLengthValue(from: Array(rawBytes[2...])) else {
            throw MIDI.File.DecodeError.malformed(
                "Could not extract variable length."
            )
        }

        let expectedFullLength = 2 + length.byteLength + length.value

        guard rawBytes.count >= expectedFullLength else {
            throw MIDI.File.DecodeError.malformed(
                "Fewer bytes are available (\(rawBytes.count)) than are expected (\(expectedFullLength))."
            )
        }

        let byteSlice = Array(rawBytes[(2 + length.byteLength) ..< expectedFullLength]).data

        let formedText: ASCIIString

        if let getText = byteSlice
            .toString(using: .nonLossyASCII)?
            .asciiStringLossy
        {
            formedText = getText

        } else if let getText = byteSlice
            .toString(using: .ascii)?
            .asciiStringLossy
        {
            formedText = getText

        } else if let getText = byteSlice
            .toString(using: .utf8)?
            .asciiStringLossy
        {
            formedText = getText

        } else {
            throw MIDI.File.DecodeError.malformed(
                "Could not decode ASCII string. It may contain unsupported characters"
            )
        }

        let newInstance = Self(type: textTypeMatch.key,
                               string: formedText)

        return (newEvent: newInstance,
                bufferLength: expectedFullLength)
        
    }
    
    public var smfDescription: String {
        
        "\(textType): " + text.stringValue.quoted
        
    }
    
    public var smfDebugDescription: String {
        
        "Text(" + smfDescription + ")"
        
    }
    
}

// MARK: - TextEventType

extension MIDI.File.Event {
    
    public enum TextEventType: String, CaseIterable, Equatable, Hashable {
        
        // track events - first track
        
        //   head of track
        case copyright
        //   anywhere in track
        case marker
        case cuePoint

        // track events - any track
        
        //   head of track
        case trackOrSequenceName
        case instrumentName
        case text
        //   anywhere in track
        case programName
        case deviceName
        case lyric
        
    }
    
}
