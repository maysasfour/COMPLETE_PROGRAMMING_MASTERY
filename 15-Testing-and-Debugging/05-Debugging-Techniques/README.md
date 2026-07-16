# 05 — Debugging Techniques

[Back to module overview](../README.md) | [Previous: Test-Driven Development](../04-Test-Driven-Development/README.md)

## Beginner: Two Different Kinds of Bugs, Two Different Techniques

A **crash** (an exception) gives you a stack trace — a direct pointer to where things went wrong, if you read it correctly. A **silent logic bug** (wrong output, no crash) gives you nothing for free — you have to add your own instrumentation to see what's actually happening. This lesson demonstrates both techniques against real, reproducible bugs, with real captured output.

## Technique 1: Reading a Real Stack Trace

```java
static int sumWithOffByOneBug(int[] numbers) {
    int total = 0;
    for (int i = 0; i <= numbers.length; i++) { // BUG: should be i < numbers.length
        total += numbers[i];
    }
    return total;
}
```

Verified live, running this against a real 3-element array:

```
Caught: java.lang.ArrayIndexOutOfBoundsException: Index 3 out of bounds for length 3
Stack trace (read TOP-DOWN -- the top frame is where it actually happened):
  at Example.sumWithOffByOneBug(Example.java:15)
```

Reading this correctly: the exception message itself (`Index 3 out of bounds for length 3`) tells you the exact index and the exact array length involved — index 3 is out of range for a length-3 array (valid indices are 0, 1, 2). The **top** frame of the stack trace (`Example.sumWithOffByOneBug(Example.java:15)`) points to exactly the line where the invalid access happened — not where the exception was caught, which can be a completely different place in a larger program. Reading top-down, starting with the message and the top frame, is the fastest path to the actual root cause.

## Technique 2: Bisecting a Silent Logic Bug With Diagnostic Logging

A logic bug produces no exception at all — just a wrong answer. This requires actively adding instrumentation to narrow down *where* the wrong value first appears, rather than reading anything handed to you automatically.

```java
static int sharedAccumulatorBug = 0; // BUG: shared across ALL accounts, never reset per-account
static int processAccountViolation(String accountName, List<Integer> transactions) {
    for (int amount : transactions) { sharedAccumulatorBug += amount; }
    return sharedAccumulatorBug;
}
```

Verified live, processing two separate accounts that should have completely independent totals:

```
Account A total: 150 (expected 150)
Account B total: 170 (expected 20, but got contamination from Account A!)
```

Account B's total is wrong, but *why*? Adding one diagnostic log line at the very start of the function — before any of the current call's own transactions are even added — immediately isolates the problem:

```
[DEBUG] Account A starting, accumulator BEFORE processing = 0
[DEBUG] Account B starting, accumulator BEFORE processing = 150
```

That single line proves the root cause directly: Account B's accumulator was already `150` **before** any of its own transactions were processed — it should have started at `0` for a fresh account. This immediately points to `sharedAccumulatorBug` being a `static` field shared across every call, rather than something local and independent per account.

## The Fix, Verified

```java
static int processAccountFixed(List<Integer> transactions) {
    int total = 0; // LOCAL to this call -- cannot leak into any other account's total
    for (int amount : transactions) { total += amount; }
    return total;
}
```

Verified live:

```
Account A total (fixed): 150 (correct)
Account B total (fixed): 20 (correct -- no contamination)
```

## Detailed Example

See [Example.java](Example.java) — both a real crash with its actual stack trace, and a real silent logic bug diagnosed with real diagnostic log output.

## Run It

```bash
cd 15-Testing-and-Debugging/05-Debugging-Techniques
javac Example.java
java Example
```

## Expected Output

A real `ArrayIndexOutOfBoundsException` with its actual stack trace, read and interpreted; a real silent bug (account total contamination) diagnosed via real diagnostic log output showing exactly where the wrong value entered; the fixed version producing correct, independent totals.

## Common Mistakes

- Reading only the exception's *message* and ignoring the stack trace's frames — the top frame is what actually pinpoints the line responsible, especially in a larger program where the catch block is far from where the exception originated.
- Guessing at a logic bug's cause without adding any instrumentation to actually observe the program's real state — verified live that a single, well-placed diagnostic log line immediately revealed the root cause (a non-zero starting accumulator) that would otherwise require guesswork.
- Using shared mutable state (like a `static` field) across operations that should be independent — verified live to cause a real, silent contamination bug between two accounts' totals.

## Best Practices

- Read a stack trace top-down: the topmost frame in your own code is almost always where the actual problem occurred, not necessarily where you first noticed it.
- When a bug produces no exception, add targeted diagnostic logging at the boundaries of suspect functions — logging state *before* and *after* an operation is often enough to immediately localize where an unexpected value first appears.
- Prefer local, per-call state over shared mutable state (`static` fields, shared caches) for anything that should be logically independent between calls — this class of bug (silent contamination between unrelated operations) is entirely avoided by not sharing state that shouldn't be shared.

## Real-World Usage

Reading stack traces correctly is a foundational, daily skill — the fastest fix to any crash starts with reading the trace's top frame and the exception's own message, before ever opening a debugger. Diagnostic logging/print-statement bisection remains a genuinely effective technique even with modern debuggers available, especially for issues in production systems where attaching an interactive debugger isn't practical — the shared-static-state bug demonstrated here is a real, common category of production data-integrity bug.

## Summary

- A real `ArrayIndexOutOfBoundsException` was correctly diagnosed by reading its message and its stack trace's top frame, pinpointing the exact off-by-one loop bound responsible.
- A real, silent logic bug (account total contamination) was diagnosed by adding a single, targeted diagnostic log line, which immediately revealed the accumulator's incorrect starting value — the actual root cause.
- Both bugs were then fixed and the fixes verified with real, correct output.

## Key Terms

- **Stack trace** — the sequence of method calls active at the moment an exception was thrown, from the point of the exception (top) back to the program's entry point (bottom).
- **Diagnostic logging** — temporarily adding log/print statements to observe a program's actual internal state, used to localize the source of a silent (non-crashing) bug.
- **Bisection (in debugging)** — narrowing down the location of a bug by checking state at successive points, similar in spirit to binary search.

## Interview Questions

1. **When reading a stack trace, why does the topmost frame matter more than where the exception was actually caught?**
   The topmost frame shows exactly where the exception was thrown — the actual point of failure — while the `catch` block can be anywhere else in the program, often far removed from the real cause. This was demonstrated concretely: the caught `ArrayIndexOutOfBoundsException`'s top frame pointed directly to `Example.sumWithOffByOneBug(Example.java:15)`, immediately identifying the exact line with the off-by-one loop condition, rather than requiring a search through the rest of the program to find where the invalid index was actually generated.

2. **How does diagnostic logging help diagnose a bug that produces no exception at all, and how was this demonstrated?**
   A silent logic bug gives no automatic pointer to its cause the way a stack trace does — you have to actively observe the program's real internal state to find where it diverges from expectations. This was demonstrated by adding one log line at the start of `processAccountViolation`, printing the accumulator's value before any of the current call's transactions were processed. That single line revealed the accumulator was `150` (not `0`) when Account B began processing — immediately proving the accumulator was being shared across accounts rather than reset per account, which directly identified the root cause (a `static` field) without needing to guess or attach an interactive debugger.

## Recommended Next Lesson

This is the final lesson in the Testing and Debugging module. Continue to [16-Security](../../16-Security/README.md) if built, or return to the [module overview](../README.md).
