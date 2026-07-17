# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

Eight standalone practice problems spanning the whole course, roughly ordered from easier to harder. Each is self-contained — you don't need to solve them in order, but earlier ones lean on earlier lessons only, while later ones combine several topics. These are deliberately distinct from the lesson-level `Exercises/` folders already in Lessons 05–09 and 14 (no repeats).

Attempt each problem yourself in a scratch `.js`/`.mjs` file before looking at [21-Solutions](../21-Solutions/README.md). Solutions are numbered to match (`solution-01.js` ↔ Exercise 01).

## Exercise 01 — FizzBuzz Variant (Beginner)

**Lessons used:** Control Flow, Operators

Write a function `fizzbuzz(n)` that returns an array of strings for the numbers `1` to `n` inclusive, where:
- multiples of 3 become `"Fizz"`
- multiples of 5 become `"Buzz"`
- multiples of both 3 and 5 become `"FizzBuzz"`
- everything else becomes the number itself, as a string

`fizzbuzz(15)` should end with `[..., "13", "14", "FizzBuzz"]`.

## Exercise 02 — Word Frequency Counter (Beginner/Intermediate)

**Lessons used:** Strings, Collections

Write a function `wordFrequencies(text)` that takes a string of text and returns a plain object mapping each lowercase word to how many times it appears, ignoring punctuation (`.`, `,`, `!`, `?`). Words should be compared case-insensitively (`"The"` and `"the"` are the same word).

`wordFrequencies("The cat sat. The cat ran!")` should return an object equivalent to `{ the: 2, cat: 2, sat: 1, ran: 1 }` (key order may vary, but every key/value pair must match).

## Exercise 03 — Validated Bank Account Class (Intermediate)

**Lessons used:** OOP, Error Handling

Write a class `BankAccount` with:
- `constructor(owner, balance = 0)`
- `deposit(amount)` — throws a `RangeError` if `amount <= 0`
- `withdraw(amount)` — throws a `RangeError` if `amount <= 0`, and a custom `InsufficientFundsError` (which you define, extending `Error`) if `amount > balance`
- a real `#balance` private field (Lesson 11), exposed read-only through a `balance` getter — there must be no way to set it directly from outside the class
- a `toString()` method returning something like `"BankAccount(owner=Ada, balance=150.00)"`

## Exercise 04 — Deduplicate While Preserving Order (Intermediate)

**Lessons used:** Collections, Functional Concepts

Write a function `dedupe(items)` that returns a new array with duplicates removed, preserving the **first** occurrence's position. Do this two ways: once with an explicit loop and a `Set` used only for O(1) "have I seen this?" checks, and once as a one-liner using `[...new Set(items)]` directly. Put both in your solution and confirm they produce identical results — and confirm for yourself whether JS `Set` actually preserves insertion order (don't assume; check it).

`dedupe([3, 1, 2, 3, 1, 4])` should return `[3, 1, 2, 4]`.

## Exercise 05 — Safe Division with Custom Error Chaining (Intermediate)

**Lessons used:** Error Handling, Functions

Write a function `safeDivide(a, b)` that returns `a / b`, but throws a custom `DivisionByZeroError` (extending `Error`) with a clear message if `b === 0`, instead of relying on JS's native floating-point division behavior — worth confirming directly what plain `5 / 0` actually evaluates to first, before adding your own check.

Then write `safeDivideStrings(aStr, bStr)` that parses both arguments as numbers (rejecting anything `Number()` can't convert, since `Number()` silently returns `NaN` rather than throwing), and — if parsing fails — throws a custom `InvalidDivisionInputError` using the ES2022 `Error` `cause` option (`new InvalidDivisionInputError("...", { cause: originalError })`) so the original parsing error is preserved as `.cause`.

Then write a small loop that attempts `safeDivideStrings` on a list of input pairs including at least one zero-division case and one bad-number-format case, catching both custom errors and printing both `.message` and (where present) `.cause.message`, without crashing the program.

## Exercise 06 — Stack Class (Advanced)

**Lessons used:** OOP, Generics

Plain JavaScript has no compile-time generics (Lesson 13) — so "generic" here means "works uniformly for any value type at runtime," documented with a `@template T` JSDoc comment for editor/reader hints only, not enforced by the language. Write a `Stack` class (your own, not built into JS) with:
- `push(item)`
- `pop()` — throws a custom `EmptyStackError` if the stack is empty
- `peek()` — same empty check, without removing the item
- `isEmpty()`
- a `size` getter

Back it with a real `#items` private field. Demonstrate it working with a stack of numbers and a stack of strings in your solution, and show that popping an empty stack throws your custom error.

## Exercise 07 — Async Task Runner with Retry and Backoff (Advanced)

**Lessons used:** Async and Concurrency, Functions, Error Handling

Write an async function `retry(fn, { retries = 3, delayMs = 50 } = {})` that:
- calls `fn()` (an async function that may reject)
- if it rejects, waits `delayMs * 2 ** attemptNumber` milliseconds (exponential backoff) and tries again, up to `retries` total attempts
- if every attempt fails, throws a custom `RetryExhaustedError` whose `.cause` is the last underlying error

Demonstrate it two ways: once against a "flaky" async function that fails twice then succeeds on the third call (confirm it actually returns the successful result), and once against a function that always fails (confirm `RetryExhaustedError` is thrown with the right `.cause`). Measure the elapsed time with `Date.now()` around the flaky case to confirm the backoff delays actually happened rather than just trusting the implementation.

## Exercise 08 — Mini Inventory System with `node:sqlite` (Advanced)

**Lessons used:** Database Access, Error Handling, Functions

Using the built-in `node:sqlite` module (Lesson 16) against an **in-memory** database (`new DatabaseSync(":memory:")`), write:
- a function `initDb(db)` that creates an `items` table with columns `id` (integer primary key autoincrement), `name` (text, not null), `quantity` (integer, not null, default 0)
- a function `addItem(db, name, quantity)` that inserts a row using a parameterized (`?`) query
- a function `updateQuantity(db, name, newQuantity)` that updates an existing item's quantity, throwing a custom `ItemNotFoundError` if no row with that name exists
- a function `listItems(db)` that returns all rows as an array of plain objects (`{ id, name, quantity }`)

Demonstrate the full flow: init the DB, add three items, update one, list everything, and attempt to update a nonexistent item to show the custom error firing.

## Suggested Next Lesson

[21 — Solutions](../21-Solutions/README.md) — but only after you've attempted each exercise yourself.
