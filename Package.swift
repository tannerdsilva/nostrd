// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "nostrd",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url:"https://github.com/tannerdsilva/bedrock.git", .upToNextMinor(from:"0.0.2")),
        .package(url:"https://github.com/hummingbird-project/hummingbird.git", .upToNextMinor(from:"0.16.3")),
        .package(url:"https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from:"1.2.1")),
        .package(url:"https://github.com/tannerdsilva/QuickLMDB.git", .upToNextMinor(from:"1.4.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "nostrd",
            dependencies: [
            
            	.product(name:"ArgumentParser", package:"swift-argument-parser"),
            	.product(name:"Hummingbird", package:"hummingbird"),
            	.product(name:"QuickLMDB", package:"QuickLMDB"),
            	.product(name:"bedrock", package:"bedrock")
            ]
        ),
        .testTarget(
            name: "nostrdTests",
            dependencies: ["nostrd"]),
    ]
)
