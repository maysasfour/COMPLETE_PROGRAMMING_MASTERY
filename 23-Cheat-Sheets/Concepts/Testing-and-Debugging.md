# Testing and Debugging Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../15-Testing-and-Debugging/README.md)

## The Testing Pyramid
| Layer | Speed | Catches | Verified example |
|---|---|---|---|
| Unit | Fastest | Logic bugs in one isolated unit | A percentage bug caught with `expected: <80.0> but was: <-1900.0>` |
| Integration | Medium | Bugs only real I/O exposes | An unflushed `FileWriter` caused real data loss a mock couldn't catch |
| End-to-End | Slowest | Wiring bugs across the whole app | A handler registered at the wrong URL returned a real `404` |

See [15-Testing-and-Debugging](../../15-Testing-and-Debugging/README.md) Lessons 01-03.

## JUnit 5 Quick Reference
```java
@Test
void discountAppliesCorrectly() {
    assertEquals(80.0, calculator.applyDiscount(100.0, 20.0), 0.001);
}

@Test
void savedNoteCanBeLoadedBack(@TempDir Path tempDir) {
    // real file I/O, in a real temp directory
}
```

## TDD: Red-Green-Refactor
1. Write ONE failing test for the next requirement (confirm it genuinely fails, for the right reason).
2. Write the minimal code to pass it.
3. Refactor while tests stay green.

Verified live across 3 real cycles in [15-Testing-and-Debugging/04](../../15-Testing-and-Debugging/04-Test-Driven-Development/README.md).

## Reading a Stack Trace
Read top-down: the exception message + the topmost frame in **your own code** points to the actual root cause, not necessarily where you caught it. Verified live in [15-Testing-and-Debugging/05](../../15-Testing-and-Debugging/05-Debugging-Techniques/README.md) with a real `ArrayIndexOutOfBoundsException`.

## Diagnosing Silent (Non-Crashing) Bugs
Add a targeted diagnostic log at the boundary of a suspect function, checking state *before* and *after*. Verified live: one log line revealed a `static` accumulator was contaminating two "accounts'" totals.

See the [full Testing and Debugging module](../../15-Testing-and-Debugging/README.md) for verified, runnable code for everything above.
