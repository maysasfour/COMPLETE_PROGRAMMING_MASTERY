# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Write and run tests with Minitest — Ruby's built-in test framework, ships with the standard library, no gem install needed.
- Use `setup` for fresh per-test state, and `assert_equal`/`assert_raises`/`refute_equal`.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Concept

**Minitest** ships with Ruby itself (`require "minitest/autorun"` needs no gem install, same "genuinely built-in" theme as Lessons 10 and 17) and provides both an xUnit-style (`Minitest::Test`, used here) and a spec-style API. A test class subclasses `Minitest::Test`; every public method starting with `test_` is run as an individual test; `setup` runs fresh before *every* test method, giving each test isolated state rather than a shared, potentially-polluted object.

## Detailed Example

See [example_test.rb](example_test.rb) — a small `Calculator` class with `add`/`divide` (the latter raising `ZeroDivisionError` deliberately), and a `CalculatorTest` with a `setup` building a fresh `Calculator` per test, `assert_equal` for expected results, `assert_raises` confirming the divide-by-zero guard actually raises, and `refute_equal` for a non-equality check.

## Run It

```bash
cd 01-Languages/Ruby/18-Testing
ruby example_test.rb
```

## Expected Output (real, captured)

```
Run options: --seed 18187

# Running:

.....

Finished in 0.134811s, 37.0890 runs/s, 37.0890 assertions/s.

5 runs, 5 assertions, 0 failures, 0 errors, 0 skips
```

(The `--seed` value is randomized per run — Minitest deliberately randomizes test order by default to surface hidden inter-test dependencies — but the 5 runs/5 assertions/0 failures result is deterministic given this lesson's test logic.)

## Common Mistakes

- Sharing one `@calc` instance across all tests (built once, outside `setup`) — a test that mutates shared state can then silently affect a later, unrelated test; `setup` rebuilding a fresh instance before every single test avoids this entirely.
- Forgetting `require "minitest/autorun"` — without it, defined test classes exist but never actually run; `autorun` is what registers an at-exit hook to execute them.
- Writing a test method that doesn't start with `test_` (or isn't decorated as a spec-style `it` block) — Minitest simply won't discover and run it, silently.

## Best Practices

- Use `setup` for any state a majority of test methods need freshly built, rather than repeating construction in every individual test.
- Prefer `assert_raises(SpecificError) { ... }` over a broad `rescue`-and-check pattern — it fails loudly and clearly if the expected exception class doesn't match or nothing is raised at all.
- Keep one behavior asserted per test method where practical, so a failure's name alone (`test_divide_by_zero_raises`) already tells you what broke.

## Real-World Usage

Minitest is Rails' own default test framework (though many Rails projects opt into RSpec instead); its "no gem install needed" nature makes it the natural first choice for any standalone Ruby script or gem that wants tests without adding a dependency.

## Summary

- Minitest ships with Ruby's standard library — `require "minitest/autorun"`, zero gem installs.
- `setup` gives every test fresh, isolated state; `assert_equal`/`assert_raises`/`refute_equal` cover the common assertion needs.
- Test order is randomized by default (a real, intentional Minitest behavior) to surface hidden inter-test dependencies.

## Key Terms

- **`setup`** — a Minitest hook run before every individual test method in the class.
- **`assert_raises`** — asserts that a block raises a specific exception class, failing the test if it doesn't (or raises the wrong class).

## Interview Questions

1. **Does Minitest need a gem install like RSpec does?**
   No — Minitest ships as part of Ruby's own standard library; `require "minitest/autorun"` is all that's needed, with zero `gem install` step, verified directly by running this lesson's test file with a plain `ruby` invocation and no Gemfile/Bundler setup at all.

2. **Why does `setup` matter for test isolation?**
   `setup` runs fresh before *every* test method in the class, so each test gets its own independent object state rather than a single shared instance that earlier tests may have already mutated — this lesson's `CalculatorTest#setup` builds a brand-new `Calculator` before each of its five tests, so no test's assertions can be silently affected by another test having run first.

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
