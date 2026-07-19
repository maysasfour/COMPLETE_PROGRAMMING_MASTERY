# 12 — Functional Concepts

[Back to Bash course](../README.md)

## Honest Framing: Bash Is Not a Functional Language

Bash has no first-class function values in the way JavaScript or Ruby does — you cannot store a function in a variable and pass it around as a closure carrying captured state. What Bash *does* offer that rhymes with functional programming is (1) treating a function's captured stdout as a value via command substitution, and (2) pipelines as function composition.

## Functions "as Values" via Command Substitution — Verified Live

```bash
$ double() { echo $(( $1 * 2 )); }
$ vals=(1 2 3 4)
$ for v in "${vals[@]}"; do echo -n "$(double "$v") "; done; echo
2 4 6 8
```

This looks like `map(double, vals)` from a functional language, but under the hood each `$(double "$v")` spawns a **subshell** to run `double` and capture its stdout — there's no shared closure state, and it's meaningfully slower than a real in-process function call in a language with actual first-class functions.

## Piping as Composition — Verified Live

```bash
$ echo -e "banana\napple\ncherry" | sort | uniq | tr 'a-z' 'A-Z'
APPLE
BANANA
CHERRY
```

This genuinely is function composition in a real sense: `tr(uniq(sort(input)))`, expressed left-to-right instead of nested. Each stage is an independent process reading the previous stage's stdout as its own stdin, concurrently — this is arguably Bash's single most functional-feeling, and most powerful, idiom.

## What Doesn't Exist

- No closures capturing outer variables by reference in a function value.
- No `map`/`filter`/`reduce` built-ins operating on arrays in-process (some can be approximated with loops + command substitution, at a real performance cost from process-spawning).
- No anonymous/lambda function syntax at all — every function must be named (or, at best, defined inline via `f() { ...; }` right before use).

## Common Beginner Mistakes

- Expecting `$(function_name arg)` to be "free" the way a function call is in most languages — it forks a subshell, which is real, measurable overhead in a tight loop.
- Trying to build a generic `map` helper and being surprised it can only pass strings in and strings out (see Lesson 03).

## Best Practices

- Use pipelines (`cmd1 | cmd2 | cmd3`) as your primary compositional tool — it's genuinely idiomatic and performant (parallel processes, not sequential subshell forks).
- Reserve command-substitution-based "functional" patterns for small numbers of calls; for large loops, prefer a native `while read` loop over spawning a subshell per iteration.

## Interview Questions

1. In what sense is a Unix pipeline "function composition," and in what sense is it not exactly the same as composition in Haskell/Ruby?
2. Why is `$(some_function "$x")` inside a large loop potentially a performance problem?
3. What functional-programming features does Bash genuinely lack?
