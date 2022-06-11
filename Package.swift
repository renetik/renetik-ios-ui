// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RenetikUI",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "RenetikUI",
            targets: ["RenetikUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/renetik/renetik-ios-core", "0.9.2" ..< "0.9.2" ),
	.package(url: "https://github.com/renetik/renetik-ios-event", branch: "master" ),
    ],
    targets: [
        .target(
            name: "RenetikUI",
            dependencies: [
                .product(name: "RenetikCore", package: "renetik-ios-core"),
		.product(name: "RenetikEvent", package: "renetik-ios-event"),
            ]
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
