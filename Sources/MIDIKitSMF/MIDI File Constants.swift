//
//  MIDI File Constants.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import MIDIKit

// MARK: - Global Constants

extension MIDI.File {
    
    static let kChunkMIDITrackEnd: [MIDI.Byte] = [0xFF, 0x2F, 0x00]

    static let kEventHeaders: [MIDI.File.Event.EventType: [MIDI.Byte]] =
        [
            .sequenceNumber:     [0xFF, 0x00, 0x02],
            .channelPrefix:      [0xFF, 0x20, 0x01],
            .portPrefix:         [0xFF, 0x21, 0x01],
            .tempo:              [0xFF, 0x51, 0x03],
            .smpteOffset:        [0xFF, 0x54, 0x05],
            .timeSignature:      [0xFF, 0x58, 0x04],
            .keySignature:       [0xFF, 0x59, 0x02],
            .xmfPatchTypePrefix: [0xFF, 0x60],
            .sequencerSpecific:  [0xFF, 0x7F],
        ]

    static let kTextEventHeaders: [MIDI.File.Event.Text.EventType: [MIDI.Byte]] =
        [
            .text:                [0xFF, 0x01],
            .copyright:           [0xFF, 0x02],
            .trackOrSequenceName: [0xFF, 0x03],
            .instrumentName:      [0xFF, 0x04],
            .lyric:               [0xFF, 0x05],
            .marker:              [0xFF, 0x06],
            .cuePoint:            [0xFF, 0x07],
            .programName:         [0xFF, 0x08],
            .deviceName:          [0xFF, 0x09],
        ]
    
}
