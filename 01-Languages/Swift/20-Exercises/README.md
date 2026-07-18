# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

> ## ⚠️ Update: A Working Swift Toolchain Was Found For Lessons 20–22
>
> Lessons 01–19 of this course (see the [course README](../README.md)) were written and explicitly disclosed as **unverified by execution**, because no Swift toolchain was available when they were written. When this folder and its siblings ([21-Solutions](../21-Solutions/README.md), [22-Mini-Projects](../22-Mini-Projects/README.md)) were built, in a later session, a Swift toolchain (**Swift 6.1.2**, `x86_64-unknown-windows-msvc`) turned out to be genuinely installed and working in this environment — provided Visual Studio's C/C++ build environment variables are initialized first via `vcvarsall.bat x64` (`swiftc` fails outright without it: the Windows SDK's `errno.h` and related C headers are otherwise unreachable, since Swift's Windows toolchain shells out to `clang-cl`/`link.exe` for the final native build).
>
> **What this means practically:** every solution file in [21-Solutions](../21-Solutions/README.md) and the mini-project in [22-Mini-Projects](../22-Mini-Projects/README.md) **was actually compiled and run** against this real toolchain — output shown is captured from real execution, not predicted. This is a genuine change of circumstance from lessons 01–19, not a contradiction of the honesty policy: the exercises in *this* folder are problem statements only (no output to verify), lessons 01–19 remain exactly as originally written and still carry their own unverified notice, and re-verifying them against this same now-available toolchain remains valuable, not-yet-done follow-up work.

Seven standalone practice problems spanning the whole course, roughly ordered from easier to harder. Each is self-contained — you don't need to solve them in order, but earlier ones lean on earlier lessons only, while later ones combine several topics. These are deliberately different problems from the `Exercises/` folders already inside Lessons 05, 06, and 07 (FizzBuzz-with-`switch`, variadic functions/trailing closures, and array `filter`/`map`/`reduce` respectively) — solve those first if you haven't, then come back here for problems that pull in Optionals/`guard let`, `struct`-vs-`class` semantics, protocol-oriented programming, enums with associated values, generics with protocol constraints, and `async`/`await`/`actor`.

Attempt each problem yourself in a scratch `.swift` file before looking at [21-Solutions](../21-Solutions/README.md). Solutions are numbered to match (`exercise-01` &harr; `solution-01.swift`).

## Exercise 01 — Safe Contact Lookup (Beginner)

**Lessons used:** Variables and Data Types / Optionals (03), Collections (07)

Given `let contacts: [String: String?] = ["Alice": "alice@example.com", "Bob": nil, "Carol": "carol@example.com"]` (a dictionary whose *values* are themselves optional — `Bob` has a key but no email on file, distinct from a name that isn't in the dictionary at all), write:

- `func lookup(_ name: String, in contacts: [String: String?]) -> String` that uses `guard let` (not `if let`, not `!`) to distinguish all three cases: name not present at all &rarr; `"<name> is not a contact"`; name present but email is `nil` &rarr; `"<name> has no email on file"`; name present with an email &rarr; `"<name>: <email>"`. Note `Dictionary` subscripting on a `[String: String?]` returns `String??` (double-optional) — you'll need to reason carefully about which layer of optionality each `guard let` is unwrapping.
- Call it for `"Alice"`, `"Bob"`, and `"Dave"` (not in the dictionary) and print each result.

## Exercise 02 — Struct vs. Class Aliasing (Beginner/Intermediate)

**Lessons used:** OOP / `struct` vs. `class` (11)

Define a `struct PointStruct { var x: Int; var y: Int }` and a `class PointClass { var x: Int; var y: Int; init(x: Int, y: Int) { self.x = x; self.y = y } }` with identical fields.

- Create a `PointStruct` instance, assign it to a second `var`, mutate the second variable's `x`, and print both — prove the first is untouched (value semantics).
- Create a `PointClass` instance, assign it to a second `let`, mutate the second reference's `x` (mutating a class's stored property through a `let` reference is legal, since the reference itself isn't being reassigned), and print both — prove **both** show the mutation (reference semantics, an aliasing bug if it were unintended).
- Write a function `func movedRight(_ p: PointStruct) -> PointStruct` that takes a `PointStruct` **by value**, returns a new struct with `x + 1`, and prove the original argument passed to it is unaffected after the call.

## Exercise 03 — Protocol Extensions and Retroactive Conformance (Intermediate)

**Lessons used:** OOP / Protocol-Oriented Programming (11), Generics (13)

Define a protocol `protocol Summable { static func + (lhs: Self, rhs: Self) -> Self; static var zero: Self { get } }` and a protocol extension providing a default method `func summed(with others: [Self]) -> Self` that folds `others` onto `self` using `+` and `.zero` as the seed (via `reduce`).

- Conform `Int` and `Double` to `Summable` retroactively (`extension Int: Summable { static var zero: Int { 0 } }` — `+` is already provided by the standard library) with **no** additional method implementations needed beyond `zero`, proving the protocol extension's default `summed(with:)` is inherited for free by both.
- Define your own `struct Money: Summable, CustomStringConvertible` (wrapping a `Double` amount) implementing `+` and `.zero` yourself, and show `summed(with:)` works on an array of `Money` values too, with no `Money`-specific `summed` implementation written.

## Exercise 04 — Enum with Associated Values: a `NetworkResult` (Intermediate/Advanced)

**Lessons used:** Control Flow / pattern matching (05), Error Handling (09), OOP / enums (11)

Define `enum NetworkResult<T> { case success(T); case failure(code: Int, message: String); case loading }` — an enum with associated values modeling a network call's three possible states (comparable to Rust's `enum`, covered earlier in this repository).

