# 14 — Async and Concurrency

[Back to course overview](../README.md) | [Previous: Generics](../13-Generics/README.md)

## Learning Objectives

- Use `Future`/`async`/`await`, built directly into the language (like Swift, unlike Kotlin's library-based coroutines).
- Use `Stream` for asynchronous *sequences* of values — a genuinely distinctive concept beyond a single `Future`.
- Understand `Isolate`s — Dart's parallelism model, with **no shared-memory threading at all**, only message-passing between fully independent, isolated event loops — a genuinely unique concurrency model among the languages covered in this repository.

## Prerequisites

[13-Generics](../13-Generics/README.md)

## Concept

Dart's `async`/`await` and `Future` are built directly into the language and standard library, requiring no external dependency (matching Swift, contrasted with Kotlin's need for the separate `kotlinx.coroutines` library, both covered earlier in this repository). Dart adds `Stream` for representing an asynchronous *sequence* of values over time (not just a single eventual result), and — most distinctively — Dart code runs single-threaded by default within an `Isolate`, with genuine parallelism achieved only by spawning entirely separate isolates that share **no memory at all**, communicating exclusively via message passing.

## `Future`/`async`/`await`, Verified with Real Timing

```dart
Future<int> fetchValue(int id, int delayMs) async {
  await Future.delayed(Duration(milliseconds: delayMs)); // suspends without blocking
  return id * 10;
}

var a = await fetchValue(1, 200);
var b = await fetchValue(2, 200); // sequential -- b doesn't start until a's await completes
```

```dart
var results = await Future.wait([
  fetchValue(1, 200), // starts immediately
  fetchValue(2, 200), // runs alongside the first
]);
```

Verified live with real timing: two sequential 200ms-delayed calls took **433ms** total, while the same two calls issued concurrently via `Future.wait` took **203ms** — confirming genuine concurrent execution, not just asserted, mirroring the same measurement discipline used in this repository's Kotlin and Rust courses for their own concurrency claims.

## `Stream`: An Asynchronous Sequence of Values

```dart
Stream<int> countStream(int max) async* { // async* generator function
  for (var i = 1; i <= max; i++) {
    await Future.delayed(Duration(milliseconds: 10));
    yield i; // produces the next value
  }
}

await for (var value in countStream(5)) {
  print(value);
}
```

