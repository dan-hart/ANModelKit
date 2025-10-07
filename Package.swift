// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "ANModelKit",
	platforms: [
		.iOS(.v17),
		.macOS(.v14),
		.watchOS(.v10),
		.tvOS(.v17),
		.visionOS(.v1),
	],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "ANModelKit",
			targets: ["ANModelKit"]
		),
		.library(
			name: "ANModelKitHealthKit",
			targets: ["ANModelKitHealthKit"]
		),
	], dependencies: [
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "ANModelKit",
			dependencies: []
		),
		.target(
			name: "ANModelKitHealthKit",
			dependencies: ["ANModelKit"],
			swiftSettings: [
				.define("HEALTHKIT_AVAILABLE", .when(platforms: [.iOS, .watchOS, .visionOS]))
			]
		),
		.testTarget(
			name: "ANModelKitTests",
			dependencies: ["ANModelKit"]
		),
		.testTarget(
			name: "ANModelKitHealthKitTests",
			dependencies: ["ANModelKitHealthKit"]
		),
	]
)
