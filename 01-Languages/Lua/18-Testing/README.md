# 18 - Testing

## What / Why

Lua has **no de-facto-standard built-in test framework** — same honest gap this
repository's C course documents for C. Busted is the closest thing to a community
standard, but it's a LuaRocks install, not something that ships with `lua` itself. This
lesson builds a minimal, hand-rolled `pcall` + `assert`-based test harness (`testkit.lua`)
from scratch, needing nothing beyond the base language.

## The Harness

`testkit.lua` exposes `t.eq(actual, expected, label)`, `t.truthy(value, label)`,
`t.test(name, fn)` (wraps a test body in `pcall` so a raised error is recorded as a
failure rather than crashing the whole run), and `t.summary()` (prints pass/fail counts
and returns `true` only if everything passed).

## Run It

```bash
cd 01-Languages/Lua/18-Testing
lua example_test.lua; echo "exit code: $?"
```

Real captured output (two tests deliberately fail — one wrong-expectation assertion, one
raised error — to prove the harness genuinely detects and reports both failure modes,
not just happy-path successes):

```
4 passed, 2 failed
Failures:
  - intentionally wrong expectation: expected 5, got 4
  - a test that raises an error, to prove pcall catches it raised an error: example_test.lua:25: boom
exit code: 1
```

`os.exit(ok and 0 or 1)` at the end makes this harness CI-friendly — a non-zero exit
code on any failure, exactly like a "real" test runner, verified live above.

## Common Beginner Mistakes

- Letting an error inside a test body crash the entire test run instead of being recorded as a single failed test — `t.test()`'s internal `pcall` specifically guards against this, verified live with the deliberate `error("boom")` test above.
- Forgetting a non-zero exit code on failure — without `os.exit`, a CI pipeline calling `lua example_test.lua` would report success even when tests failed, since the script itself would still exit 0 by default.

## Best Practices

- Keep the harness itself tiny and dependency-free (as here) for small/embedded Lua projects; reach for Busted (via LuaRocks) once a project's test suite outgrows a single file's worth of hand-rolled assertions.
- Always propagate a non-zero process exit code on any test failure so CI can detect it.

## Interview Questions

1. **Does Lua ship a built-in test framework?** No — same gap as C's raw stdlib elsewhere in this repository. Busted is the community-standard third-party framework (via LuaRocks); this lesson instead hand-rolls a minimal `pcall`/`assert`-based harness needing zero external dependencies.
2. **How does this hand-rolled harness prevent one failing test from crashing the whole suite?** Each test body runs inside `pcall` (`t.test`) — a raised error is caught, recorded as that specific test's failure with its message, and the harness continues to the next test rather than the whole script terminating, verified live with a deliberately erroring test still followed by a clean summary.
