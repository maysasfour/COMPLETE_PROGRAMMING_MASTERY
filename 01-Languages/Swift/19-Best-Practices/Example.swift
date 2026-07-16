// Example.swift - Before/after: three genuine Swift anti-patterns and their fixes.
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason. Expected
// behavior is documented from Swift's language semantics, not confirmed by execution.

import Foundation

// --- Anti-pattern 1: force-unwrap (!) crashing instead of safe optional handling ---
func findUserBad(_ users: [String: Int], _ name: String) -> Int {
    return users[name]! // CRASHES the entire program with a fatal error if name isn't found
}
func findUserGood(_ users: [String: Int], _ name: String) throws -> Int {
    guard let id = users[name] else {
        throw NSError(domain: "UserLookup", code: 1,
                       userInfo: [NSLocalizedDescriptionKey: "no user named '\(name)' found"])
    }
    return id
}

// --- Anti-pattern 2: using `class` where `struct` would prevent an aliasing bug ---
class MutablePointClass { // reference type -- shared mutable state, easy to alias by accident
    var x: Int
    var y: Int
    init(x: Int, y: Int) { self.x = x; self.y = y }
}
struct PointStruct { // value type -- copied, no accidental aliasing possible
    var x: Int
    var y: Int
}

func moveRight(_ point: MutablePointClass) {
    point.x += 1 // mutates the ORIGINAL object -- any other reference sees this change too
}
func movedRight(_ point: PointStruct) -> PointStruct {
    var copy = point // an explicit, independent copy
    copy.x += 1
    return copy // the CALLER's original point is never touched
}

// --- Anti-pattern 3: a closure retaining self strongly, creating a retain cycle ---
class NotificationCenterBad {
    var onNotify: (() -> Void)?
    var name: String
    init(name: String) { self.name = name }
    func subscribeBad() {
        onNotify = { // captures self STRONGLY by default -- if self also holds this closure
                       // (which it does, via onNotify), this is a genuine retain cycle
            print("\(self.name) notified") // implicitly captures self strongly
        }
    }
}
class NotificationCenterGood {
    var onNotify: (() -> Void)?
    var name: String
    init(name: String) { self.name = name }
    func subscribeGood() {
        onNotify = { [weak self] in // breaks the potential retain cycle
            guard let self = self else { return }
            print("\(self.name) notified")
        }
    }
}

func demonstrate() {
    print("--- Anti-pattern 1: force-unwrap vs safe handling ---")
    let users = ["Ada": 1, "Grace": 2]
    // findUserBad(users, "Linus") // would CRASH the whole program with a fatal error
    do {
        _ = try findUserGood(users, "Linus")
    } catch {
        print("good: caught a clear, specific error: \(error.localizedDescription)")
    }

    print("\n--- Anti-pattern 2: class aliasing vs struct value semantics ---")
    let classPoint = MutablePointClass(x: 1, y: 2)
    let aliasedReference = classPoint // NOT a copy -- same object
    moveRight(classPoint)
    print("bad: aliasedReference.x is now \(aliasedReference.x) too, even though we only moved classPoint")

    let structPoint = PointStruct(x: 1, y: 2)
    let moved = movedRight(structPoint)
    print("good: structPoint.x is still \(structPoint.x); moved.x is \(moved.x)")

    print("\n--- Anti-pattern 3: retain cycle vs [weak self] ---")
    print("(see this file's NotificationCenterBad/Good classes -- a retain cycle isn't")
    print(" directly observable via console output; it's detected via memory profiling tools")
    print(" like Xcode's Memory Graph Debugger, which is why this anti-pattern is often")
    print(" invisible until an app's memory usage grows unexpectedly over time.)")
}

demonstrate()
