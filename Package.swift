// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MIDIKitSMF",

    platforms: [.macOS(.v10_12), .iOS(.v10), .tvOS(.v10), .watchOS(.v3)],

    products: [
        .library(
            name: "MIDIKitSMF",
            targets: ["MIDIKitSMF"]
        ),
    ],

    dependencies: [
        .package(url: "https://github.com/orchetect/MIDIKit", from: "0.2.1"),
        .package(url: "https://github.com/orchetect/OTCore", from: "1.1.14"),
        .package(url: "https://github.com/orchetect/SwiftASCII", from: "1.0.1"),
        .package(url: "https://github.com/orchetect/SwiftRadix", from: "1.0.3"),
        .package(url: "https://github.com/orchetect/TimecodeKit", from: "1.2.3"),
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
