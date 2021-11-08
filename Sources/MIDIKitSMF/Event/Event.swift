//
//  Event.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import TimecodeKit
import MIDIKit

extension MIDI.File {
    
    public enum Event: Equatable, Hashable {
        
        case cc(delta: DeltaTime, event: CC)
        case channelPrefix(delta: DeltaTime, event: ChannelPrefix)
        case keySignature(delta: DeltaTime, event: KeySignature)
        case noteOff(delta: DeltaTime, event: NoteOff)
        case noteOn(delta: DeltaTime, event: NoteOn)
        case notePressure(delta: DeltaTime, event: NotePressure)
        case pitchBend(delta: DeltaTime, event: PitchBend)
        case portPrefix(delta: DeltaTime, event: PortPrefix)
        case pressure(delta: DeltaTime, event: Pressure)
        case programChange(delta: DeltaTime, event: ProgramChange)
        case sequenceNumber(delta: DeltaTime, event: SequenceNumber)
        case sequencerSpecific(delta: DeltaTime, event: SequencerSpecific)
        case smpteOffset(delta: DeltaTime, event: SMPTEOffset)
        case sysEx(delta: DeltaTime, event: SysEx)
        case universalSysEx(delta: DeltaTime, event: UniversalSysEx)
        case tempo(delta: DeltaTime, event: Tempo)
        case text(delta: DeltaTime, event: Text)
        case timeSignature(delta: DeltaTime, event: TimeSignature)
        case unrecognizedMeta(delta: DeltaTime, event: UnrecognizedMeta)
        case xmfPatchTypePrefix(delta: DeltaTime, event: XMFPatchTypePrefix)
        
    }
    
}

public extension MIDI.File.Event {
    
    static func cc(_ delta: MIDI.File.DeltaTime = .none,
                   controller: MIDI.Event.CC.Controller,
                   value: MIDI.Event.CC.Value,
                   channel: MIDI.UInt4 = 0) -> Self
    {
        .cc(delta: delta,
            event: .init(controller: controller,
                         value: value,
                         channel: channel))
    }
    
    static func cc(_ delta: MIDI.File.DeltaTime = .none,
                   controller: MIDI.UInt7,
                   value: MIDI.Event.CC.Value,
                   channel: MIDI.UInt4 = 0) -> Self
    {
        .cc(delta: delta,
            event: .init(controller: controller,
                         value: value,
                         channel: channel))
    }
    
    static func channelPrefix(_ delta: MIDI.File.DeltaTime = .none,
                              channel: MIDI.UInt4) -> Self
    {
        .channelPrefix(delta: delta,
                       event: .init(channel: channel))
    }
    
    static func keySignature(_ delta: MIDI.File.DeltaTime = .none,
                             flatsOrSharps: Int8,
                             majorKey: Bool) -> Self
    {
        .keySignature(delta: delta,
                      event: .init(flatsOrSharps: flatsOrSharps,
                                   majorKey: majorKey))
    }
    
    static func noteOff(_ delta: MIDI.File.DeltaTime = .none,
                        note: MIDI.Note,
                        velocity: MIDI.Event.Note.Velocity,
                        channel: MIDI.UInt4 = 0) -> Self
    {
        .noteOff(delta: delta,
                 event: .init(note: note,
                              velocity: velocity,
                              channel: channel))
    }
    
    static func noteOff(_ delta: MIDI.File.DeltaTime = .none,
                        note: MIDI.UInt7,
                        velocity: MIDI.Event.Note.Velocity,
                        channel: MIDI.UInt4 = 0) -> Self
    {
        .noteOff(delta: delta,
                 event: .init(note: note,
                              velocity: velocity,
                              channel: channel))
    }
    
    static func noteOn(_ delta: MIDI.File.DeltaTime = .none,
                       note: MIDI.Note,
                       velocity: MIDI.Event.Note.Velocity,
                       channel: MIDI.UInt4 = 0) -> Self
    {
        .noteOn(delta: delta,
                event: .init(note: note,
                             velocity: velocity,
                             channel: channel))
    }
    
