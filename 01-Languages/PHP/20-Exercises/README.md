# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

Seven standalone practice problems spanning the whole course, roughly ordered from easier to harder. Each is self-contained — you don't need to solve them in order, but earlier ones lean on earlier lessons only, while later ones combine several topics. These are deliberately different problems from the `Exercises/` folders already inside Lessons 05, 06, and 07 (which cover a `match`-based FizzBuzz, named/variadic/by-reference function parameters, and array filtering respectively) — solve those first if you haven't, then come back here for problems that specifically pull in `match(true)` range-style dispatch, traits (including a real `insteadof`/`as` conflict), backed enums implementing an interface, closures capturing `use (&$var)` by reference vs. by value, the split `Error`/`Exception`/`Throwable` hierarchy, and named arguments.

Attempt each problem yourself in a scratch `.php` file before looking at [21-Solutions](../21-Solutions/README.md). Solutions are numbered to match (`Exercise 01` &harr; `solution-01.php`).

## Exercise 01 — Match-Based Grade Calculator (Beginner)

**Lessons used:** Control Flow (05)

Write a function `letterGrade(int $score): string` that converts a 0–100 integer score into a letter grade (`A` for 90+, `B` for 80–89, `C` for 70–79, `D` for 60–69, `F` below 60), using the `match(true)` idiom — `match` compares its subject with `===`, so passing the literal `true` and writing each arm as a boolean condition (`$score >= 90 => 'A'`) is how `match` expresses a *range* check, since `match` itself has no native range/comparison-operator syntax the way some other languages' pattern matching does.

