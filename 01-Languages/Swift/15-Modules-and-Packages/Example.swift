// Example.swift - access control levels (a genuinely Swift-specific 5-level system, richer
// than Kotlin/Java's public/private/protected/internal), and an overview of Swift Package
// Manager (SPM) as the standard build/dependency tool.
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

// --- Access control: five distinct levels, from most to least restrictive ---
// private     -- visible only within the enclosing declaration (and extensions in the same file)
// fileprivate -- visible anywhere within the SAME source file
// internal    -- visible anywhere within the same module (the DEFAULT if unspecified)
// public      -- visible from other modules, but CANNOT be subclassed/overridden outside its module
// open        -- visible from other modules, AND CAN be subclassed/overridden outside its module

internal class InternalWidget { // `internal` is the default -- visible within this module only
    func describe() -> String { return "an internal widget" }
}

public class PublicWidget { // visible from OTHER modules that import this one
    public init() {}
    public func describe() -> String { return "a public widget" }
    // a class in another module CANNOT subclass PublicWidget, even though it can SEE it --
    // `public` alone does not permit cross-module subclassing.
}

open class OpenWidget { // visible AND subclassable/overridable from other modules
    public init() {}
    open func describe() -> String { return "an open widget" }
}

private struct PrivateHelper { // visible only within this specific scope
    static func helperFunction() -> String { return "private helper" }
}

print(InternalWidget().describe())
print(PublicWidget().describe())
print(OpenWidget().describe())
print(PrivateHelper.helperFunction())

// --- Swift Package Manager (SPM): the standard build/dependency tool ---
// A real multi-file Swift project uses a Package.swift manifest, e.g.:
//
// // swift-tools-version:5.9
// import PackageDescription
//
// let package = Package(
//     name: "MyProject",
//     dependencies: [
//         .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
//     ],
//     targets: [
//         .executableTarget(name: "MyProject", dependencies: ["ArgumentParser"]),
//     ]
// )
//
// `swift build` compiles the package (resolving dependencies automatically);
// `swift run` builds and runs the executable target; `swift test` runs the test target.
print("\nSee this file's comments for a Package.swift example (SPM manifest) -- not runnable standalone.")
