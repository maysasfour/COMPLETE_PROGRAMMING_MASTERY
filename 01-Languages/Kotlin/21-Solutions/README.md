# 21 — Solutions

[Back to course overview](../README.md) | [Exercises](../20-Exercises/README.md)

Runnable solutions for every problem in [20-Exercises](../20-Exercises/README.md). Each `solution-0N.kt` matches Exercise N. All seven were actually compiled with `kotlinc` (2.4.10) and run with `java` — the "Verified output" blocks below are pasted straight from the terminal, not predicted. Solution 06 additionally required `kotlinx-coroutines-core.jar` on the classpath (downloaded fresh for this session, not committed — see [22-Mini-Projects](../22-Mini-Projects/README.md) and Lesson 14's README for the same dependency).

## Solution 01 — Null-Safe Contact Lookup

```
--- bestContactMethod ---
Amara: amara@example.com
Ben: 555-0100
Cleo: no contact info
--- emailDomain ---
Amara: example.com
Ben: null
Cleo: null
```

`?:` chains left-to-right and only evaluates its right-hand side when the left side is `null`, so `contact.email ?: contact.phone ?: "no contact info"` naturally falls through both optional fields with no `if`/`else` at all. `?.let { }` only runs its lambda on a non-null receiver, so the whole `emailDomain` expression evaluates to `null` (not a thrown exception) whenever `email` itself is `null` — the domain-extraction logic inside never even has to think about nullability, because it structurally cannot run against a `null` receiver.

## Solution 02 — Data Class Equality and `copy()`

```
--- structural (==) vs referential (===) equality ---
price1 == price2 : true
price1 === price2 : false
--- copy() ---
discounted: Money(amount=1499, currencyCode=USD)
price1 (unchanged, proving copy() does not mutate the source): Money(amount=1999, currencyCode=USD)
--- auto-generated toString() ---
Money(amount=1999, currencyCode=USD)
```

`data class` auto-generates `equals()`/`hashCode()` from every constructor property, so `==` (which calls `.equals()`) compares content, while `===` still compares object identity — two genuinely separate heap objects with identical fields are `==` but not `===`, exactly the reverse of what a Java-trained `==` instinct expects (Lesson 04's central point, revisited here). `copy()` always builds a brand-new instance; `price1` after calling `.copy()` on it is untouched, proven by printing it again afterward.

## Solution 03 — Sealed Class Payment Processor

```
Credit card ending in 4242
Bank transfer from IBAN DE89370400440532013000
Cash on delivery
Store credit balance
```

The deliberate incomplete-`when` step was reproduced for real (not just described) before this file's final version was written — temporarily adding `object StoreCredit : PaymentMethod()` to the sealed hierarchy without a matching `is StoreCredit` branch in `describe()` produced this real, pasted compiler error:

```
solution-03.kt:26:5: error: 'when' expression must be exhaustive, add necessary 'is StoreCredit' branch or 'else' branch instead.
fun describe(method: PaymentMethod): String = when (method) {
    ^
```

This is the compiler catching a genuinely incomplete `when` at compile time — exactly what a `sealed class` + exhaustive `when` (no `else`) is for: adding a new subtype anywhere in the codebase forces every consuming `when` to be updated or the build fails outright, rather than silently falling through at runtime the way an unchecked `if`/`else if` chain would.

## Solution 04 — String and Collection Extension Functions

```
--- isPalindrome() ---
"racecar".isPalindrome() = true
"A man, a plan, a canal: Panama".isPalindrome() = true
"hello".isPalindrome() = false
--- secondOrNull() ---
listOf(1,2,3).secondOrNull() = 2
listOf(1).secondOrNull() = null
emptyList<Int>().secondOrNull() = null
--- static resolution proof ---
top-level extension outside the shadowed scope: true
locally shadowed extension inside the block: false
top-level extension again, after the block ends: true
```

The static-resolution proof is the interesting part: a local `fun String.isPalindrome(): Boolean = false` declared inside a `run { }` block shadows the top-level extension for every call lexically inside that block, regardless of the receiver's actual runtime value (`"level"` genuinely *is* a palindrome, but the shadowed version still returns `false`). This is only possible because Kotlin resolves extension functions **statically**, by the compile-time type of the call site — exactly Lesson 06's point that extension functions aren't real polymorphism, just syntax sugar over an ordinary static function call with the receiver as its first argument.

## Solution 05 — Declaration-Site Variance: a Read-Only Event Stream

```
--- invariant MutableEventBuffer<T> ---
MutableEventBuffer<String> is NOT assignable to MutableEventBuffer<Any> -- verified above via a real compile error (left commented out so this file still builds).
--- covariant EventBuffer<out T> ---
latest (as Any): logout, size=2
--- why 'in'-position T is illegal on an 'out T' interface (reasoned, not reproduced) ---
Adding it would let an EventBuffer<Any> view silently write a wrong-typed value into what's really an EventBuffer<String>'s backing list.
```

The invariant-assignment compile error was genuinely reproduced by temporarily uncommenting `val widened: MutableEventBuffer<Any> = stringEvents` — real output:

```
solution-05.kt:29:47: error: type mismatch: inferred type is MutableEventBuffer<String> but MutableEventBuffer<Any> was expected
val widened: MutableEventBuffer<Any> = stringEvents
                                        ^
```

`MutableEventBuffer<T>` (plain `<T>`, no variance modifier) is invariant, matching Lesson 13's `InvariantBox` finding exactly. `EventBuffer<out T>`, declared covariant once at its own definition, is what let `stringEvents.asReadOnly()` (statically typed `EventBuffer<String>`) be passed directly to `printLatestAnyEvent(buffer: EventBuffer<Any>)` — zero wildcard-equivalent syntax needed at that call site, the entire point of Kotlin's declaration-site variance over Java's use-site wildcards.

## Solution 06 — Concurrent Price Checks

```
--- concurrent (delay + async/await) ---
StoreA: $25.00
StoreB: $40.00
StoreC: $20.00
StoreD: $35.00
Cheapest: StoreC at $20.00
Elapsed (concurrent): 327ms (slowest single delay was 300ms)
--- sequential-by-blocking (Thread.sleep inside a coroutine, async/await used the same way) ---
Elapsed (Thread.sleep version): 849ms (sum of all four delays is 800ms)
```

The concurrent run (327ms) tracks the slowest individual `delay()` (300ms) plus a small scheduling overhead — not anywhere close to the sum of all four delays (150+300+100+250 = 800ms) — direct proof the four `async { }` coroutines genuinely ran concurrently. Swapping `delay()` for `Thread.sleep()` inside the identical `async`/`await` structure (same file, `checkPriceBlocking`) produced 849ms — almost exactly the *sum* of the four delays, because `runBlocking`'s default dispatcher runs coroutines on a single thread's event loop, and `Thread.sleep()` blocks that one real OS thread outright instead of yielding it back to the scheduler the way `delay()` does. This independently reproduces Lesson 19's "wrong tool inside a coroutine" finding on a fresh scenario, with fresh numbers, rather than trusting the earlier lesson's timings without rechecking.

## Solution 07 — Validated Signup with `Result`-Style Error Handling

```
--- all attempts ---
input=null -> FAILURE: username is null
input="" -> FAILURE: username is blank
input="ab" -> FAILURE: username 'ab' is shorter than 3 characters
input="amara" -> SUCCESS: amara
input="ben_the_builder" -> SUCCESS: ben_the_builder
--- successes only (filtered via the isSuccess() extension) ---
amara
ben_the_builder
```

`validateUsername` chains `input?.trim()?.takeIf { it.isNotEmpty() } ?: return ...` to collapse the null-or-blank cases into a single early return with no nested `if`. `SignupResult.isSuccess()` — an **extension function on a sealed class**, using an exhaustive `when` with no `else` branch — combines three of this course's central themes (null safety, sealed classes, extension functions) into one working pipeline, exactly as the exercise intended.

## Run It Yourself

```bash
cd 01-Languages/Kotlin/21-Solutions
kotlinc solution-01.kt -include-runtime -d solution-01.jar && java -jar solution-01.jar
# ...same pattern for solution-02 through solution-05 and solution-07

# solution-06 needs kotlinx-coroutines-core.jar on BOTH the compile and run classpath:
kotlinc -cp kotlinx-coroutines-core.jar solution-06.kt -include-runtime -d solution-06.jar
java -cp "solution-06.jar;kotlinx-coroutines-core.jar" Solution_06Kt
```

Note the generated main class name for `solution-06.kt` is `Solution_06Kt` (the compiler inserts an underscore before a leading digit that follows a hyphen-derived word boundary) — this only matters here because Solution 06 can't use `-include-runtime`'s convenient `java -jar` shortcut alongside a second external JAR; every other solution runs with the simpler `java -jar solution-0N.jar` form.

## Suggested Next Lesson

[22 — Mini Projects](../22-Mini-Projects/README.md)
