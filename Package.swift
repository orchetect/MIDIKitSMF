// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MIDIKitSMF",

    platforms: [
        .macOS(.v10_12), .iOS(.v10), .tvOS(.v10), .watchOS(.v6)
    ],

    products: [
        .library(
            name: "MIDIKitSMF",
            targets: ["MIDIKitSMF"]
        ),
    ],

    dependencies: [
        // MIDIKit dependencies
        .package(url: "https://github.com/orchetect/MIDIKit", from: "0.5.0"),
        .package(url: "https://github.com/orchetect/SwiftRadix", from: "1.1.0"),
        
        // MIDIKitSMF dependencies
        .package(url: "https://github.com/orchetect/OTCore", from: "1.4.1"),
        .package(url: "https://github.com/orchetect/SwiftASCII", from: "1.0.2"),
        .package(url: "https://github.com/orchetect/TimecodeKit", from: "1.2.10"),
    ],

    targets: [
        .target(
            name: "MIDIKitSMF",
            dependencies: ["MIDIKit", "OTCore", "TimecodeKit", "SwiftASCII", "SwiftRadix"]
        ),
        .testTarget(
            name: "MIDIKitSMFTests",
            dependencies: ["MIDIKitSMF"]
        ),
    ]
)
