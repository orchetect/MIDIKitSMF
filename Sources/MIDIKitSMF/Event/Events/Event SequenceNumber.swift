//
//  Event SequenceNumber.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

// MARK: - MIDIChannelPrefix

public extension MIDI.File.Event {
    
    /// Sequence Number event.
    ///
    /// - For MIDI file type 0/1, this should only be on the first track. This is used to identify each track. If omitted, the sequences are numbered sequentially in the order the tracks appear.
    ///
    /// - For MIDI file type 2, each track can contain a sequence number event.
    struct SequenceNumber: Equatable, Hashable {
        
        /// Sequence number (0...32767)
        public var sequence: UInt16 = 0 {
            didSet {
                if oldValue != sequence { sequence_Validate() }
            }
        }
        
        private mutating func sequence_Validate() {
            sequence = sequence.clamped(to: 0x0 ... 0x7FFF)
        }
        
        // MARK: - Init
        
        public init(sequence: UInt16) {
            
            self.sequence = sequence
            
        }
        
    }
    
}

extension MIDI.File.Event.SequenceNumber: MIDIFileEvent {
    
    public static let smfEventType: MIDI.File.Event.EventType = .sequenceNumber
    
    public init(midi1SMFRawBytes rawBytes: [MIDI.Byte]) throws {
        
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDI.File.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        // 3-byte preamble
        guard rawBytes.starts(with: MIDI.File.kEventHeaders[.sequenceNumber]!) else {
            throw MIDI.File.DecodeError.malformed(
                "Event does not start with expected bytes."
            )
        }
        
        guard let readSequenceNumber = rawBytes[3 ... 4].data.toUInt16(from: .bigEndian) else {
            throw MIDI.File.DecodeError.malformed(
                "Could not read sequence number as integer."
            )
        }
        
        guard readSequenceNumber.isContained(in: 0x0 ... 0x7FFF) else {
            throw MIDI.File.DecodeError.malformed(
                "Sequence number is out of bounds: \(readSequenceNumber)"
            )
        }
        
        sequence = readSequenceNumber
        
    }
    
    public var midi1SMFRawBytes: [MIDI.Byte] {
        
        // FF 00 02 ssss
        // ssss is UIn16 big-endian sequence number
        
        MIDI.File.kEventHeaders[.sequenceNumber]! + sequence.toData(.bigEndian)
        
    }
    
    static let midi1SMFFixedRawBytesLength = 5
    
    public static func initFrom(midi1SMFRawBytesStream rawBuffer: Data) -> InitFromMIDI1SMFRawBytesStreamResult? {
        
        let requiredData = rawBuffer.prefix(midi1SMFFixedRawBytesLength).bytes
        
        guard requiredData.count == midi1SMFFixedRawBytesLength else {
            return nil
        }
        
        guard let newInstance = try? Self(midi1SMFRawBytes: requiredData) else {
            return nil
        }
        
        return (newEvent: newInstance,
                bufferLength: midi1SMFFixedRawBytesLength)
        
    }
    
    public var smfDescription: String {
        
        "seqNum:\(sequence)"
        
    }
    
    public var smfDebugDescription: String {
        
        "SequenceNumber(\(sequence))"
        
    }
    
}
