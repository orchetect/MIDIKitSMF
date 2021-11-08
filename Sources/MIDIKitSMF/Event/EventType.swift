//
//  EventType.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import MIDIKit

extension MIDI.File.Event {
    
    /// Cases describing MIDI file event types
    public enum EventType: String, CaseIterable, Equatable, Hashable {
        
        case cc
        case channelPrefix
        case keySignature
        case noteOff
        case noteOn
        case notePressure // polyphonic (per-note) pressure
        case pitchBend
        case portPrefix
        case pressure // channel pressure
        case programChange
        case sequenceNumber
        case sequencerSpecific
        case smpteOffset
        case sysEx
        case tempo
        case text
        case timeSignature
        case universalSysEx
        case unrecognizedMeta
        case xmfPatchTypePrefix
        
    }
    
}

extension MIDI.File.Event.EventType {
    
    public var concreteType: MIDIFileEvent.Type {
        
        switch self {
        case .cc: return MIDI.File.Event.CC.self
        case .channelPrefix: return MIDI.File.Event.ChannelPrefix.self
        case .keySignature: return MIDI.File.Event.KeySignature.self
        case .noteOff: return MIDI.File.Event.NoteOff.self
        case .noteOn: return MIDI.File.Event.NoteOn.self
        case .notePressure: return MIDI.File.Event.NotePressure.self
        case .pitchBend: return MIDI.File.Event.PitchBend.self
        case .portPrefix: return MIDI.File.Event.PortPrefix.self
        case .pressure: return MIDI.File.Event.Pressure.self
        case .programChange: return MIDI.File.Event.ProgramChange.self
        case .sequenceNumber: return MIDI.File.Event.SequenceNumber.self
        case .sequencerSpecific: return MIDI.File.Event.SequencerSpecific.self
        case .smpteOffset: return MIDI.File.Event.SMPTEOffset.self
        case .sysEx: return MIDI.File.Event.SysEx.self
        case .tempo: return MIDI.File.Event.Tempo.self
        case .text: return MIDI.File.Event.Text.self
        case .timeSignature: return MIDI.File.Event.TimeSignature.self
        case .universalSysEx: return MIDI.File.Event.UniversalSysEx.self
        case .unrecognizedMeta: return MIDI.File.Event.UnrecognizedMeta.self
        case .xmfPatchTypePrefix: return MIDI.File.Event.XMFPatchTypePrefix.self
        }
    }
    
}

extension Collection where Element == MIDI.File.Event.EventType {
    
    public var concreteTypes: [MIDIFileEvent.Type] {
        
        map(\.concreteType.self)
        
    }
    
}
