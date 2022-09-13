// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "search",
    products: [
		.executable(name: "search", targets: ["Search"])
    ],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
	],
	targets: [
		.executableTarget(name: "Search", dependencies: [
			.product(name: "ArgumentParser", package: "swift-argument-parser"),
		]),
		.testTarget(name: "SearchTests", dependencies: ["Search"])
	]
)
