// solution-06.swift -- Exercise 06: Concurrent "Fetches" with async/await and an actor

import Foundation

func simulatedFetch(_ id: Int, delayMs: UInt64) async -> Int {
    try? await Task.sleep(nanoseconds: delayMs * 1_000_000)
    return id * 10
}

// `actor` serializes access to its mutable state automatically -- concurrent callers of
// `increment()` are queued and run one at a time, with no manual lock/mutex needed, unlike
// a plain `class` with a shared `var count` (which would be a genuine data race under
// concurrent access).
actor RequestCounter {
    private var count = 0
    func increment() -> Int {
        count += 1
        return count
    }
}

// Top-level code in a single-file, non-`main.swift`-named script is itself an implicit
// async entry point since Swift 5.5 -- `await` is usable directly here with no `@main`
// struct/`Task {}` wrapper needed (and, per a genuine compile error hit while writing this
// file, `@main` is actively REJECTED -- "cannot be used in a module that contains
// top-level code" -- once top-level statements like these exist in the same file).
let counter = RequestCounter()
let delays: [(id: Int, delayMs: UInt64)] = [
    (1, 300), (2, 100), (3, 200), (4, 400),
]

let clock = ContinuousClock()
let start = clock.now

let total = await withTaskGroup(of: Int.self) { group in
    for (id, delayMs) in delays {
        group.addTask {
            let result = await simulatedFetch(id, delayMs: delayMs)
            _ = await counter.increment()
            return result
        }
    }
    var sum = 0
    for await value in group {
        sum += value
    }
    return sum
}

let elapsed = clock.now - start
print("Results total: \(total)")
print("Elapsed: \(elapsed)")
// Why elapsed tracks the SLOWEST delay (400ms), not the SUM (1000ms): withTaskGroup
// runs every child task concurrently, not one after another -- each `Task.sleep`
// suspends only that one child, letting the others progress in the meantime. The
// group as a whole only finishes once its LAST child finishes, so wall-clock time
// is bounded by the slowest individual fetch, not the total of all four. If this
// were sequential `await`, the elapsed time would instead be close to the SUM.

let finalCount = await counter.increment()
print("Final counter after one more increment: \(finalCount)")
// 5, not a corrupted/lost value -- proving the actor safely serialized all 4
// concurrent increments from the task group plus this one extra call, with no
// manual locking anywhere in this file.