    static func noteOn(_ delta: MIDI.File.DeltaTime = .none,
                       note: MIDI.UInt7,
                       velocity: MIDI.Event.Note.Velocity,
                       channel: MIDI.UInt4 = 0) -> Self
    {
        .noteOn(delta: delta,
                event: .init(note: note,
                             velocity: velocity,
                             channel: channel))
    }
    
    static func notePressure(_ delta: MIDI.File.DeltaTime = .none,
                             note: MIDI.Note,
                             amount: MIDI.Event.Note.Pressure.Amount,
                             channel: MIDI.UInt4 = 0) -> Self
    {
        .notePressure(delta: delta,
                      event: .init(note: note,
                                   amount: amount,
                                   channel: channel))
    }
    
    static func notePressure(_ delta: MIDI.File.DeltaTime = .none,
                             note: MIDI.UInt7,
                             amount: MIDI.Event.Note.Pressure.Amount,
                             channel: MIDI.UInt4 = 0) -> Self
    {
        .notePressure(delta: delta,
                      event: .init(note: note,
                                   amount: amount,
                                   channel: channel))
    }
    
    static func pitchBend(_ delta: MIDI.File.DeltaTime = .none,
                          lsb: UInt8,
                          msb: UInt8,
                          channel: MIDI.UInt4 = 0) -> Self
    {
        let value = MIDI.Event.PitchBend.Value.midi1(.init(bytePair: .init(msb: msb, lsb: lsb)))
        return .pitchBend(delta: delta,
                          event: .init(value: value, channel: channel))
    }
    
    static func pitchBend(_ delta: MIDI.File.DeltaTime = .none,
                          value: MIDI.Event.PitchBend.Value,
                          channel: MIDI.UInt4 = 0) -> Self
    {
        .pitchBend(delta: delta,
                   event: .init(value: value, channel: channel))
    }
    
    static func portPrefix(_ delta: MIDI.File.DeltaTime = .none,
                           port: MIDI.UInt7) -> Self
    {
        .portPrefix(delta: delta,
                    event: .init(port: port))
    }
    
    static func pressure(_ delta: MIDI.File.DeltaTime = .none,
                         amount: MIDI.Event.Pressure.Amount,
                         channel: MIDI.UInt4 = 0) -> Self
    {
        .pressure(delta: delta,
                  event: .init(amount: amount,
                               channel: channel))
    }
    
    static func programChange(_ delta: MIDI.File.DeltaTime = .none,
                              program: MIDI.UInt7,
                              channel: MIDI.UInt4 = 0) -> Self
    {
        .programChange(delta: delta,
                       event: .init(program: program,
                                    bank: .noBankSelect,
                                    channel: channel))
    }
    
    static func sequenceNumber(_ delta: MIDI.File.DeltaTime = .none,
                               sequence: UInt16) -> Self
    {
        .sequenceNumber(delta: delta,
                        event: .init(sequence: sequence))
    }
    
    static func sequencerSpecific(_ delta: MIDI.File.DeltaTime = .none,
                                  data: [MIDI.Byte]) -> Self
    {
        .sequencerSpecific(delta: delta,
                           event: .init(data: data))
    }
    
    static func smpteOffset(_ delta: MIDI.File.DeltaTime = .none,
                            hr: UInt8,
                            min: UInt8,
                            sec: UInt8,
                            fr: UInt8,
                            subFr: UInt8,
                            frRate: MIDI.File.SMPTEOffsetFrameRate = ._30fps) -> Self
    {
        .smpteOffset(delta: delta,
                     event: .init(hr: hr,
                                  min: min,
                                  sec: sec,
                                  fr: fr,
                                  subFr: subFr,
                                  frRate: frRate))
    }
    
    static func smpteOffset(_ delta: MIDI.File.DeltaTime = .none,
                            scaling: Timecode) -> Self
    {
        .smpteOffset(delta: delta,
                     event: .init(scaling: scaling))
    }
    
    static func sysEx(_ delta: MIDI.File.DeltaTime = .none,
                      manufacturer: MIDI.Event.SysExManufacturer,
                      data: [MIDI.Byte]) -> Self
    {
        .sysEx(delta: delta,
               event: .init(manufacturer: manufacturer,
                            data: data))
    }
    