A `Stream` represents zero or more asynchronous values delivered over time (as opposed to a `Future`'s single eventual value) — genuinely distinct from every other language's core async primitive covered in this repository, and directly analogous to reactive/observable patterns in other ecosystems, but built into Dart's language syntax itself (`async*`/`yield`, `await for`).

## `Isolate`: No Shared Memory, Message Passing Only

```dart
void isolateEntryPoint(SendPort sendPort) {
  var result = 0;
  for (var i = 1; i <= 1000000; i++) { result += i; }
  sendPort.send(result); // the ONLY way to communicate back
}

var receivePort = ReceivePort();
await Isolate.spawn(isolateEntryPoint, receivePort.sendPort);
var isolateResult = await receivePort.first;
```

Verified live: spawning a separate isolate to compute a sum, then receiving its result via a `ReceivePort`, correctly returned `500000500000`. Unlike Rust's `Arc<Mutex<T>>` or Java/Kotlin's shared-memory threads (both covered elsewhere in this repository), Dart isolates share **absolutely no memory** — each isolate has its own heap, its own event loop, and the *only* way to communicate between them is passing serializable messages through ports. This eliminates data races as a category of bug entirely (there's no shared mutable state to race over), at the cost of needing explicit message-passing for any inter-isolate communication, a genuinely different trade-off from every other concurrency model covered in this repository.

## Detailed Example

See [example.dart](example.dart) — sequential vs. concurrent `Future`-based calls with real measured timing, a `Stream` generator consumed with `await for`, and an `Isolate` computing a sum and communicating the result back via message passing.

## Run It

```bash
cd 01-Languages/Dart/14-Async-and-Concurrency
dart run example.dart
```

## Expected Output

Running `dart run example.dart` prints `a=10, b=20` for both the sequential and concurrent runs, with the sequential run's measured time (433ms in this environment) roughly double the concurrent run's (203ms), each of the 5 stream values printed individually, and `sum computed in a separate isolate: 500000500000` — all confirmed by actual execution.

## Common Mistakes

- Assuming Dart has shared-memory threads the way Java/Kotlin/Rust do — it doesn't; parallelism is achieved exclusively through isolates, which share no memory and communicate only via message passing.
- Using `await fetchValue(); await fetchValue();` sequentially when concurrency was intended — `Future.wait([...])` (or starting each `Future` before awaiting either) is needed to actually run them concurrently, verified live to roughly halve the total time.
- Forgetting a `Stream` must be consumed (via `await for`, `.listen()`, or similar) — unlike a `Future`, which resolves once, a `Stream` produces values over time and needs an active subscriber to receive them.

## Best Practices

- Use `Future.wait([...])` for independent asynchronous operations that can run concurrently, rather than sequential `await` calls.
- Use `Stream` for genuinely sequential, time-distributed data (user input events, chunks of a large file, WebSocket messages) rather than trying to force a single `Future` to represent multiple values.
- Use `Isolate`s for genuinely CPU-bound work that would otherwise block the main isolate's event loop (image processing, heavy computation) — Dart's single-threaded-per-isolate model means CPU-bound work on the main isolate blocks all UI/event handling until it completes.

## Real-World Usage

`Future`/`async`/`await` and `Stream` are used pervasively throughout real Dart/Flutter code — `Stream`s specifically back Flutter's `StreamBuilder` widget for reactive UI updates from asynchronous data sources, and `Isolate`s are the standard mechanism for offloading CPU-intensive work (JSON parsing of very large payloads, image manipulation) off Flutter's main UI isolate to avoid frame drops.

## Summary

- `Future`/`async`/`await` are built into Dart's language and standard library — no external dependency needed, matching Swift, contrasted with Kotlin's `kotlinx.coroutines`.
- `Stream` represents an asynchronous sequence of values over time, a genuinely distinctive concept beyond a single `Future`.
- `Isolate`s provide Dart's only parallelism mechanism — no shared memory at all, only message passing, verified live via a spawned isolate correctly computing and returning a sum.

## Key Terms

- **`Stream`** — represents zero or more asynchronous values delivered over time, consumed via `await for` or `.listen()`.
- **`Isolate`** — an independent Dart execution context with its own memory and event loop; the only unit of true parallelism in Dart, communicating exclusively via message passing.

## Interview Questions

1. **How does Dart achieve parallelism, given it has no shared-memory threading at all?**
   Dart uses `Isolate`s: independent execution contexts, each with its own memory heap and event loop, that cannot directly access or mutate each other's state. The only way isolates communicate is by sending serializable messages through `SendPort`/`ReceivePort` pairs — verified live in this lesson, where a spawned isolate computed a sum and sent the result back via a port, with the main isolate awaiting that message. This is a genuinely different model from Java/Kotlin's shared-memory threads (requiring locks/mutexes to coordinate safely) or Rust's `Arc<Mutex<T>>` (both covered elsewhere in this repository) — Dart's isolate model eliminates data races as a category of bug entirely, since there's no shared mutable memory to race over in the first place, at the cost of needing explicit message-passing for any cross-isolate communication.

2. **What's the difference between a `Future` and a `Stream` in Dart, and why does Dart need both?**
   A `Future` represents a single, eventual asynchronous result — it resolves exactly once, either with a value or an error. A `Stream` represents zero or more asynchronous values delivered over time, consumed via `await for` (as demonstrated in this lesson with a generator function using `async*`/`yield`) or `.listen()` for a subscription-based approach. Dart needs both because many real asynchronous scenarios genuinely involve a sequence of values over time (user input events, incoming WebSocket messages, chunks of a large file being read) rather than a single eventual result — trying to model these with `Future` alone would require awkward workarounds like a `List<Future<T>>` computed all at once, losing the "as they arrive, over time" semantics that `Stream` provides natively.

## Recommended Next Lesson

[15 — Modules and Packages](../15-Modules-and-Packages/README.md)
