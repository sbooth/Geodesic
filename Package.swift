// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Geodesic",
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "Geodesic",
			targets: ["Geodesic"]),
	],
	dependencies: [
		.package(url: "https://github.com/sbooth/CXXGeographicLib", from: "2.4.0")
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "Geodesic",
			dependencies: [
				"CXXGeographicLib",
			],
			swiftSettings: [
				.interoperabilityMode(.Cxx),
			]),
		.testTarget(
			name: "GeodesicTests",
			dependencies: [
				"Geodesic",
			],
			swiftSettings: [
				.interoperabilityMode(.Cxx),
			]),
	],
	cxxLanguageStandard: .cxx17
)
