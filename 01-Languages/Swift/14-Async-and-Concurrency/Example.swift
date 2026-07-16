// Example.swift - async/await NATIVE to the language since Swift 5.5 -- a genuine, positive
// contrast with Kotlin (needs the separate kotlinx.coroutines library) and Rust (needs the
// separate tokio crate), both covered earlier in this repository. Also: actors, Swift's
// language-level mechanism for eliminating data races at compile time (Sendable checking).
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

import Foundation

// --- async functions: suspend without blocking the underlying thread, built into the language ---
func fetchValue(id: Int, delayMs: UInt64) async -> Int {
    try? await Task.sleep(nanoseconds: delayMs * 1_000_000) // async-aware sleep, doesn't block a thread
    return id * 10
}

// --- Structured concurrency: async let and TaskGroup ---
func demonstrateConcurrency() async {
    print("--- Sequential await calls ---")
    let start1 = Date()
    let a = await fetchValue(id: 1, delayMs: 200)
    let b = await fetchValue(id: 2, delayMs: 200)
    print("a=\(a), b=\(b)")
    print("sequential took \(Date().timeIntervalSince(start1) * 1000)ms")

    print("\n--- Concurrent with async let ---")
    let start2 = Date()
    async let deferredA = fetchValue(id: 1, delayMs: 200) // starts immediately
    async let deferredB = fetchValue(id: 2, delayMs: 200) // runs alongside deferredA
    let (concurrentA, concurrentB) = await (deferredA, deferredB) // suspends until BOTH finish
    print("a=\(concurrentA), b=\(concurrentB)")
    print("concurrent took \(Date().timeIntervalSince(start2) * 1000)ms")
    print("(concurrent run should take roughly HALF the sequential run's time)")
}

// --- actor: a reference type providing compiler-enforced, data-race-free mutable state ---
// Unlike a `class` (Lesson 11), an actor's mutable state can ONLY be accessed via `await`
// from outside the actor -- the compiler enforces this, genuinely preventing data races
// at compile time, a stronger guarantee than Kotlin's Mutex-based manual discipline or
// even Rust's Arc<Mutex<T>> (which still requires remembering to lock manually).
actor BankAccount {
    private var balance: Double = 0

    func deposit(_ amount: Double) {
        balance += amount // safe -- only one task can execute inside the actor at a time
    }

    func getBalance() -> Double {
        return balance
    }
}

func demonstrateActor() async {
    let account = BankAccount()
    await account.deposit(100)
    await account.deposit(50) // each call is serialized by the actor -- no data race possible
    let balance = await account.getBalance()
    print("\nactor balance after two deposits: \(balance)")
}

// Top-level entry point using Task { } to run async code from synchronous context
// (a real .swift script would typically use a top-level `await` directly in newer Swift versions)
Task {
    await demonstrateConcurrency()
    await demonstrateActor()
}