    static func tempo(_ delta: MIDI.File.DeltaTime = .none,
                      bpm: Double) -> Self
    {
        .tempo(delta: delta,
               event: .init(bpm: bpm))
    }
    
    static func text(_ delta: MIDI.File.DeltaTime = .none,
                     type: TextEventType,
                     string: ASCIIString) -> Self
    {
        .text(delta: delta,
              event: .init(type: type,
                           string: string))
    }
    
    static func timeSignature(_ delta: MIDI.File.DeltaTime = .none,
                              numerator: UInt8,
                              denominator: UInt8) -> Self
    {
        .timeSignature(delta: delta,
                       event: .init(numerator: numerator,
                                    denominator: denominator))
    }
    
    static func unrecognizedMeta(_ delta: MIDI.File.DeltaTime = .none,
                                 metaType: UInt8,
                                 data: [MIDI.Byte]) -> Self
    {
        .unrecognizedMeta(delta: delta,
                          event: .init(metaType: metaType,
                                       data: data))
    }
    
    static func universalSysEx(_ delta: MIDI.File.DeltaTime = .none,
                               universalType: MIDI.Event.UniversalSysExType,
                               deviceID: MIDI.UInt7,
                               subID1: MIDI.UInt7,
                               subID2: MIDI.UInt7,
                               data: [MIDI.Byte],
                               group: MIDI.UInt4 = 0x0) -> Self
    {
        .universalSysEx(delta: delta,
                        event: .init(universalType: universalType,
                                     deviceID: deviceID,
                                     subID1: subID1,
                                     subID2: subID2,
                                     data: data,
                                     group: group))
    }
    
    static func xmfPatchTypePrefix(_ delta: MIDI.File.DeltaTime = .none,
                                   patchSet: XMFPatchTypePrefix.PatchSet) -> Self
    {
        .xmfPatchTypePrefix(delta: delta,
                            event: .init(patchSet: patchSet))
    }
    
}

extension MIDI.File.Event {
    
    public var eventType: EventType {
        
        switch self {
        case .cc: return .cc
        case .channelPrefix: return .channelPrefix
        case .keySignature: return .keySignature
        case .noteOff: return .noteOff
        case .noteOn: return .noteOn
        case .notePressure: return .notePressure
        case .pitchBend: return .pitchBend
        case .portPrefix: return .portPrefix
        case .pressure: return .pressure
        case .programChange: return .programChange
        case .sequenceNumber: return .sequenceNumber
        case .sequencerSpecific: return .sequencerSpecific
        case .smpteOffset: return .smpteOffset
        case .sysEx: return .sysEx
        case .tempo: return .tempo
        case .text: return .text
        case .timeSignature: return .timeSignature
        case .universalSysEx: return .universalSysEx
        case .unrecognizedMeta: return .unrecognizedMeta
        case .xmfPatchTypePrefix: return .xmfPatchTypePrefix
        }
        
    }
    
}

extension MIDI.File.Event {
    
    public var concreteType: MIDIFileEvent.Type {
        
        switch self {
        case .cc: return CC.self
        case .channelPrefix: return ChannelPrefix.self
        case .keySignature: return KeySignature.self
        case .noteOff: return NoteOff.self
        case .noteOn: return NoteOn.self
        case .notePressure: return NotePressure.self
        case .pitchBend: return PitchBend.self
        case .portPrefix: return PortPrefix.self
        case .pressure: return Pressure.self
        case .programChange: return ProgramChange.self
        case .sequenceNumber: return SequenceNumber.self
        case .sequencerSpecific: return SequencerSpecific.self
        case .smpteOffset: return SMPTEOffset.self
        case .sysEx: return SysEx.self
        case .tempo: return Tempo.self
        case .text: return Text.self
        case .timeSignature: return TimeSignature.self
        case .universalSysEx: return UniversalSysEx.self
        case .unrecognizedMeta: return UnrecognizedMeta.self
        case .xmfPatchTypePrefix: return XMFPatchTypePrefix.self
        }
    }
    
}

extension MIDI.File.Event {
    