- Throw a `\ValueError` (PHP's built-in exception for a semantically-invalid-but-correctly-typed argument) if `$score` is outside `0`–`100`.
- Test boundary scores `100`, `90`, `89`, `60`, `59`, and `0`, plus one out-of-range call (`105`) caught with `try`/`catch` to prove the guard actually fires.
- Note in a comment why a plain `switch ($score)` could not express this directly (it compares for exact equality per `case`, not a range), and why `match` without `(true)` (i.e. `match ($score)`) couldn't either.

## Exercise 02 — Traits and a Real Conflict Resolution (Beginner/Intermediate)

**Lessons used:** OOP (11)

Define two traits: `Greetable` with a method `describe(): string` returning `"Hi, I'm a {class}."`, and `Auditable` with its *own*, differently-implemented method also named `describe(): string` returning `"{class} last audited: {timestamp}"`. Both traits are otherwise useful and unrelated to each other (no shared interface), but they collide on the method name.

- Create a class `Volunteer` that `use`s both traits and resolves the collision explicitly with `insteadof` (choosing `Auditable::describe` as the winner) and `as` (aliasing the other trait's version to `greetOnly()` so it's still reachable).
- Separately, create a class `Robot` that uses only `Greetable` (no conflict at all), proving traits mix into *unrelated* classes with no inheritance relationship between `Volunteer` and `Robot`.
- Print `Volunteer`'s resolved `describe()`, its aliased `greetOnly()`, and `Robot`'s `describe()`, showing all three come from trait code, not from any class hierarchy.

## Exercise 03 — Backed Enum Implementing an Interface (Intermediate)

**Lessons used:** OOP (11), Control Flow (05)

Define `enum Priority: int implements \JsonSerializable` with cases `Low = 1`, `Medium = 2`, `High = 3`, plus:

- a method `label(): string` implemented with a `match ($this) { ... }` expression (matching directly on the enum instance, not `$this->value`) returning `"Low"`/`"Medium"`/`"High"`
- `jsonSerialize(): mixed` returning `['value' => $this->value, 'label' => $this->label()]`, satisfying the `JsonSerializable` interface so `json_encode()` calls it automatically

Demonstrate: `Priority::from(2)` (succeeds), `Priority::tryFrom(99)` (returns `null`, doesn't throw — contrast this with `from()`, which throws `\ValueError` for the same bad input, caught in a `try`/`catch`), iterating `Priority::cases()` printing each case's `label()`, and `json_encode()` of an array of two `Priority` cases to confirm `JsonSerializable` is actually being invoked (not just relying on default enum serialization, which would fail — backed enums are not natively JSON-serializable without this interface).

## Exercise 04 — Closures: `use (&$var)` vs. `use ($var)` (Intermediate)

**Lessons used:** Functional Concepts (12)

Write a factory function `makeCounter(): array` returning a two-element array `[$increment, $reset]` of closures that **share** one running total via `use (&$count)` (by reference) — calling `$increment()` several times and then `$reset()` must affect the same underlying counter both closures see.

- Contrast this with a second factory `makeSnapshot(int $start): array` returning closures built with plain `use ($start)` (by value) — each closure captured its own independent copy at creation time, so mutating one has zero effect on another built from the same factory call.
- Prove the difference by actually calling both factories, printing intermediate values, and showing the by-reference pair's shared state diverges from two independent by-value closures built from separate `makeSnapshot()` calls.
- Use `array_walk()` with a `use (&$total)` callback to sum an array as a second, real-world-shaped example of by-reference capture (not just the counter toy example).

## Exercise 05 — The Split `Error` / `Exception` / `Throwable` Hierarchy (Intermediate/Advanced)

**Lessons used:** Error Handling (09)

PHP's throwable hierarchy is genuinely split: `Error` (programming mistakes — type errors, missing arguments) and `Exception` (expected runtime failure conditions) are two *separate* class trees that both implement the `\Throwable` interface, with no inheritance relationship between `Error` and `Exception` themselves.

- Define a custom `class ValidationException extends \Exception` for an expected, recoverable failure (an invalid age).
- Write a function `requireAdult(int $age, string $name): string` that throws `ValidationException` if `$age < 18`.
- Separately, deliberately call a strictly-typed function with the *wrong number of arguments* (fewer than its required parameters) inside a `try` block, to trigger PHP's own built-in `\ArgumentCountError` (which extends `\Error`, not `\Exception`).
- Write **one** `catch (\Throwable $t)` block handling both call sites, and inside it use `$t instanceof \Error` vs. `$t instanceof \Exception` to print which branch of the hierarchy actually fired for each — proving live that both are genuinely catchable through the same `\Throwable` supertype despite being unrelated to each other.

## Exercise 06 — Named Arguments (Intermediate)

**Lessons used:** Functions (06)

Define `function buildInvitation(string $name, string $event, string $time = "18:00", bool $plusOne = false, ?string $note = null): string` returning a formatted invitation string using all five parameters.

- Call it once using only positional arguments in order.
- Call it again using named arguments that **skip** `$time` and `$plusOne` (accepting their defaults) while still supplying `$note` — something impossible with positional-only calls, since skipping an earlier optional parameter to reach a later one requires either named arguments or repeating the skipped parameter's default value explicitly.
- Call it a third time mixing positional (`$name`, `$event`) with named (`plusOne: true`) arguments.
- Finally, deliberately omit the required `$name` argument entirely (calling with only named arguments for the optional parameters) inside a `try`/`catch (\ArgumentCountError $e)` block — named arguments change *how* you supply arguments, not *whether* required parameters are still required, and this proves it live.

## Exercise 07 — Capstone: Library Checkout State Machine (Advanced)

**Lessons used:** OOP (11), Control Flow (05), Error Handling (09), Functions (06)

Combine this exercise set's themes into one small system:

- `enum BookStatus: string { case Available = 'available'; case CheckedOut = 'checked_out'; case Lost = 'lost'; }`
- A trait `HasId` providing a private static per-class counter and a `nextId(): int` method, mixed into both a `Book` class and an unrelated `Member` class so each gets independent auto-incrementing ids with zero shared inheritance.
- A custom `class InvalidTransitionException extends \Exception`.
- A function `checkout(Book $book, Member $member, ?\DateTimeImmutable $dueDate = null): void` (called with named arguments at least once) that uses a `match` expression on `$book->status` to enforce that only an `Available` book can transition to `CheckedOut` — any other current status throws `InvalidTransitionException` with a message naming the book's current status.
- A mirrored `returnBook(Book $book): void` enforcing the reverse transition (`CheckedOut` &rarr; `Available` only).

Demonstrate one full successful checkout-then-return cycle (printing the book's status after each step) and one deliberate invalid transition (attempting to check out a book that's already `CheckedOut`) caught and printed via `try`/`catch`.

## Suggested Next Lesson

[21 — Solutions](../21-Solutions/README.md) — but only after you've attempted each exercise yourself.
