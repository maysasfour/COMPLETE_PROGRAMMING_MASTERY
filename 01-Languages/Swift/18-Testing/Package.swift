// swift-tools-version:5.9
// Package.swift - SPM manifest for this lesson's test target.
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.
import PackageDescription

let package = Package(
    name: "Calculator",
    targets: [
        .target(name: "Calculator"),
        .testTarget(name: "CalculatorTests", dependencies: ["Calculator"]),
    ]
)
