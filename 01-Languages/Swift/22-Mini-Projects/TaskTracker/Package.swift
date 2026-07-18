// swift-tools-version:5.9
import PackageDescription

// `CSQLite3` compiles the SQLite "amalgamation" (sqlite3.c + sqlite3.h, fetched on demand
// by fetch-sqlite3.sh -- see this package's README) as a plain SwiftPM C target. On Linux/
// macOS, Lesson 16 could `import SQLite3` directly because Swift's toolchain there bundles
// a system SQLite3 module map pointing at the OS's own libsqlite3 -- Swift's Windows
// toolchain (used to build this mini-project) does NOT bundle that module, so vendoring
// the amalgamation source and compiling it ourselves is this platform's equivalent of
// "the system/bundled sqlite3" the brief asks for, adapted for a real, documented reason.
let package = Package(
    name: "TaskTracker",
    targets: [
        .target(
            name: "CSQLite3",
            path: "Sources/CSQLite3",
            cSettings: [.define("SQLITE_THREADSAFE", to: "1")]
        ),
        .target(
            name: "TaskTrackerCore",
            dependencies: ["CSQLite3"],
            path: "Sources/TaskTrackerCore"
        ),
        .executableTarget(
            name: "TaskTracker",
            dependencies: ["TaskTrackerCore"],
            path: "Sources/TaskTracker"
        ),
        .testTarget(
            name: "TaskTrackerCoreTests",
            dependencies: ["TaskTrackerCore"],
            path: "Tests/TaskTrackerCoreTests"
        ),
    ]
)
