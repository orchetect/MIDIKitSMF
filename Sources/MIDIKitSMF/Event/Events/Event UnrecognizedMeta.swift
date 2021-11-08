//
//  Event UnrecognizedMeta.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

// MARK: - UnrecognizedMeta

extension MIDI.File.Event {
    
    /// Unrecognized Meta Event
    ///
    /// - remark: Standard MIDI File Spec 1.0:
    ///
    /// "All meta-events begin with FF, then have an event type byte (which is always less than 128), and then have the length of the data stored as a variable-length quantity, and then the data itself. If there is no data, the length is 0. As with chunks, future meta-events may be designed which may not be known to existing programs, so programs must properly ignore meta-events which they do not recognize, and indeed, should expect to see them. Programs must never ignore the length of a meta-event which they do recognize, and they shouldn't be surprised if it's bigger than they expected. If so, they must ignore everything past what they know about. However, they must not add anything of their own to the end of a meta-event.
    ///
    /// SysEx events and meta-events cancel any running status which was in effect. Running status does not apply to and may not be used for these messages."
    public struct UnrecognizedMeta: Equatable, Hashable {
        
        public var metaType: UInt8 = 0x00 // 0x00 is a known meta type, but just default to it here any way
        
        /// Data bytes.
        /// Typically begins with a 1 or 3 byte manufacturer ID, similar to SysEx.
        public var data: [UInt8] = []
        
    }
    
}

extension MIDI.File.Event.UnrecognizedMeta: MIDIFileEvent {
    
    public static let smfEventType: MIDI.File.Event.EventType = .unrecognizedMeta
    
    public init(midi1SMFRawBytes rawBytes: [MIDI.Byte]) throws {
        
        guard rawBytes.count >= 3 else {
            throw MIDI.File.DecodeError.malformed(
                "Not enough bytes."
            )
        }
        
        // meta event byte
        guard rawBytes.starts(with: [0xFF]) else {
            throw MIDI.File.DecodeError.malformed(
                "Event does not start with expected bytes."
            )
        }
        
        let readMetaType = rawBytes[1]
        
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
        
        let beginIndex = rawBytes.startIndex.advanced(by: 2)
        let stopIndex = beginIndex.advanced(by: length.value)
        let readData = Array(rawBytes[beginIndex ... stopIndex])
        
        metaType = readMetaType
        data = readData
        
    }
    
    public var midi1SMFRawBytes: [MIDI.Byte] {
        
        // FF <type> <length> <bytes>
        // type == UInt8 meta type (unrecognized)
        
        var data: [UInt8] = []
        
        data.append(contentsOf: [0xFF, metaType])
        
        // length of data
        data.append(contentsOf: MIDI.File.encodeVariableLengthValue(self.data.count))
        
        // data
        data.append(contentsOf: self.data)
        
        return data
        
    }
    
    public static func initFrom(midi1SMFRawBytesStream rawBuffer: Data) -> InitFromMIDI1SMFRawBytesStreamResult? {
        
        guard rawBuffer.count >= 3 else {
            return nil
        }
        
        guard let newInstance = try? Self(midi1SMFRawBytes: rawBuffer.bytes) else {
            return nil
        }
        
        #warning("> TODO: this is brittle but it may work")
        
        let length = newInstance.midi1SMFRawBytes.count
        
        return (newEvent: newInstance,
                bufferLength: length)
        
    }
    
    public var smfDescription: String {
        
        "meta: \(metaType), \(data.count) bytes"
        
    }
    
    public var smfDebugDescription: String {
        
        let byteDump = data
            .hex.stringValues(padTo: 2, prefixes: true)
            .joined(separator: ", ")
            .wrapped(with: .brackets)
        
        return "UnrecognizedMeta(type: \(metaType), \(data.count) bytes: \(byteDump)"
        
    }
    
}
