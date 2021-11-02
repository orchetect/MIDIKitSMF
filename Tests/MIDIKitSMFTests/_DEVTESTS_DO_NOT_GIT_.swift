//
//  _DEVTESTS_DO_NOT_GIT_.swift
//  MIDIKitSMF
//
//  Created by Steffan Andrews on 2021-02-01.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

    @testable import MIDIKitSMF
    import OTCore
    import XCTest

    final class MIDIKitSMF_DevTests: XCTestCase {
        //	func testMIDIFileDP8Markers() {
//
        //		#warning("> this is a dev test only until it's completed")
//
        //		do {
//
        //			let midiFile = try MIDIFile(rawData: Data(kMIDIFile.DP8Markers))
//
        //			print("Decoded MIDI file data successfully.")
//
        //			print(midiFile)
        //			//print(midiFile.debugDescription)
        //			//dump(midiFile)
//
        //		} catch let error as MIDIFile.DecodeError {
        //			print("⚠️", error)
        //			XCTFail(error.localizedDescription)
        //		} catch {
        //			print("⚠️", error)
        //			XCTFail(error.localizedDescription)
        //		}
//
//
        //	}

        //	func testExternalMIDIFile() {
//
        //		let url = FileManager.homeDirectoryForCurrentUserCompat
        //			.appendingPathComponent("Desktop", isDirectory: true)
        //			.appendingPathComponent("dkc_bonus.mid")
//
        //		guard let data = try? Data(contentsOf: url) else {
        //			print("⚠️ error reading file contents off disk")
        //			XCTFail("⚠️ error reading file contents off disk")
        //			return
        //		}
//
        //		do {
//
        //			let midiFile = try MIDIFile(rawData: data)
//
        //			print("Decoded MIDI file data successfully.")
//
        //			print(midiFile)
        //			//print(midiFile.debugDescription)
        //			//dump(midiFile)
//
        //		} catch let error as MIDIFile.DecodeError {
        //			print("⚠️", error)
        //			XCTFail(error.localizedDescription)
        //		} catch {
        //			print("⚠️", error)
        //			XCTFail(error.localizedDescription)
        //		}
//
        //	}
    }

#endif
