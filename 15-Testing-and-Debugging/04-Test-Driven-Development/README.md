# 04 — Test-Driven Development

[Back to module overview](../README.md) | [Previous: End-to-End Testing](../03-End-to-End-Testing/README.md)

## Beginner: The Red-Green-Refactor Cycle, For Real

Test-Driven Development means writing a failing test **before** writing the code that satisfies it, then writing the minimal code to make it pass, one requirement at a time. This lesson doesn't just describe that cycle — it walks through three real, verified red→green transitions building up a `PasswordStrengthValidator`, with the actual `mvn test` output captured at every single stage.

## Stage 1: Minimum Length

**Red** — the test is written first, against a stub implementation that always returns `true`:

```java
@Test
void passwordShorterThanEightCharsIsNotStrong() {
    assertFalse(validator.isStrong("abc1A"));
}
```

Verified live, run against the stub:

```
PasswordStrengthValidatorTest.passwordShorterThanEightCharsIsNotStrong:15 expected: <false> but was: <true>
Tests run: 1, Failures: 1, Errors: 0, Skipped: 0
```

**Green** — the minimal code satisfying this one test is written:

```java
public boolean isStrong(String password) {
    return password.length() >= 8;
}
```

Verified live: `Tests run: 1, Failures: 0, Errors: 0` — `BUILD SUCCESS`.

## Stage 2: Must Contain a Digit

**Red** — a second test is added first, for the next requirement:

```java
@Test
void passwordWithNoDigitIsNotStrong() {
    assertFalse(validator.isStrong("Abcdefgh")); // 8 chars, has uppercase, but NO digit
}
```

Verified live, against the length-only implementation from Stage 1:

```
PasswordStrengthValidatorTest.passwordWithNoDigitIsNotStrong:21 expected: <false> but was: <true>
Tests run: 2, Failures: 1, Errors: 0, Skipped: 0
```

**Green** — the digit rule is added:

```java
public boolean isStrong(String password) {
    return password.length() >= 8
            && password.chars().anyMatch(Character::isDigit);
}
```

Verified live: `Tests run: 2, Failures: 0, Errors: 0` — `BUILD SUCCESS`.

## Stage 3: Must Contain an Uppercase Letter

**Red** — the final requirement's test is added first, alongside a positive test confirming a fully-valid password is accepted:

```java
@Test
void passwordWithNoUppercaseIsNotStrong() {
    assertFalse(validator.isStrong("abcdefg1")); // 8 chars, has a digit, but NO uppercase
}
```

Verified live, against the length-and-digit implementation from Stage 2:

```
PasswordStrengthValidatorTest.passwordWithNoUppercaseIsNotStrong:27 expected: <false> but was: <true>
Tests run: 4, Failures: 1, Errors: 0, Skipped: 0
```

**Green** — the final rule is added:

```java
public boolean isStrong(String password) {
    return password.length() >= 8
            && password.chars().anyMatch(Character::isDigit)
            && password.chars().anyMatch(Character::isUpperCase);
}
```

Verified live: `Tests run: 4, Failures: 0, Errors: 0` — `BUILD SUCCESS`.

## Advanced: Why Each Stage's Failure Mattered

At every stage, the failing test was failing for exactly the reason expected — not a compile error, not an unrelated test breaking, but the *specific* new requirement genuinely not being satisfied yet by the current implementation. This is the actual value of the red step: it confirms the test can genuinely fail, and fails for the right reason, before trusting it to guard against regressions going forward.

## Detailed Example

See [PasswordStrengthValidator.java](src/main/java/com/example/tdd/PasswordStrengthValidator.java) (the final, complete implementation) and [PasswordStrengthValidatorTest.java](src/test/java/com/example/tdd/PasswordStrengthValidatorTest.java) (all 4 tests, accumulated across the 3 stages documented above).

## Run It

```bash
cd 15-Testing-and-Debugging/04-Test-Driven-Development
mvn test
```

## Expected Output

`Tests run: 4, Failures: 0, Errors: 0` and `BUILD SUCCESS` against the final code — all three requirements (length, digit, uppercase) verified together.

## Common Mistakes

- Writing the implementation first and tests afterward — this inverts TDD's actual value: verifying a test can genuinely fail (and fail for the right reason) before trusting it, which was demonstrated at every stage of this lesson.
- Writing multiple requirements' worth of implementation before writing or running any test — TDD's discipline is one small, verified red→green cycle at a time, exactly as shown across this lesson's 3 stages.
- Skipping the "refactor" step once tests are green — TDD's third phase (not deeply explored in this small example) is cleaning up the implementation while the passing tests continue to guarantee correctness.

## Best Practices

- Write the smallest possible failing test for the next requirement, run it, and confirm it fails for the expected reason before writing any implementation.
- Write the minimal code that makes the current failing test (and all previous tests) pass — resist the urge to implement more than what's currently being tested.
- Use the passing test suite as a safety net during refactoring — a genuinely comprehensive suite (like the 4 tests built here) lets implementation details change freely as long as all tests stay green.

## Real-World Usage

TDD is widely used specifically for its discipline of building up correctness incrementally and verifiably, rather than writing a large implementation and testing it only at the end. The `PasswordStrengthValidator` built in this lesson mirrors a common real scenario — validation logic with several independent rules — where TDD's one-requirement-at-a-time discipline naturally maps to one test per rule.

## Summary

- Three genuine red→green cycles were captured with real `mvn test` output: minimum length, then digit requirement, then uppercase requirement.
- At each stage, the new test failed for exactly the expected reason before the corresponding implementation was added, verifying the test's own correctness before relying on it.
- The final implementation and its 4-test suite were verified together, all passing.

## Key Terms

- **Red-Green-Refactor** — the TDD cycle: write a failing test (red), write minimal code to pass it (green), then clean up the implementation (refactor) while tests stay green.
- **TDD (Test-Driven Development)** — a development practice where tests are written before the implementation that satisfies them.

## Interview Questions

1. **What is the point of confirming a test fails (red) before writing the implementation, rather than just writing the implementation and test together?**
   Confirming the test fails first verifies that the test is actually capable of detecting the problem it's meant to catch, and that it fails for the *correct* reason — a test that never actually fails (due to a typo, a tautology, or testing the wrong thing) provides false confidence. This was demonstrated three times in this lesson: at each stage, the newly-added test was run against the *previous* stage's implementation and genuinely failed with a specific, expected message (e.g., `expected: <false> but was: <true>`) before any new implementation code was written to address it.

2. **Why does TDD recommend writing only the minimal code needed to pass the current test, rather than implementing the full final feature immediately?**
   Writing only the minimal code keeps each step small, verifiable, and directly tied to a specific, currently-failing test — this avoids writing untested code "ahead" of what's actually been verified. This was demonstrated concretely: Stage 1's implementation (`password.length() >= 8`) was genuinely minimal — it didn't yet check for digits or uppercase letters, because no test yet required it — and each subsequent stage added exactly one new check, justified by exactly one new, previously-failing test.

## Recommended Next Lesson

[05 — Debugging Techniques](../05-Debugging-Techniques/README.md)
