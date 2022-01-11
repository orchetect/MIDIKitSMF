//
//  Event Conversion.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import MIDIKit

extension MIDI.Event {
    
    /// Convert the MIDIKit I/O event case (`MIDI.Event`) to a MIDIKitSMF event case (`MIDI.File.Event`).
    public func smfEvent(delta: MIDI.File.DeltaTime) -> MIDI.File.Event? {
        
        switch self {
        case .noteOn(let event):
            return .noteOn(delta: delta, event: event)
            
        case .noteOff(let event):
            return .noteOff(delta: delta, event: event)
            
        case .noteCC:
            // MIDI 2.0 only
            return nil
            
        case .notePitchBend:
            // MIDI 2.0 only
            return nil
            
        case .notePressure(let event):
            return .notePressure(delta: delta, event: event)
            
        case .noteManagement:
            // MIDI 2.0 only
            return nil
            
        case .cc(let event):
            return .cc(delta: delta, event: event)
            
        case .programChange(let event):
            return .programChange(delta: delta, event: event)
            
        case .pitchBend(let event):
            return .pitchBend(delta: delta, event: event)
            
        case .pressure(let event):
            return .pressure(delta: delta, event: event)
            
        case .sysEx7(let event):
            return .sysEx(delta: delta, event: event)
            
        case .universalSysEx7(let event):
            return .universalSysEx(delta: delta, event: event)
            
        case .sysEx8:
            // MIDI 2.0 only
            return nil
            
        case .universalSysEx8:
            // MIDI 2.0 only
            return nil
            
        case .timecodeQuarterFrame,
             .songPositionPointer,
             .songSelect,
             .unofficialBusSelect,
             .tuneRequest,
             .timingClock,
             .start,
             .continue,
             .stop,
             .activeSensing,
             .systemReset:
            // Not applicable to MIDI files.
            return nil
            
        }
        
    }
    
}

extension MIDI.File.Event {
    
    /// Convert the MIDIKitSMF event case (`MIDI.File.Event`) to a MIDIKit I/O event case (`MIDI.Event`).
    public func event() -> MIDI.Event? {
        
        switch self {
        case .cc(_, let event):
            return .cc(event)
            
        case .noteOff(_, let event):
            return .noteOff(event)
            
        case .noteOn(_, let event):
            return .noteOn(event)
            
        case .notePressure(_, let event):
            return .notePressure(event)
            
        case .pitchBend(_, let event):
            return .pitchBend(event)
            
        case .pressure(_, let event):
            return .pressure(event)
            
        case .programChange(_, let event):
            return .programChange(event)
            
        case .sysEx(_, let event):
            return .sysEx7(event)
            
        case .universalSysEx(_, let event):
            return .universalSysEx7(event)
            
        case .channelPrefix,
             .keySignature,
             .portPrefix,
             .sequenceNumber,
             .sequencerSpecific,
             .smpteOffset,
             .tempo,
             .text,
             .timeSignature,
             .unrecognizedMeta,
             .xmfPatchTypePrefix:
            // Not applicable to MIDI I/O, only applicable to MIDI files.
            return nil
            
        }
        
    }
    
}