    /// Unwraps the enum case and returns the `MIDI.File.Event` contained within, typed as `MIDIFileEvent` protocol.
    public var unwrapped: (delta: MIDI.File.DeltaTime, event: MIDIFileEvent) {
        
        switch self {
        case .cc(let delta, let event): return (delta: delta, event: event)
        case .channelPrefix(let delta, let event): return (delta: delta, event: event)
        case .keySignature(let delta, let event): return (delta: delta, event: event)
        case .noteOff(let delta, let event): return (delta: delta, event: event)
        case .noteOn(let delta, let event): return (delta: delta, event: event)
        case .notePressure(let delta, let event): return (delta: delta, event: event)
        case .pitchBend(let delta, let event): return (delta: delta, event: event)
        case .portPrefix(let delta, let event): return (delta: delta, event: event)
        case .pressure(let delta, let event): return (delta: delta, event: event)
        case .programChange(let delta, let event): return (delta: delta, event: event)
        case .sequenceNumber(let delta, let event): return (delta: delta, event: event)
        case .sequencerSpecific(let delta, let event): return (delta: delta, event: event)
        case .smpteOffset(let delta, let event): return (delta: delta, event: event)
        case .sysEx(let delta, let event): return (delta: delta, event: event)
        case .tempo(let delta, let event): return (delta: delta, event: event)
        case .text(let delta, let event): return (delta: delta, event: event)
        case .timeSignature(let delta, let event): return (delta: delta, event: event)
        case .universalSysEx(let delta, let event): return (delta: delta, event: event)
        case .unrecognizedMeta(let delta, let event): return (delta: delta, event: event)
        case .xmfPatchTypePrefix(let delta, let event): return (delta: delta, event: event)
        }
        
    }
    
}

extension MIDIFileEvent {
    
    /// Wraps the concrete struct in its corresponding `MIDI.File.Event` enum case wrapper.
    public func wrapped(delta: MIDI.File.DeltaTime) -> MIDI.File.Event {
        
        switch self {
        case let event as MIDI.File.Event.CC: return .cc(delta: delta, event: event)
        case let event as MIDI.File.Event.ChannelPrefix: return .channelPrefix(delta: delta, event: event)
        case let event as MIDI.File.Event.KeySignature: return .keySignature(delta: delta, event: event)
        case let event as MIDI.File.Event.NoteOff: return .noteOff(delta: delta, event: event)
        case let event as MIDI.File.Event.NoteOn: return .noteOn(delta: delta, event: event)
        case let event as MIDI.File.Event.NotePressure: return .notePressure(delta: delta, event: event)
        case let event as MIDI.File.Event.PitchBend: return .pitchBend(delta: delta, event: event)
        case let event as MIDI.File.Event.PortPrefix: return .portPrefix(delta: delta, event: event)
        case let event as MIDI.File.Event.Pressure: return .pressure(delta: delta, event: event)
        case let event as MIDI.File.Event.ProgramChange: return .programChange(delta: delta, event: event)
        case let event as MIDI.File.Event.SequenceNumber: return .sequenceNumber(delta: delta, event: event)
        case let event as MIDI.File.Event.SequencerSpecific: return .sequencerSpecific(delta: delta, event: event)
        case let event as MIDI.File.Event.SMPTEOffset: return .smpteOffset(delta: delta, event: event)
        case let event as MIDI.File.Event.SysEx: return .sysEx(delta: delta, event: event)
        case let event as MIDI.File.Event.Tempo: return .tempo(delta: delta, event: event)
        case let event as MIDI.File.Event.Text: return .text(delta: delta, event: event)
        case let event as MIDI.File.Event.TimeSignature: return .timeSignature(delta: delta, event: event)
        case let event as MIDI.File.Event.UniversalSysEx: return .universalSysEx(delta: delta, event: event)
        case let event as MIDI.File.Event.UnrecognizedMeta: return .unrecognizedMeta(delta: delta, event: event)
        case let event as MIDI.File.Event.XMFPatchTypePrefix: return .xmfPatchTypePrefix(delta: delta, event: event)
            
        default:
            fatalError()
        }
        
    }
    
}
