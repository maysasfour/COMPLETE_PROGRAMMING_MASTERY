# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

Seven standalone practice problems spanning the whole course, roughly ordered from easier to harder. These are deliberately different problems from the `Exercises/` folders already inside Lessons 05, 06, and 07 (FizzBuzz/leap-year via `case`/postfix-conditionals; a `measure` block helper and a Proc-vs-lambda `return` demonstration; word-frequency and inventory `group_by` problems) — solve those first if you haven't, then come back here for problems combining symbols/Hash validation, the spaceship operator with `Comparable`, `case`/`when` range dispatch, the three-way block/Proc/lambda split, `Enumerable` chaining, a custom exception hierarchy with `retry`, and a mixin-plus-duck-typing capstone.

Attempt each problem yourself in a scratch `.rb` file before checking [21-Solutions](../21-Solutions/README.md). Solutions are numbered to match (`Exercise 1` &harr; `solution-01.rb`).

## Exercise 1 — Symbol-Keyed Config Validator (Beginner)

**Lessons used:** Variables and Data Types (03)

Write a method `validate_config(config)` accepting a Hash with symbol keys `:host`, `:port`, `:timeout`. It should return an array of error strings (empty if valid): `:host` must be a non-empty String, `:port` must be an Integer between 1 and 65535, `:timeout` must be `nil` (meaning "use a default") or a positive Numeric. Test it against one fully valid config, one with a bad port (99999), and one with a missing `:host` key entirely (use `.fetch(:host, nil)` to detect the missing key without raising).

## Exercise 2 — Spaceship Operator for a `Version` Class (Beginner/Intermediate)

**Lessons used:** Operators (04)

Write a `Version` class wrapping three integers (`major`, `minor`, `patch`), implementing `<=>` to compare versions component-by-component (major first, then minor, then patch), and `include Comparable`. Prove `Version.new(1, 2, 0) < Version.new(1, 3, 0)`, `Version.new(2, 0, 0) > Version.new(1, 9, 9)`, and that `[Version.new(1,2,0), Version.new(1,0,0), Version.new(1,10,0)].sort` produces the correct semantic ordering (not lexical string ordering, where "1.10.0" would incorrectly sort before "1.2.0").

## Exercise 3 — Vending Machine via `case`/`when` (Intermediate)

**Lessons used:** Control Flow (05)

Write a method `vend(code, balance_cents)` that uses `case`/`when` to dispatch on a product `code` (`:soda` costs 150, `:chips` costs 200, `:candy` costs 100), returning `"Dispensed \#{code} -- change: \#{change}"` if `balance_cents` covers the cost (with `change` computed correctly) or `"Insufficient funds -- need \#{shortfall} more"` if not, and raising `ArgumentError` for any unrecognized code. Test all four cases (three known codes with sufficient funds, one with insufficient funds, one unrecognized code caught via `rescue`).

## Exercise 4 — Retry-With-Backoff Using a Block (Intermediate)

**Lessons used:** Functions (06), Error Handling (09)

Write a method `with_retries(max_attempts:)` that `yield`s to its block, catching `StandardError`; on failure it should `retry` (Lesson 09) up to `max_attempts` total attempts, sleeping `0.1 * attempt_number` seconds between attempts (a simple linear backoff), and re-raise the final exception if every attempt fails. Demonstrate it with a block that deliberately fails twice (using a counter) and succeeds on its third and final allowed attempt, printing which attempt succeeded.

## Exercise 5 — Top-N Word Frequencies via `Enumerable` Chaining (Intermediate)

**Lessons used:** Collections (07), Functional Concepts (12)

Write a method `top_n_words(text, n)` that lowercases the text, splits it into words (strip any trailing punctuation with `gsub(/[^a-z0-9]/, "")` per word), builds a frequency Hash, and returns the top `n` `[word, count]` pairs sorted by count descending (ties broken alphabetically) — implemented as ONE chained `Enumerable` pipeline (`each_with_object` → `sort_by` → `first`), not a hand-written loop with manual comparisons. Test it with a short paragraph of your choice, `n = 3`.

## Exercise 6 — Custom Exception Hierarchy with `retry` (Advanced)

**Lessons used:** Error Handling (09)

Define `class NetworkError < StandardError` and two subclasses, `class TimeoutError < NetworkError` and `class ConnectionRefusedError < NetworkError`. Write a method `fetch_data(attempt_sequence)` that takes an array of symbols (e.g. `[:timeout, :timeout, :ok]`) representing what happens on each successive call, raising the matching error class for `:timeout`/`:refused` or returning `"data!"` for `:ok`. Write a driver loop using `begin`/`rescue NetworkError => e`/`retry` (bounded to the array's length) that keeps retrying until it either gets `"data!"` or exhausts the sequence, printing which specific error class was caught on each failed attempt.

## Exercise 7 — Capstone: Shape Hierarchy with a Mixin and Duck Typing (Advanced)

**Lessons used:** OOP (11), Duck Typing (13), Operators (04)

Define a module `Measurable` with one method, `describe`, returning `"\#{self.class.name}: area=\#{area.round(2)}, perimeter=\#{perimeter.round(2)}"` (calling `area`/`perimeter`, which `Measurable` itself does NOT implement — it relies on the including class to provide them, real duck-typing-by-mixin). Define `Circle` (radius) and `Rectangle` (width, height) classes, both `include Measurable` and implementing their own `area`/`perimeter`. Write a method `total_area(shapes)` that sums `.area` across an array containing a mix of `Circle` and `Rectangle` instances — no shared type constraint anywhere, purely duck typing plus the shared mixin. Also demonstrate `respond_to?(:describe)` on a plain `Object.new` returning `false`, contrasted with a `Circle` instance returning `true`.

## Recommended Next Lesson

[21 — Solutions](../21-Solutions/README.md) — but only after you've attempted each exercise yourself.
