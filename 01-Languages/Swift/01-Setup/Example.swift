// Example.swift - Swift compiles to native machine code via LLVM (unlike Kotlin/Java's
// JVM bytecode). Apple's primary platform is macOS/iOS via Xcode, but an official
// swift.org toolchain also targets Linux and Windows.
//
// NOTE (honesty flag -- see this lesson's README and the course README for full context):
// this example was NOT compiled or run in the environment that built this course. Swift's
// Windows toolchain ships only as a large, system-wide InstallShield installer (unlike the
// self-contained zip/archive toolchains used for every other language in this repository),
// and installing it system-wide was deliberately declined to avoid an unauthorized,
// hard-to-reverse machine-wide change. Treat this file as carefully written and reasoned
// about, but NOT verified by actual execution -- a genuine, disclosed exception to this
// repository's normal "every example was actually run" discipline.

import Foundation

print("Hello, Swift!")
print("Swift version info is available via `swift --version` on the command line.")
print("This file was compiled with `swiftc Example.swift -o example && ./example` when run manually.")
