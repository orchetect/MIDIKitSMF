//
//  MIDIFileEvent.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import Foundation
import MIDIKit

/// Protocol describing a MIDI event for use in `MIDI.File`
public protocol MIDIFileEvent {
    
    /// MIDI File event type.
    static var smfEventType: MIDI.File.Event.EventType { get }
    
    /// Initialize from raw event bytes.
    /// Returns nil if data is malformed or cannot otherwise be used to construct the event.
    init(midi1SMFRawBytes: [MIDI.Byte]) throws
    
    /// Raw data for the event.
    var midi1SMFRawBytes: [MIDI.Byte] { get }
    
    /// Returns the new event and MIDI file buffer length (number of bytes).
    typealias InitFromMIDI1SMFRawBytesStreamResult = (newEvent: Self, bufferLength: Int)
    
    /// If it is possible to initialize a new instance of this event from the head of the data buffer, a new instance will be returned along with the byte length traversed from the buffer.
    static func initFrom(midi1SMFRawBytesStream rawBuffer: Data) -> InitFromMIDI1SMFRawBytesStreamResult?
    
    /// Description for the event in a MIDI file context.
    var smfDescription: String { get }
    
    /// Debug description for the event in a MIDI file context.
    var smfDebugDescription: String { get }
    
}
