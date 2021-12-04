//
//  Log.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

@_implementationOnly import OTCore

let logger = OSLogger {
    #if RELEASE
    $0.defaultTemplate = .minimal()
    #else
    $0.defaultTemplate = .withEmoji()
    #endif
}
