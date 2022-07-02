//
//  Event Conversion Tests.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitSMF
import OTCore

final class Event_Conversion_EventToSMFEvent_Tests: XCTestCase {
    
    func testMIDI_Event_NoteOn_smfEvent() throws {
        
        let event = MIDI.Event.noteOn(60,
                                      velocity: .midi1(64),
                                      attribute: .profileSpecific(data: 0x1234),
                                      channel: 1,
                                      group: 2,
                                      midi1ZeroVelocityAsNoteOff: true)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDI.Event payload
        guard case .noteOn(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // extract MIDI.File.Event payload
        guard case .noteOn(delta: _,
                           event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
        
    }
    
    func testMIDI_Event_NoteOff_smfEvent() throws {
        
        let event = MIDI.Event.noteOff(60,
                                       velocity: .midi1(0),
                                       attribute: .profileSpecific(data: 0x1234),
                                       channel: 1,
                                       group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDI.Event payload
        guard case .noteOff(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // extract MIDI.File.Event payload
        guard case .noteOff(delta: _,
                            event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
        
    }
    
    func testMIDI_Event_NoteCC_smfEvent() throws {
        
        let event = MIDI.Event.noteCC(note: 60,
                                      controller: .registered(.modWheel),
                                      value: .midi2(32768),
                                      channel: 1,
                                      group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // no equivalent SMF event exists
        // (however with the upcoming Standard MIDI File 2.0 spec, this may be implemented in future)
        XCTAssertNil(smfEvent)
        
    }
    
    func testMIDI_Event_NotePitchBend_smfEvent() throws {
        
        let event = MIDI.Event.notePitchBend(note: 60,
                                             value: .midi2(.zero),
                                             channel: 1,
                                             group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // no equivalent SMF event exists
        // (however with the upcoming Standard MIDI File 2.0 spec, this may be implemented in future)
        XCTAssertNil(smfEvent)
        
    }
    
    func testMIDI_Event_NotePressure_smfEvent() throws {
        
        let event = MIDI.Event.notePressure(note: 60,
                                            amount: .midi2(.zero),
                                            channel: 1, group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDI.Event payload
        guard case .notePressure(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // extract MIDI.File.Event payload
        guard case .notePressure(delta: _,
                                 event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
        
    }
    
    func testMIDI_Event_NoteManagement_smfEvent() throws {
        
        let event = MIDI.Event.noteManagement(60,
                                              flags: [.detachPerNoteControllers],
                                              channel: 1, group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // no equivalent SMF event exists
        // (however with the upcoming Standard MIDI File 2.0 spec, this may be implemented in future)
        XCTAssertNil(smfEvent)
        
    }
    
    func testMIDI_Event_CC_smfEvent() throws {
        
        let event = MIDI.Event.cc(.modWheel,
                                  value: .midi1(64),
                                  channel: 1,
                                  group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDI.Event payload
        guard case .cc(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // extract MIDI.File.Event payload
        guard case .cc(delta: _,
                       event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
        
    }
    
    func testMIDI_Event_ProgramChange_smfEvent() throws {
        
        let event = MIDI.Event.programChange(program: 20,
                                             bank: .bankSelect(4),
                                             channel: 1,
                                             group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDI.Event payload
        guard case .programChange(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // extract MIDI.File.Event payload
        guard case .programChange(delta: _,
                                  event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
        
    }
    
    func testMIDI_Event_PitchBend_smfEvent() throws {
        
        let event = MIDI.Event.pitchBend(value: .midi1(.midpoint),
                                         channel: 1,
                                         group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDI.Event payload
        guard case .pitchBend(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // extract MIDI.File.Event payload
        guard case .pitchBend(delta: _,
                              event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
        
    }
    
    func testMIDI_Event_Pressure_smfEvent() throws {
        
        let event = MIDI.Event.pressure(amount: .midi1(5),
                                        channel: 1,
                                        group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDI.Event payload
        guard case .pressure(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // extract MIDI.File.Event payload
        guard case .pressure(delta: _,
                             event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
        
    }
    
    func testMIDI_Event_SysEx_smfEvent() throws {
        
        let event = MIDI.Event.sysEx7(manufacturer: .educational(),
                                      data: [0x12, 0x34],
                                      group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDI.Event payload
        guard case .sysEx7(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // extract MIDI.File.Event payload
        guard case .sysEx(delta: _,
                          event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
        
    }
    
    func testMIDI_Event_UniversalSysEx_smfEvent() throws {
        
        let event = MIDI.Event.universalSysEx7(universalType: .nonRealTime,
                                               deviceID: 0x7F,
                                               subID1: 0x01,
                                               subID2: 0x02,
                                               data: [0x12, 0x34],
                                               group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDI.Event payload
        guard case .universalSysEx7(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // extract MIDI.File.Event payload
        guard case .universalSysEx(delta: _,
                                   event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
        
    }
    
    func testMIDI_Event_TimecodeQuarterFrame_smfEvent() {
        
        let event = MIDI.Event.timecodeQuarterFrame(dataByte: 0x00,
                                                    group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
        
    }
    
    func testMIDI_Event_SongPositionPointer_smfEvent() {
        
        let event = MIDI.Event.songPositionPointer(midiBeat: 8,
                                                   group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
        
    }
    
    func testMIDI_Event_SongSelect_smfEvent() {
        
        let event = MIDI.Event.songSelect(number: 4,
                                          group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
        
    }
    
    func testMIDI_Event_UnofficialBusSelect_smfEvent() {
        
        let event = MIDI.Event.unofficialBusSelect(bus: 4,
                                                   group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
        
    }
    
    func testMIDI_Event_TuneRequest_smfEvent() {
        
        let event = MIDI.Event.tuneRequest(group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
        
    }
    
    func testMIDI_Event_TimingClock_smfEvent() {
        
        let event = MIDI.Event.timingClock(group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
        
    }
    
    func testMIDI_Event_Start_smfEvent() {
        
        let event = MIDI.Event.start(group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
        
    }
    
    func testMIDI_Event_Continue_smfEvent() {
        
        let event = MIDI.Event.continue(group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
        
    }
    
    func testMIDI_Event_Stop_smfEvent() {
        
        let event = MIDI.Event.stop(group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
        
    }
    
    func testMIDI_Event_ActiveSensing_smfEvent() {
        
        let event = MIDI.Event.activeSensing(group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
        
    }
    
    func testMIDI_Event_SystemReset_smfEvent() {
        
        let event = MIDI.Event.systemReset(group: 2)
        
        // convert MIDI.Event case to MIDI.File.Event case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        // (A system reset message byte (0xFF) is reserved in the MIDI file format as the start byte for various MIDI file-specific event types.)
        XCTAssertNil(smfEvent)
        
    }
    
}

final class Event_Conversion_SMFEventToEvent_Tests: XCTestCase {
    
    func testMIDI_File_Event_CC_event() throws {
        
        let smfEvent = MIDI.File.Event.cc(delta: .none,
                                          controller: .modWheel,
                                          value: .midi1(64),
                                          channel: 1)
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDI.File.Event payload
        guard case .cc(delta: _,
                       event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // extract MIDI.Event payload
        guard case .cc(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
        
    }
    
    func testMIDI_File_Event_NoteOff_event() throws {
        
        let smfEvent = MIDI.File.Event.noteOff(delta: .none,
                                               note: 60,
                                               velocity: .midi1(0),
                                               channel: 1)
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDI.File.Event payload
        guard case .noteOff(delta: _,
                            event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // extract MIDI.Event payload
        guard case .noteOff(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
        
    }
    
    func testMIDI_File_Event_NoteOn_event() throws {
        
        let smfEvent = MIDI.File.Event.noteOn(delta: .none,
                                              note: 60,
                                              velocity: .midi1(64),
                                              channel: 1)
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDI.File.Event payload
        guard case .noteOn(delta: _,
                           event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // extract MIDI.Event payload
        guard case .noteOn(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
        
    }
    
    func testMIDI_File_Event_NotePressure_event() throws {
        
        let smfEvent = MIDI.File.Event.notePressure(delta: .none,
                                                    note: 60,
                                                    amount: .midi1(64),
                                                    channel: 1)
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDI.File.Event payload
        guard case .notePressure(delta: _,
                                 event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // extract MIDI.Event payload
        guard case .notePressure(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
        
    }
    
    func testMIDI_File_Event_PitchBend_event() throws {
        
        let smfEvent = MIDI.File.Event.pitchBend(delta: .none,
                                                 value: .midi1(.midpoint),
                                                 channel: 1)
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDI.File.Event payload
        guard case .pitchBend(delta: _,
                              event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // extract MIDI.Event payload
        guard case .pitchBend(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
        
    }
    
    func testMIDI_File_Event_Pressure_event() throws {
        
        let smfEvent = MIDI.File.Event.pressure(delta: .none,
                                                amount: .midi1(.midpoint),
                                                channel: 1)
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDI.File.Event payload
        guard case .pressure(delta: _,
                             event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // extract MIDI.Event payload
        guard case .pressure(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
        
    }
    
    func testMIDI_File_Event_ProgramChange_event() throws {
        
        let smfEvent = MIDI.File.Event.programChange(delta: .none,
                                                     program: 20,
                                                     channel: 1)
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDI.File.Event payload
        guard case .programChange(delta: _,
                                  event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // extract MIDI.Event payload
        guard case .programChange(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
        
    }
    
    func testMIDI_File_Event_SysEx_event() throws {
        
        let smfEvent = MIDI.File.Event.sysEx(delta: .none,
                                             manufacturer: .educational(),
                                             data: [0x12, 0x34])
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDI.File.Event payload
        guard case .sysEx(delta: _,
                          event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // extract MIDI.Event payload
        guard case .sysEx7(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
        
    }
    
    func testMIDI_File_Event_UniversalSysEx_event() throws {
        
        let smfEvent = MIDI.File.Event.universalSysEx(delta: .none,
                                                      universalType: .nonRealTime,
                                                      deviceID: 0x7F,
                                                      subID1: 0x01,
                                                      subID2: 0x02,
                                                      data: [0x12, 0x34])
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDI.File.Event payload
        guard case .universalSysEx(delta: _,
                                   event: let unwrappedSMFEvent) = smfEvent else {
            XCTFail() ; return
        }
        
        // extract MIDI.Event payload
        guard case .universalSysEx7(let unwrappedEvent) = event else {
            XCTFail() ; return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
        
    }
    
    func testMIDI_File_Event_ChannelPrefix_event() throws {
        
        let smfEvent = MIDI.File.Event.channelPrefix(delta: .none,
                                                     channel: 4)
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDI.Event I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
        
    }
    
    func testMIDI_File_Event_KeySignature_event() throws {
        
        let smfEvent = MIDI.File.Event.keySignature(delta: .none,
                                                    flatsOrSharps: -2,
                                                    majorKey: true)
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDI.Event I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
        
    }
    
    func testMIDI_File_Event_PortPrefix_event() throws {
        
        let smfEvent = MIDI.File.Event.portPrefix(delta: .none,
                                                  port: 4)
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDI.Event I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
        
    }
    
    func testMIDI_File_Event_SequenceNumber_event() throws {
        
        let smfEvent = MIDI.File.Event.sequenceNumber(delta: .none,
                                                      sequence: 4)
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDI.Event I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
        
    }
    
    func testMIDI_File_Event_SequencerSpecific_event() throws {
        
        let smfEvent = MIDI.File.Event.sequencerSpecific(delta: .none,
                                                         data: [0x12, 0x34])
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDI.Event I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
        
    }
    
    func testMIDI_File_Event_SMPTEOffset_event() throws {
        
        let smfEvent = MIDI.File.Event.smpteOffset(delta: .none,
                                                   hr: 1,
                                                   min: 2,
                                                   sec: 3,
                                                   fr: 4,
                                                   subFr: 0,
                                                   frRate: ._2997dfps)
                                                  
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDI.Event I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
        
    }
    
    func testMIDI_File_Event_Tempo_event() throws {
        
        let smfEvent = MIDI.File.Event.tempo(delta: .none,
                                             bpm: 140.0)
        
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDI.Event I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
        
    }
    
    func testMIDI_File_Event_Text_event() throws {
        
        let smfEvent = MIDI.File.Event.text(delta: .none,
                                            type: .trackOrSequenceName,
                                            string: "Piano")
        
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDI.Event I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
        
    }
    
    func testMIDI_File_Event_TimeSignature_event() throws {
        
        let smfEvent = MIDI.File.Event.timeSignature(delta: .none,
                                                     numerator: 2,
                                                     denominator: 2)
        
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDI.Event I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
        
    }
    
    func testMIDI_File_Event_UnrecognizedMeta_event() throws {
        
        let smfEvent = MIDI.File.Event.unrecognizedMeta(delta: .none,
                                                        metaType: 0x30,
                                                        data: [0x12, 0x34])
        
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDI.Event I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
        
    }
    
    func testMIDI_File_Event_XMFPatchTypePrefix_event() throws {
        
        let smfEvent = MIDI.File.Event.xmfPatchTypePrefix(delta: .none,
                                                          patchSet: .DLS)
        
        
        // convert MIDI.File.Event case to MIDI.Event case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDI.Event I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
        
    }
    
}

#endif
