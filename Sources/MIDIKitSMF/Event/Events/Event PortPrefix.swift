//
//  Event PortPrefix.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

// MARK: - MIDIPortPrefix

extension MIDI.File.Event {
    
    /// MIDI Port Prefix event.
    ///
    /// Specifies out of which MIDI Port (ie, buss) the MIDI events in the MIDI track go.
    /// The data byte pp, is the port number, where 0 would be the first MIDI buss in the system.
    public struct PortPrefix: Equatable, Hashable {
        
        /// Port number (0...127)
        public var port: MIDI.UInt7 = 0
        
        // MARK: - Init
        
        public init(port: MIDI.UInt7) {
            
            self.port = port
            
        }
        
    }
    
}

extension MIDI.File.Event.PortPrefix: MIDIFileEvent {
    
    public static let smfEventType: MIDI.File.Event.EventType = .portPrefix
    
    public init(midi1SMFRawBytes rawBytes: [MIDI.Byte]) throws {
        
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDI.File.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        // 3-byte preamble
        guard rawBytes.starts(with: MIDI.File.kEventHeaders[.portPrefix]!) else {
            throw MIDI.File.DecodeError.malformed(
                "Event does not start with expected bytes."
            )
        }
        
        let readPortNumber = rawBytes[3]
        
        guard readPortNumber.isContained(in: 0x0 ... 0x7F) else {
            throw MIDI.File.DecodeError.malformed(
                "Port number is out of bounds: \(readPortNumber)"
            )
        }
        
        guard let portNumber = readPortNumber.toMIDIUInt7Exactly else {
            throw MIDI.File.DecodeError.malformed(
                "Value(s) out of bounds."
            )
        }
        
        port = portNumber
        
    }
    
    public var midi1SMFRawBytes: [MIDI.Byte] {
        
        // FF 21 01 pp
        // pp is port number (0...127 assumably)
        
        MIDI.File.kEventHeaders[.portPrefix]! + [port.uInt8Value]
        
    }
    
    static let midi1SMFFixedRawBytesLength = 4
    
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
        
        "port:\(port)"
        
    }
    
    public var smfDebugDescription: String {
        
        "PortPrefix(\(port))"
        
    }
    
}
