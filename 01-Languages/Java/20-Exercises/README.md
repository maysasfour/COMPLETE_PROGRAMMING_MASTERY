# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

Seven standalone practice problems spanning the whole course, roughly ordered from easier to harder. Each is self-contained — you don't need to solve them in order, but earlier ones lean on earlier lessons only, while later ones combine several topics.

Attempt each problem yourself in a scratch `.java` file before looking at [21-Solutions](../21-Solutions/README.md). Solutions are numbered to match (`exercise-01.md` ↔ `Solution01.java`).

## Exercise 01 — FizzBuzz Variant (Beginner)

**Lessons used:** Control Flow, Operators

Write a static method `List<String> fizzbuzz(int n)` that returns a list of strings for the numbers `1` to `n` inclusive, where:
- multiples of 3 become `"Fizz"`
- multiples of 5 become `"Buzz"`
- multiples of both 3 and 5 become `"FizzBuzz"`
- everything else becomes the number itself, as a string

`fizzbuzz(15)` should end with `[..., "13", "14", "FizzBuzz"]`.

## Exercise 02 — Word Frequency Counter (Beginner/Intermediate)

**Lessons used:** Strings, Collections

Write a static method `Map<String, Integer> wordFrequencies(String text)` that takes a string of text and returns a map from each lowercase word to how many times it appears, ignoring punctuation (`.`, `,`, `!`, `?`). Words should be compared case-insensitively (`"The"` and `"the"` are the same word).

`wordFrequencies("The cat sat. The cat ran!")` should return a map equivalent to `{the=2, cat=2, sat=1, ran=1}` (order may vary, but every key/value pair must match).

## Exercise 03 — Validated Bank Account Class (Intermediate)

**Lessons used:** OOP, Error Handling

Write a class `BankAccount` with:
- a constructor `BankAccount(String owner, double balance)`
- `deposit(double amount)` — throws `IllegalArgumentException` if `amount <= 0`
- `withdraw(double amount)` — throws `IllegalArgumentException` if `amount <= 0`, and a custom checked exception `InsufficientFundsException` (which you define, extending `Exception`) if `amount > balance`
- a `getBalance()` accessor, with **no public setter** — the real value must live in a `private` field, mutable only through `deposit`/`withdraw`
- `toString()` returning something like `"BankAccount(owner=Ada, balance=150.00)"`

## Exercise 04 — Deduplicate While Preserving Order (Intermediate)

**Lessons used:** Collections, Functional Concepts

Write a static method `<T> List<T> dedupe(List<T> items)` that returns a new list with duplicates removed, preserving the **first** occurrence's position (a plain `HashSet` would not preserve order). Do this two ways: once with an explicit loop and a `HashSet` for O(1) "have I seen this?" checks, once using `LinkedHashSet` directly (which preserves insertion order natively) — put both in your solution and confirm they produce identical results.

`dedupe(List.of(3, 1, 2, 3, 1, 4))` should return `[3, 1, 2, 4]`.

## Exercise 05 — Safe Division with Custom Exceptions (Intermediate)

**Lessons used:** Error Handling, Functions

Write a static method `double safeDivide(double a, double b)` that returns `a / b`, but:
- throws a custom unchecked exception `DivisionByZeroCustomException` (extending `RuntimeException`) with a clear message if `b == 0`, instead of relying on Java's own floating-point division-by-zero behavior (which produces `Infinity`/`NaN` rather than throwing at all — worth confirming directly what plain `a / 0.0` actually does first, before adding your own check)
- demonstrate **exception chaining**: catch a lower-level exception in a different overload that parses two `String`s before dividing them (`safeDivide(String a, String b)`), and re-throw a custom `NumberFormatException`-wrapping exception using `throw new YourException("...", causeException)` so the original `NumberFormatException` is preserved as the cause

Then write a small loop that attempts `safeDivide` on a list of input pairs including at least one zero-division case and one bad-number-format case, catching and printing both custom exceptions (including their `getCause()`) without crashing the program.

## Exercise 06 — Generic Stack with Bounded Type (Advanced)

**Lessons used:** Generics, OOP

Write a generic `Stack<T>` class (your own, not `java.util.Stack`) that works for any single type `T`:
- `push(T item)`
- `T pop()` — throws a custom unchecked `EmptyStackException` (your own, not `java.util.EmptyStackException`) if the stack is empty
- `T peek()` — same empty-check, without removing the item
- `boolean isEmpty()`
- `int size()`

Demonstrate it working with a `Stack<Integer>` and a `Stack<String>` in your solution, and show that popping an empty stack throws your custom exception.

## Exercise 07 — Mini Inventory System with JDBC/SQLite (Advanced)

**Lessons used:** Database Access, Error Handling, Functions

Using JDBC (`java.sql`) and the same `sqlite-jdbc` driver from [16-Database-Access](../16-Database-Access/README.md), against an **in-memory** database (`jdbc:sqlite::memory:`), write:
- a static method `initDb(Connection conn)` that creates an `items` table with columns `id` (integer primary key autoincrement), `name` (text, not null), `quantity` (integer, not null, default 0)
- a static method `addItem(Connection conn, String name, int quantity)` that inserts a row using a `PreparedStatement`
- a static method `updateQuantity(Connection conn, String name, int newQuantity)` that updates an existing item's quantity, throwing a custom checked `ItemNotFoundException` if no row with that name exists
- a static method `List<Item> listItems(Connection conn)` (where `Item` is a small record/class with `id`/`name`/`quantity`) that returns all rows

Demonstrate the full flow: init the DB, add three items, update one, list everything, and attempt to update a nonexistent item to show the custom exception firing.

## Suggested Next Lesson

[21 — Solutions](../21-Solutions/README.md) — but only after you've attempted each exercise yourself.
