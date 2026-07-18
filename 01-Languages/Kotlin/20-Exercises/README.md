# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

Seven standalone practice problems spanning the whole course, roughly ordered from easier to harder. Each is self-contained — you don't need to solve them in order, but earlier ones lean on earlier lessons only, while later ones combine several topics. These are deliberately different problems from the `Exercises/` folders already inside Lessons 05, 06, and 07 — solve those first if you haven't, then come back here for problems that pull in null safety, data classes, sealed classes with exhaustive `when`, extension functions, declaration-site variance, and coroutines.

Attempt each problem yourself in a scratch `.kt` file before looking at [21-Solutions](../21-Solutions/README.md). Solutions are numbered to match (`exercise-01` &harr; `solution-01.kt`).

## Exercise 01 — Null-Safe Contact Lookup (Beginner)

**Lessons used:** Variables and Data Types / Null Safety (03)

Define a `data class Contact(val name: String, val email: String?, val phone: String?)` (either `email` or `phone` may legitimately be missing, but not necessarily both). Write:

- a function `fun bestContactMethod(contact: Contact): String` that returns the email if present, otherwise the phone if present, otherwise the string `"no contact info"` — using `?:` chaining, **not** an `if`/`else` chain and **not** `!!`.
- a function `fun emailDomain(contact: Contact): String?` that safely extracts the part of the email after `@` using `?.let { }`, returning `null` (not throwing) if there's no email at all.

Demonstrate all three cases: a contact with only an email, a contact with only a phone, and a contact with neither.

## Exercise 02 — Data Class Equality and `copy()` (Beginner)

**Lessons used:** OOP / Data Classes (11)

Define `data class Money(val amount: Long, val currencyCode: String)` (store amount as integer cents to avoid floating-point comparison issues). Show:

- two separately-constructed `Money` instances with identical fields compare `true` with `==` (structural equality, auto-generated) but `false` with `===` (referential).
- `.copy(amount = ...)` producing a new instance with only the `amount` changed, and that the original is provably untouched afterward.
- the auto-generated `toString()` printed directly (no manual override), confirming it lists every constructor property by name.

## Exercise 03 — Sealed Class Payment Processor (Intermediate)

**Lessons used:** Control Flow / Sealed Classes (05)

Model payment methods as a `sealed class PaymentMethod` with three subtypes: `data class CreditCard(val last4: String)`, `data class BankTransfer(val iban: String)`, and `object CashOnDelivery`. Write a function `fun describe(method: PaymentMethod): String` using an exhaustive `when` (no `else` branch) that returns a distinct description per subtype.

Then, as a **deliberate** compile-error demonstration: add a fourth subtype (e.g. `object StoreCredit`) to the sealed hierarchy *without* updating `describe()`, and paste the exact compiler error produced (`when` expression must be exhaustive...) into your solution's write-up before adding the missing branch and confirming it compiles clean again — the point being to see the compiler catch a genuinely incomplete `when` rather than only reading about it.

## Exercise 04 — String and Collection Extension Functions (Intermediate)

**Lessons used:** Functions / Extension Functions (06)

Write two extension functions with no existing standard-library equivalent used directly:

- `fun String.isPalindrome(): Boolean` — case-insensitive, ignoring non-alphanumeric characters (so `"A man, a plan, a canal: Panama"` returns `true`).
- `fun <T> List<T>.secondOrNull(): T?` — returns the second element, or `null` if the list has fewer than 2 elements (without throwing an `IndexOutOfBoundsException`).

Call both as if they were built-in members (`"racecar".isPalindrome()`, `listOf(1,2,3).secondOrNull()`), and demonstrate the extension function is resolved **statically** by shadowing it with a local variable of the same name as a receiver type inside a narrower scope, confirming which version actually runs (Lesson 06's own point about extension functions not being true polymorphism).

## Exercise 05 — Declaration-Site Variance: a Read-Only Event Stream (Advanced)

**Lessons used:** Generics / Variance (13)

Define an invariant `class MutableEventBuffer<T>(private val items: MutableList<T> = mutableListOf())` with `add(item: T)` and `fun asReadOnly(): EventBuffer<T>` returning an interface view. Separately define `interface EventBuffer<out T> { fun latest(): T?; val size: Int }` implemented by `MutableEventBuffer` (or a small wrapper class).

Demonstrate:
- `MutableEventBuffer<T>` itself is **not** assignable to a differently-typed variable (invariant, matching Lesson 13's `InvariantBox`).
- `EventBuffer<out T>`, once declared covariant, lets an `EventBuffer<String>` be passed directly to a function expecting `EventBuffer<Any>` — with **zero** wildcard-equivalent syntax at the call site.
- write a sentence in your solution's comments naming the specific compile error you'd get if you tried to also add a contravariant `fun add(item: T)` method directly onto the `out T`-declared interface (you don't need to reproduce this one live — reason about *why* it's illegal from Lesson 13's `out`-means-"produce-only" rule).

## Exercise 06 — Concurrent Price Checks (Advanced)

**Lessons used:** Async and Concurrency / Coroutines (14)

Write a `suspend fun checkPrice(store: String, delayMs: Long): Pair<String, Double>` that simulates a slow price lookup with `delay(delayMs)` before returning a hardcoded `(store, price)` pair. Using `coroutineScope` and at least 4 concurrent `async { }` calls with different delays (e.g. 150ms, 300ms, 100ms, 250ms):

- measure and print total elapsed wall-clock time using `System.currentTimeMillis()`, proving it's close to the *slowest single* delay, not the sum of all four (the same concurrency proof Lesson 14 makes, applied to a new scenario).
- print the store with the lowest price once all four `await()` calls have completed, using `minByOrNull`.
- as a deliberate before/after comparison, also measure and print how long the identical four calls take if you replace every `delay(delayMs)` with `Thread.sleep(delayMs)` inside the `suspend fun` — reproducing Lesson 19's "wrong tool inside a coroutine" finding on a fresh example rather than trusting the earlier lesson's numbers alone.

## Exercise 07 — Validated Signup with `Result`-Style Error Handling (Advanced)

**Lessons used:** Null Safety (03), Sealed Classes (05), Data Classes (11), Extension Functions (06)

Combine everything above into one small pipeline. Define:
- `sealed class SignupResult { data class Success(val username: String) : SignupResult(); data class Failure(val reason: String) : SignupResult() }`
- `fun validateUsername(input: String?): SignupResult` that fails (with a specific reason string per case) for `null`, blank, or shorter-than-3-characters input, and otherwise succeeds — using `?.let { }`/`?:` for the null/blank checks, not manual `if (input == null)` boilerplate wherever avoidable.
- an extension function `fun SignupResult.isSuccess(): Boolean` implemented with an exhaustive `when` (no `else`), used to filter a `List<SignupResult>` built from at least 5 varied inputs (including `null`, `""`, `"ab"`, and two valid usernames) down to just the successes, printing each alongside its outcome.

## Suggested Next Lesson

[21 — Solutions](../21-Solutions/README.md) — but only after you've attempted each exercise yourself.