- Write `func describe<T>(_ result: NetworkResult<T>) -> String` using an **exhaustive `switch`** (no `default:` case) that pattern-matches each case, binding the associated values (`case .success(let value):`, `case .failure(let code, let message):`) and formatting a distinct message for each.
- Call `describe` with a `NetworkResult<[String]>.success(["a", "b"])`, a `.failure(code: 404, message: "Not Found")`, and a `.loading`, printing each description.
- Add a fourth case, `case cancelled`, to the enum and observe (in your own testing, not required to submit as output) that the compiler now flags `describe`'s `switch` as non-exhaustive until you handle it too — this is the same compile-time exhaustiveness guarantee Rust's `match` provides, contrasted with a plain class hierarchy where a missed case is only a runtime surprise.

## Exercise 05 — Generic `Stack<Element>` with a Protocol Constraint (Advanced)

**Lessons used:** Generics (13), Collections (07)

Implement a generic `struct Stack<Element> { private var items: [Element] = []; mutating func push(_ item: Element); mutating func pop() -> Element?; func peek() -> Element?; var isEmpty: Bool { get }; var count: Int { get } }` backed internally by a Swift `Array` (which is itself a value type, so `Stack` gets value semantics "for free").

- Add a constrained extension `extension Stack where Element: Equatable { func contains(_ item: Element) -> Bool }` that only exists when `Element` conforms to `Equatable` — proving Swift's constrained-extension mechanism (conditional conformance/availability based on a generic constraint).
- Demonstrate the stack with `Int` elements: push 1, 2, 3; pop once (prove it returns `3`, LIFO order); call `contains(2)` (only available because `Int: Equatable`); print the final `count`.
- Prove (in your own testing) that calling `.contains(...)` on a hypothetical `Stack<SomeNonEquatableType>` is a **compile error**, not a runtime one — the constraint is enforced statically.

## Exercise 06 — Concurrent "Fetches" with `async`/`await` and an `actor` (Advanced)

**Lessons used:** Async and Concurrency (14), Error Handling (09)

Write `func simulatedFetch(_ id: Int, delayMs: UInt64) async -> Int` that calls `try? await Task.sleep(nanoseconds: delayMs * 1_000_000)` then returns `id * 10` (a stand-in for a network round trip, mirroring this repository's other language courses' concurrency exercises without a real network dependency).

- Using a `withTaskGroup(of: Int.self)`, kick off at least 4 simulated fetches concurrently with different delays, collect all results into an array, and print the total.
- Measure wall-clock time (`ContinuousClock` or `DispatchTime`) around the task group and print it, then explain (in a comment) why it should track the *slowest* individual delay rather than the *sum* of all delays — proving genuine concurrency, not sequential execution.
- Define `actor RequestCounter { private var count = 0; func increment() -> Int { count += 1; return count } }` and have each concurrent fetch call `await counter.increment()` before returning, proving (by printing the final count) that the actor safely serializes concurrent mutation with no manual locking — Swift's compiler-enforced alternative to a mutex.

## Exercise 07 — `Codable` JSON Roundtrip with Validation (Advanced)

**Lessons used:** File Handling / `Codable` (10), Error Handling (09), OOP (11)

Define `struct Book: Codable, Equatable { let title: String; let author: String; let year: Int; let rating: Double }` and a custom `enum BookValidationError: Error { case ratingOutOfRange(Double) }`.

- Write `func validate(_ book: Book) throws -> Book` that `throw`s `BookValidationError.ratingOutOfRange` if `rating` isn't in `0.0...5.0`, otherwise returns the book unchanged.
- Build an array of at least 4 `Book` values (including at least one that would fail validation), encode the *valid* ones to JSON with `JSONEncoder` (`.outputFormatting = .prettyPrinted`), then decode that JSON back with `JSONDecoder` into a new `[Book]` and confirm (via `==`, relying on `Equatable`) the roundtripped array matches the original valid-only array.
- Wrap the validation step in a `do`/`catch` and print a clear message for the book that fails validation, proving invalid data never reaches the encoding step.

## Suggested Next Lesson

[21 — Solutions](../21-Solutions/README.md) — but only after you've attempted each exercise yourself.
