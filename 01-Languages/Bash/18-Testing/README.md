# 18 — Testing

[Back to Bash course](../README.md)

## Honest Framing

Bash has no de-facto built-in test framework the way many languages ship one (or have one universally adopted). `bats` (Bash Automated Testing System) is a genuine, widely used external framework, but it is a separate install, not part of Bash itself. This lesson follows the same approach this repository's C course takes for a similarly framework-less language: a small, hand-rolled, assert-based harness — genuinely runnable with nothing but Bash itself.

## The Harness — Verified Live

```bash
$ cat assert.sh
#!/usr/bin/env bash
pass=0; fail=0
assert_eq() {
  local desc="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    echo "PASS: $desc"; pass=$((pass+1))
  else
    echo "FAIL: $desc (expected '$expected', got '$actual')"; fail=$((fail+1))
  fi
}
report() { echo "Results: $pass passed, $fail failed"; [ "$fail" -eq 0 ]; }
```

`assert_eq` compares an expected and actual string, tallying pass/fail counts in global variables; `report` prints the summary and returns exit code 0 only if nothing failed (so the harness composes correctly with `set -e` or CI pass/fail logic).

## Using It Against Real Code — Verified Live

```bash
$ cat mathlib_test.sh
#!/usr/bin/env bash
source ./assert.sh
source ./mathlib.sh
assert_eq "square of 6" "36" "$(square 6)"
assert_eq "square of 0" "0" "$(square 0)"
assert_eq "square of -3 (deliberately wrong expectation)" "10" "$(square -3)"
report

$ bash mathlib_test.sh
PASS: square of 6
PASS: square of 0
FAIL: square of -3 (deliberately wrong expectation) (expected '10', got '9')
Results: 2 passed, 1 failed
$ echo "harness exit: $?"
harness exit: 1
```

The third assertion was deliberately given a wrong expected value to prove the harness actually detects failures (rather than always reporting success) — `square(-3)` genuinely computes 9, and the harness correctly flagged the mismatch and returned a nonzero exit code, which is exactly the signal a CI pipeline needs to fail the build.

## `bats`, Documented (not installed in this environment)

```bash
$ where bats
INFO: Could not find files for the given pattern(s).
```

If installed (`npm install -g bats` or via a package manager), a `bats` test file looks like:

```bash
#!/usr/bin/env bats
load 'mathlib.sh'

@test "square of 6 is 36" {
  result="$(square 6)"
  [ "$result" -eq 36 ]
}
```

`bats` adds TAP-format output, setup/teardown hooks, and richer assertion helpers over the hand-rolled approach above — genuinely worth adopting on any project large enough to justify the extra dependency, but not required for the hand-rolled harness to be legitimate and useful.

## Common Beginner Mistakes

- Writing tests that always pass because `assert_eq` was never actually tried against a genuinely wrong value (as shown above, a deliberately wrong assertion is worth keeping at least once to prove the harness works).
- Forgetting `report`'s own exit code — without checking it, a CI script might report "tests ran" without noticing some of them failed.
- Not isolating test state (e.g., temp files, `TASK_DATA_FILE` overrides in Lesson 22's tests) between test runs, causing one test's leftover state to corrupt another's.

## Best Practices

- Prefer `assert_eq`-style helpers over ad hoc `if`/`echo` in every test file, for consistent, readable pass/fail output.
- Have `report` (or equivalent) return a real nonzero exit code on any failure, so test runs integrate cleanly with `set -e` and CI systems.
- Isolate any file-system state a test touches (e.g., point `TASK_DATA_FILE` at a `mktemp` path, and `trap` it for cleanup).

## Interview Questions

1. Why does the testing harness deliberately include one assertion that is expected to fail?
2. What does `report`'s exit code communicate, and why does that matter for CI?
3. What would `bats` give you that the hand-rolled harness doesn't?
