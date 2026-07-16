# 15 — Testing and Debugging

[Back to repository root](../README.md)

## What Testing and Debugging Covers

This module covers the full testing pyramid — unit, integration, and end-to-end tests — plus test-driven development and systematic debugging technique, each demonstrated with a real, pre-existing bug that the described technique actually caught (or, for debugging, actually diagnosed), verified by real `mvn test` output or real program output at every stage.

## Why Java as This Module's Reference Language

This repository's concept modules each pick one reference language rather than duplicating every lesson across every language in `01-Languages` (see [14-APIs-and-Integrations](../14-APIs-and-Integrations/README.md) for the same reasoning). Lessons 01-04 use plain JUnit 5 (`junit-jupiter`) via Maven — no Spring, distinct from [04-Backend-Development Lesson 05](../04-Backend-Development/05-Testing-a-REST-API/README.md), which covers Spring Boot's own test annotations. Lesson 05 is a single, self-contained `Example.java` file needing no build tool.

## Why It Matters / Where It's Used

- **Each layer of the testing pyramid catches a genuinely different category of bug** — this module doesn't just assert that; it demonstrates a real bug that unit testing caught, a real bug that only a real file system (integration testing) exposed, and a real bug that only the fully-wired, running app (end-to-end testing) revealed.
- **TDD's red-green cycle has real, checkable value** — this module captured actual `mvn test` output at three separate red→green transitions, rather than describing the cycle only in the abstract.
- **Interviews**: "what's the difference between a unit test and an integration test," "walk me through how you'd practice TDD," and "how do you approach debugging an unfamiliar bug" are extremely common interview questions, directly covered by this module's five lessons.

## Advantages of This Approach

- Every lesson captures **real, actual `mvn test` (or `javac`/`java`) output** at every stage — a real failing assertion with a wildly wrong value (Lesson 01), a real file I/O bug with a genuine Windows file-lock error (Lesson 02), a real `404` from a routing bug (Lesson 03), three genuine red→green TDD cycles (Lesson 04), and a real stack trace plus a real diagnosed silent logic bug (Lesson 05).
- Lessons 01-03 each demonstrate a bug that the *other* two testing layers specifically would NOT have caught, making the distinct value of each layer concrete rather than asserted.
- Lesson 04's TDD walkthrough shows the actual test failure message at each stage, proving each test was capable of genuinely failing before being trusted.

## Disadvantages / Trade-offs

- This module's examples are deliberately small and self-contained to fit the "verify by actually running it" discipline in a reasonable scope — real production test suites are far larger and involve considerably more infrastructure (test databases, CI pipelines, test data builders).
- Lesson 05's debugging techniques (stack trace reading, diagnostic logging) are foundational but don't cover interactive debugger usage (breakpoints, step-through, watch expressions) in an IDE, which is a valuable complementary skill beyond what a terminal-based lesson can practically demonstrate.

## How to Run the Examples

Lessons 01-04 are self-contained Maven projects using plain JUnit 5.

```bash
cd 15-Testing-and-Debugging/01-Unit-Testing
mvn test
```

Lesson 05 is a single, self-contained Java file — no build tool required.

```bash
cd 15-Testing-and-Debugging/05-Debugging-Techniques
javac Example.java
java Example
```

Requires only a JDK (this module was built and verified against JDK 25) and Apache Maven (verified against Maven 3.9.16, the same install used throughout this repository's Java-based modules). `target/`/`.class` files are not committed — recompile locally after cloning.

## Common Beginner Mistakes

- **Testing only the "happy path" and skipping edge cases** — verified live in Lesson 01 that edge-case tests (0%, 100%) revealed the true severity of a real bug.
- **Testing file/database/network interactions exclusively with mocks** — verified live in Lesson 02 that a real integration test caught a bug (an unflushed file write) a mock structurally could not.
- **Assuming a route handler's own logic being correct means it's correctly wired into the running app** — verified live in Lesson 03 that only an end-to-end test caught a real routing mistake.
- **Writing implementation before tests, or writing many requirements' worth of code before testing any of them** — Lesson 04 demonstrates the alternative: one small, verified red→green cycle at a time.
- **Guessing at a silent bug's cause instead of adding diagnostic instrumentation** — verified live in Lesson 05 that one well-placed log line immediately revealed a real root cause.

## Best Practices

- Maintain a healthy mix across the testing pyramid: many fast unit tests, fewer integration tests, and the fewest end-to-end tests — each catching a different, real category of bug.
- Always use try-with-resources (or equivalent) for any closeable resource, to avoid the data-loss/resource-leak bug demonstrated in Lesson 02.
- Write tests against real, external, documented interfaces (real HTTP requests, real files) wherever the bug being guarded against depends on real system behavior.
- Confirm a test can genuinely fail (and fails for the expected reason) before trusting it as a regression guard.
- Read stack traces top-down, starting with the message and the topmost frame in your own code.

## Interview Questions

1. What's the difference between a unit test, an integration test, and an end-to-end test, and what category of bug does each catch that the others don't?
2. Why might a test pass with a mocked dependency but fail against the real thing?
3. What does the "red" step of TDD actually verify, beyond just "the test fails"?
4. How do you read a stack trace to find the actual root cause of a crash?
5. How would you diagnose a silent (non-crashing) bug that produces a wrong result?

(Detailed, verified answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Unit Testing](01-Unit-Testing/README.md) | JUnit 5 basics; a real bug caught by a fast, isolated test |
| 02 | [Integration Testing](02-Integration-Testing/README.md) | A real bug (unflushed file write) only real I/O could catch |
| 03 | [End-to-End Testing](03-End-to-End-Testing/README.md) | A real routing bug only the fully-running app could reveal |
| 04 | [Test-Driven Development](04-Test-Driven-Development/README.md) | Three real red→green cycles building up a validator |
| 05 | [Debugging Techniques](05-Debugging-Techniques/README.md) | Reading a real stack trace; bisecting a real silent logic bug |

## Suggested Path

Work through 01 → 05 in order — Lessons 01-03 build up the testing pyramid layer by layer, each demonstrating a bug the previous layer's technique would have missed; Lesson 04 shows how tests are actually written in practice; Lesson 05 covers what to do once a bug is already loose. See also [04-Backend-Development Lesson 05](../04-Backend-Development/05-Testing-a-REST-API/README.md) for Spring Boot's own testing annotations, layered on top of the plain JUnit 5 foundation this module covers.

**Previous module:** [14-APIs-and-Integrations](../14-APIs-and-Integrations/README.md)
