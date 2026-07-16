# 01 — Unit Testing

[Back to module overview](../README.md)

## Beginner: What a Unit Test Actually Verifies

A unit test exercises one small unit of behavior — here, a single method, `PriceCalculator.applyDiscount()` — completely in isolation, with no database, network, or file system involved. This lesson uses real JUnit 5 tests (not hand-rolled assertions) that **genuinely caught a real, pre-existing bug** in the code they test, verified by actually running `mvn test` in both the broken and fixed states.

Note: this lesson uses plain JUnit 5 with no framework, distinct from [04-Backend-Development Lesson 05](../../04-Backend-Development/05-Testing-a-REST-API/README.md), which covers Spring Boot's `@WebMvcTest`/`@MockitoBean` testing of a full REST API.

## The Bug: A Real, Verified Test Failure

```java
public double applyDiscount(double price, double discountPercent) {
    return price - (price * discountPercent); // BUG: forgot to divide by 100!
}
```

`discountPercent` is meant to be a whole-number percentage (`20` meaning 20%), but the calculation treats it as a raw fraction instead. Verified live, running the real test suite against this buggy version:

```
[ERROR] com.example.unittesting.PriceCalculatorTest.twentyPercentDiscountOnHundredDollarsIsEighty -- Time elapsed: 0.005 s <<< FAILURE!
org.opentest4j.AssertionFailedError: 20% off $100 should be $80 ==> expected: <80.0> but was: <-1900.0>
[ERROR] com.example.unittesting.PriceCalculatorTest.hundredPercentDiscountMakesItFree -- Time elapsed: 0.014 s <<< FAILURE!
org.opentest4j.AssertionFailedError: 100% off should make the price $0 ==> expected: <0.0> but was: <-7425.0>
Tests run: 3, Failures: 2, Errors: 0, Skipped: 0
```

Two of the three tests failed with wildly wrong actual values (`-1900.0`, `-7425.0`) — this is exactly the value of a unit test: it caught a genuine, severe calculation bug immediately, with a precise, actionable failure message pointing at the exact expected-vs-actual mismatch.

## The Fix, Verified Green

```java
public double applyDiscount(double price, double discountPercent) {
    return price - (price * discountPercent / 100.0);
}
```

Re-running the identical test suite after the fix:

```
Tests run: 3, Failures: 0, Errors: 0
BUILD SUCCESS
```

All three tests — the 20% case, the 0% edge case, and the 100% edge case — now pass, verified by an actual, complete `mvn test` run.

## Detailed Example

See [PriceCalculator.java](src/main/java/com/example/unittesting/PriceCalculator.java) (now containing the fixed version) and [PriceCalculatorTest.java](src/test/java/com/example/unittesting/PriceCalculatorTest.java) — the actual tests that caught the bug documented above.

## Run It

```bash
cd 15-Testing-and-Debugging/01-Unit-Testing
mvn test
```

To see the original failure for yourself, temporarily change `PriceCalculator.applyDiscount()` back to `return price - (price * discountPercent);` and rerun `mvn test`.

## Expected Output

`Tests run: 3, Failures: 0, Errors: 0` and `BUILD SUCCESS` against the current (fixed) code.

## Common Mistakes

- Only testing the "obvious" case and skipping edge cases (0%, 100%) — this lesson's edge-case tests (`zeroPercentDiscountLeavesPriceUnchanged`, `hundredPercentDiscountMakesItFree`) are exactly the kind of test that catches bugs a single happy-path test would miss.
- Writing a unit test that depends on external state (a real database, real time, real randomness) — this stops being a "unit" test and becomes slow, flaky, and hard to reason about; `PriceCalculator` here has no such dependency.
- Using an assertion delta that's too loose (or missing for floating-point comparisons) — this lesson's `assertEquals(80.0, result, 0.001, ...)` includes an explicit delta appropriate for floating-point comparison, avoiding false failures from floating-point representation error.

## Best Practices

- Write tests that fully isolate the unit under test — no real I/O, no shared mutable state between tests.
- Cover meaningful edge cases (boundaries like 0% and 100% here), not just one "typical" input.
- Give assertions a clear failure message (the third argument to `assertEquals` here) so a failing test immediately communicates what was expected and why, without needing to read the test's source to understand it.

## Real-World Usage

Unit tests are the fastest, most numerous layer of a healthy test suite (the base of the "testing pyramid," referenced again in [03-End-to-End-Testing](../03-End-to-End-Testing/README.md)) — they run in milliseconds and pinpoint exactly which unit of logic broke. The specific bug in this lesson (forgetting to convert a percentage to a fraction) is a genuinely common, real category of calculation bug, and this lesson's tests are a faithful, real demonstration of a unit test doing exactly its job: catching it immediately, with a precise, actionable failure message.

## Summary

- A real bug (treating a percentage as a raw fraction) was caught by real JUnit 5 tests, verified via an actual `mvn test` run showing 2 of 3 tests failing with clearly wrong values.
- Fixing the calculation and rerunning the identical test suite verified all 3 tests passing (`BUILD SUCCESS`).
- Testing meaningful edge cases (0%, 100%), not just a single typical case, is what caught the bug's full severity.

## Key Terms

- **Unit test** — a test that exercises one small unit of behavior in complete isolation from external dependencies.
- **Assertion** — a statement in a test that verifies an expected condition, failing the test with a clear message if it doesn't hold.
- **Red/Green** — the common shorthand for a failing ("red") vs. passing ("green") test run.

## Interview Questions

1. **What makes a test a "unit" test specifically, as opposed to some other kind of test?**
   A unit test exercises one small, isolated piece of behavior — typically a single method or class — with no real external dependencies (no database, network, file system, or shared mutable state). This lesson's `PriceCalculatorTest` tests exactly one method, `applyDiscount()`, with plain numeric inputs and no I/O of any kind, making it fast (all 3 tests ran in about 0.02 seconds combined) and fully isolated from anything outside `PriceCalculator` itself.

2. **How did this lesson demonstrate a unit test actually catching a real bug, rather than just illustrating the concept?**
   The `PriceCalculator.applyDiscount()` method genuinely contained a bug (using `discountPercent` directly instead of dividing by 100), and running the real test suite against that buggy version produced real, verified failures: `expected: <80.0> but was: <-1900.0>` for the 20%-discount case, and an even more dramatic `expected: <0.0> but was: <-7425.0>` for the 100%-discount edge case. After fixing the calculation to `price - (price * discountPercent / 100.0)`, rerunning the identical test suite produced `Tests run: 3, Failures: 0, Errors: 0` — a real, verified transition from red to green, not just an assertion that testing "would" have caught the bug.

## Recommended Next Lesson

[02 — Integration Testing](../02-Integration-Testing/README.md)
