# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

Seven standalone practice problems spanning the whole course, roughly ordered from easier to harder. Each is self-contained — you don't need to solve them in order, but earlier ones lean on earlier lessons only, while later ones combine several topics.

Attempt each problem yourself in a scratch `.py` file before looking at [21-Solutions](../21-Solutions/README.md). Solutions are numbered to match (`exercise-01.md` ↔ `solution-01.py`).

## Exercise 01 — FizzBuzz Variant (Beginner)

**Lessons used:** Control Flow, Operators

Write a function `fizzbuzz(n)` that returns a list of strings for the numbers `1` to `n` inclusive, where:
- multiples of 3 become `"Fizz"`
- multiples of 5 become `"Buzz"`
- multiples of both 3 and 5 become `"FizzBuzz"`
- everything else becomes the number itself, as a string

`fizzbuzz(15)` should end with `[..., "13", "14", "FizzBuzz"]`.

## Exercise 02 — Word Frequency Counter (Beginner/Intermediate)

**Lessons used:** Strings, Collections

Write a function `word_frequencies(text)` that takes a string of text and returns a dictionary mapping each lowercase word to how many times it appears, ignoring punctuation (`.`, `,`, `!`, `?`). Words should be compared case-insensitively (`"The"` and `"the"` are the same word).

`word_frequencies("The cat sat. The cat ran!")` should return `{"the": 2, "cat": 2, "sat": 1, "ran": 1}` (order may vary, but every key/value pair must match).

## Exercise 03 — Validated Bank Account Class (Intermediate)

**Lessons used:** OOP, Error Handling

Write a class `BankAccount` with:
- `__init__(self, owner: str, balance: float = 0.0)`
- `deposit(self, amount)` — raises `ValueError` if `amount <= 0`
- `withdraw(self, amount)` — raises `ValueError` if `amount <= 0`, and a custom exception `InsufficientFundsError` (which you define, subclassing `Exception`) if `amount > self.balance`
- a `balance` property that's read-only from outside the class (i.e., store the real value in a "private" `_balance` attribute and expose it via `@property`)
- `__str__` returning something like `"BankAccount(owner=Ada, balance=150.00)"`

## Exercise 04 — Deduplicate While Preserving Order (Intermediate)

**Lessons used:** Collections, Functional Concepts

Write a function `dedupe(items)` that returns a new list with duplicates removed, preserving the **first** occurrence's position (a plain `set(items)` would not preserve order). Do this two ways: once with an explicit loop, once as a one-liner using a dict (dicts preserve insertion order in modern Python) — put both in your solution and confirm they produce identical results.

`dedupe([3, 1, 2, 3, 1, 4])` should return `[3, 1, 2, 4]`.

## Exercise 05 — Safe Division CLI with Custom Exceptions (Intermediate)

**Lessons used:** Error Handling, Functions

Write a function `safe_divide(a, b)` that returns `a / b`, but:
- raises a custom `DivisionByZeroCustomError` (subclassing `Exception`) with a clear message if `b == 0`, instead of letting the built-in `ZeroDivisionError` propagate directly
- catches invalid types (e.g., dividing a string by a number) and re-raises as a `TypeError` with a clearer message using `raise ... from err` (exception chaining)

Then write a small loop that attempts `safe_divide` on a list of `(a, b)` pairs including at least one zero-division case and one type-error case, catching and printing both custom exceptions without crashing the program.

## Exercise 06 — Generic Stack with Type Hints (Advanced)

**Lessons used:** Generics, OOP

Using `TypeVar` and `Generic`, write a generic `Stack` class that works for any single type `T`:
- `push(self, item: T) -> None`
- `pop(self) -> T` — raises a custom `EmptyStackError` if the stack is empty
- `peek(self) -> T` — same empty-check, without removing the item
- `is_empty(self) -> bool`
- `__len__(self) -> int`

Demonstrate it working with a `Stack[int]` and a `Stack[str]` in your solution, and show that popping an empty stack raises your custom exception.

## Exercise 07 — Mini Inventory System with SQLite (Advanced)

**Lessons used:** Database Access, Error Handling, Functions

Using the stdlib `sqlite3` module and an in-memory database (`sqlite3.connect(":memory:")`), write:
- a function `init_db(conn)` that creates an `items` table with columns `id` (integer primary key), `name` (text, not null), `quantity` (integer, not null, default 0)
- a function `add_item(conn, name, quantity)` that inserts a row using a parameterized query
- a function `update_quantity(conn, name, new_quantity)` that updates an existing item's quantity, raising a custom `ItemNotFoundError` if no row with that name exists
- a function `list_items(conn)` that returns all rows as a list of dicts (`{"id": ..., "name": ..., "quantity": ...}`)

Demonstrate the full flow: init the DB, add three items, update one, list everything, and attempt to update a nonexistent item to show the custom exception firing.

## Suggested Next Lesson

[21 — Solutions](../21-Solutions/README.md) — but only after you've attempted each exercise yourself.
