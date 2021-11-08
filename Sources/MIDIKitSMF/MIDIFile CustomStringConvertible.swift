//
//  MIDIFile CustomStringConvertible.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//

import MIDIKit
@_implementationOnly import OTCore

extension MIDI.File: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        
        var outputString = ""

        outputString += "MIDIFile(".newLined
        outputString += "  format: \(format)".newLined
        outputString += "  timing: \(timing)".newLined
        outputString += "  chunks (\(chunks.count)): ".newLined

        chunks.enumerated().forEach {
            // indent each line with additional spaces
            outputString += "Chunk #\($0.offset + 1): \($0.element)"
                .split(separator: Character.newLine)
                .reduce("") { $0 + "    \($1)".newLined }
        }

        outputString += ")"

        return outputString
        
    }

    public var debugDescription: String {
        
        var outputString = ""

        outputString += "MIDIFile(".newLined
        outputString += "  format: \(format.debugDescription)".newLined
        outputString += "  timing: \(timing.debugDescription)".newLined
        outputString += "  chunks (\(chunks.count)): ".newLined

        chunks.enumerated().forEach {
            // indent each line with additional spaces
            outputString += "#\($0.offset + 1): \($0.element.debugDescription)"
                .split(separator: Character.newLine)
                .reduce("") { $0 + "    \($1)".newLined }
        }

        outputString += ")"

        return outputString
        
    }
    
}
