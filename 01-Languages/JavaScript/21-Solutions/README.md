# 21 — Solutions

[Back to course overview](../README.md) | [Exercises](../20-Exercises/README.md)

Runnable solutions for every problem in [20-Exercises](../20-Exercises/README.md). Each `solution-0N.js` matches Exercise N. All eight have been executed with `node` and verified — the output blocks below are real, copied directly from the terminal, not predicted.

## Solution 01 — FizzBuzz Variant

```
[
  '1',        '2',
  'Fizz',     '4',
  'Buzz',     'Fizz',
  '7',        '8',
  'Fizz',     'Buzz',
  '11',       'Fizz',
  '13',       '14',
  'FizzBuzz'
]
```

Node's `console.log` reformats a 15-element array of short strings into this multi-column grid automatically — that's Node's own inspector layout, not something the code controls. Checking `i % 15 === 0` before `% 3`/`% 5` individually matters: with `else if`, the first matching branch wins, so multiples of 15 must be caught before they can fall into the `"Fizz"` branch.

## Solution 02 — Word Frequency Counter

```
{ the: 2, cat: 2, sat: 1, ran: 1 }
```

A single `/[.,!?]/g` regex strips exactly the punctuation the exercise cares about in one pass, and lowercasing before splitting makes the count case-insensitive. `counts[word] = (counts[word] ?? 0) + 1` uses `??` rather than `||` — moot here since counts only grow from 1, but it's the habit that matters once a legitimately-falsy `0` could be a real count.

## Solution 03 — Validated Bank Account Class

```
BankAccount(owner=Ada, balance=150.00)
Deposit of -5 rejected: Deposit amount must be positive
Withdrawal blocked: Cannot withdraw 500 - balance is only 150
BankAccount(owner=Ada, balance=100.00)
After attempted external overwrite, balance getter still reports: 100
```

A genuine, verified-live behavior worth calling out: `account.balance = 999999` at the end does **not** throw — a getter-only accessor property assignment silently no-ops in **non-strict mode** (this file has no `"use strict"` pragma and CommonJS scripts aren't strict by default, unlike ES modules and unlike code inside a `class` body, which is always strict). The assignment simply does nothing; the real `#balance` private field was never reachable from outside the class in the first place, so the getter still reports the correct value afterward. Running the same line inside a `"use strict"` file, or inside an ES module (`.mjs`), would throw a `TypeError` instead — both are "correct," just different failure modes depending on module system.

## Solution 04 — Deduplicate While Preserving Order

```
Loop version:    [ 3, 1, 2, 4 ]
One-liner (Set): [ 3, 1, 2, 4 ]
Both match: true
```

JS's `Set` **does** preserve insertion order (confirmed live, not assumed) — unlike a hash-based set in some other languages, iterating a `Set` always yields elements in the order they were first added, which is exactly what makes `[...new Set(items)]` a correct one-line dedupe rather than something that happens to look right by coincidence.

## Solution 05 — Safe Division with Custom Error Chaining

```
Native 5 / 0 evaluates to: Infinity
10 / 2 = 5
Caught InvalidDivisionInputError: Cannot divide '5' and '0'
  caused by: DivisionByZeroError: Cannot divide 5 by zero
Caught InvalidDivisionInputError: Cannot divide 'ten' and '2'
  caused by: TypeError: "ten" is not a valid number
8 / 4 = 2
```

Confirmed directly: native `5 / 0` is `Infinity`, not a thrown error (JS floating-point division mirrors IEEE 754, unlike Python which raises `ZeroDivisionError` and unlike Java's own integer division, which does throw) — this is exactly why `safeDivide` needs its own explicit `b === 0` check rather than relying on the language. `new InvalidDivisionInputError(message, { cause: err })` (the ES2022 `Error` cause option) preserves the original `DivisionByZeroError`/`TypeError` on `.cause`, so catching code gets both a clear top-level message and the original diagnostic detail.

## Solution 06 — Stack Class

```
number stack after pushes: size 3
Popped: 3
Peeked (unchanged): 2
number stack after pop: size 2
string stack: [b, ...] size 2
Popped from empty stack threw: EmptyStackError: Stack is empty
```

The same `Stack` class handles both a stack of numbers and a stack of strings with zero changes — nothing at runtime actually restricts what `push` accepts. The `@template T` JSDoc comment is documentation for editors/readers only (VS Code will use it for hover hints), not a language-enforced constraint the way TypeScript's `Stack<T>` would be; this is Lesson 13's "no generics" point made concrete.

## Solution 07 — Async Task Runner with Retry and Backoff

```
Flaky call result: success on call 3
Elapsed: 175ms (expected >= 150ms of backoff delay)
Backoff actually happened: true
Caught RetryExhaustedError: All 3 attempts failed: permanent failure
  caused by: permanent failure
```

The elapsed time (175ms, comfortably over the 150ms theoretical minimum of `50 + 100`) confirms the exponential backoff genuinely happened rather than the retries firing back-to-back — `setTimeout` delays are a lower bound, not exact, so the real number always runs a little over the computed minimum, which is expected and fine. `RetryExhaustedError`'s `.cause` correctly carries the *last* underlying error, not the first, since each retry overwrites `lastError`.

## Solution 08 — Mini Inventory System with `node:sqlite`

```
Items after adding three:
  [Object: null prototype] { id: 1, name: 'Widget', quantity: 10 }
  [Object: null prototype] { id: 2, name: 'Gadget', quantity: 5 }
  [Object: null prototype] { id: 3, name: 'Gizmo', quantity: 0 }
Updated Gadget quantity to 20
Items after update:
  [Object: null prototype] { id: 1, name: 'Widget', quantity: 10 }
  [Object: null prototype] { id: 2, name: 'Gadget', quantity: 20 }
  [Object: null prototype] { id: 3, name: 'Gizmo', quantity: 0 }
Expected error caught: ItemNotFoundError: No item named 'Sprocket' exists
(node:33320) ExperimentalWarning: SQLite is an experimental feature and might change at any time
(Use `node --trace-warnings ...` to show where the warning was created)
```

Two things confirmed live, not assumed from docs: rows returned by `node:sqlite`'s `.all()` are genuinely `[Object: null prototype]` objects (they don't inherit from `Object.prototype`) — this doesn't break `{ id, name, quantity }`-style access or `JSON.stringify`, but it does mean `row.toString`/`row.hasOwnProperty` are `undefined` rather than inherited methods, a real (if minor) surprise if you expect a plain object literal. Second, `node:sqlite` still emits its `ExperimentalWarning` to stderr on every run in this Node 24 environment, exactly as Lesson 16 warns — it's expected, not a bug in this solution. `result.changes === 0` after the `UPDATE` (the `node:sqlite` equivalent of `sqlite3.Cursor.rowcount` / JDBC's `executeUpdate()` return value) is what detects the nonexistent-item case without a separate `SELECT`.

## Suggested Next Lesson

[22 — Mini Projects](../22-Mini-Projects/README.md)
