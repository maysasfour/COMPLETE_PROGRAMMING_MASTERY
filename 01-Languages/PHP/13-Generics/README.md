# 13 — Generics

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

## Learning Objectives

- Understand honestly: **PHP has no generics at all** — no `<T>` syntax, unlike every other language covered so far except plain JavaScript.
- See the three real workarounds: `mixed`/duck typing (no safety), PHPDoc `@template` annotations (static-analysis-only, not runtime-enforced), and interface-based constraints (the only runtime-enforced option).
- Understand a genuine, verified `self`-type gotcha: `self` in an interface method signature does not behave polymorphically the way it might seem to.

## Prerequisites

[12-Functional-Concepts](../12-Functional-Concepts/README.md)

## Concept

Unlike Java, C#, Go (1.18+), Rust, and TypeScript — all covered earlier in this repository, all with real generic type parameters — **PHP has no generics whatsoever**. There is no `<T>` syntax, no way to declare "a `Stack` of `int`s specifically" and have the language enforce it. This mirrors plain JavaScript's Lesson 13 in this repository more than any statically-typed language's.

## Without Generics: `mixed` Provides No Safety at All

```php
class Stack {
    private array $items = [];
    public function push(mixed $item): void { $this->items[] = $item; }
    public function pop(): mixed { return array_pop($this->items); }
}
$stack = new Stack();
$stack->push(1);
$stack->push("oops, a string in an int stack"); // no error -- mixed accepts anything
```

Verified live: pushing a string onto a "stack of ints" produces no error at all, at any point — `mixed` genuinely means "any type," with zero compile-time or runtime enforcement of a consistent element type.

## PHPDoc `@template`: Static-Analysis-Only, Not Runtime-Enforced

```php
/** @template T */
class TypedStack {
    /** @var T[] */
    private array $items = [];
    /** @param T $item */
    public function push(mixed $item): void { $this->items[] = $item; }
    /** @return T */
    public function pop(): mixed { return array_pop($this->items); }
}
```

Tools like PHPStan and Psalm understand `@template`/`@param T`/`@return T` annotations and **can** flag a type mismatch (e.g., pushing a string onto a `TypedStack<int>`) during static analysis — but this is purely a documentation convention the PHP language itself does not read or enforce. Running this exact code with plain `php` performs no such check whatsoever; only a separate static-analysis tool invoked as an extra build step provides any safety here.

## Interface-Based Constraints: The Only Runtime-Enforced Option

```php
interface Comparable {
    public function compareTo(Comparable $other): int;
}

class Money implements Comparable {
    public function compareTo(Comparable $other): int {
        if (!$other instanceof Money) {
            throw new InvalidArgumentException("can only compare Money to Money");
        }
        return $this->cents <=> $other->cents;
    }
}
```

## A Genuine, Verified Gotcha: `self` Doesn't Behave Polymorphically Across Interfaces

While writing this lesson, declaring `compareTo(self $other): int` in the `Comparable` interface, then implementing it as `compareTo(self $other): int` in `Money`, produced a real fatal error:

```
Fatal error: Declaration of Money::compareTo(Money $other): int must be compatible
with Comparable::compareTo(Comparable $other): int
```

Even though both signatures literally read `self $other`, PHP resolves `self` to the *scope it's declared in* — `Comparable` in the interface, `Money` in the class — and since PHP requires **invariant** parameter types (no narrowing/widening allowed when implementing an interface method), these two different resolved types are considered incompatible. The fix, shown above, is to type the parameter as the interface itself (`Comparable $other`), then use an explicit `instanceof` runtime check inside the method body to safely narrow to the concrete type — exactly the kind of manual, runtime-checked workaround that real generics (a `Comparable<T>` constraining `T` to the *same* concrete type at compile time, as Java's `Comparable<T>` does) would eliminate entirely.

## Detailed Example

See [example.php](example.php) — all three approaches, run and verified, including the fixed, working version of the `self`-type gotcha (documented as a comment rather than repeated as a live-breaking example).

## Run It

```bash
cd 01-Languages/PHP/13-Generics
php example.php
```

## Expected Output

Running `php example.php` shows the unsafe `mixed`-based stack accepting a string with no error, `42` from the `@template`-annotated (but still unenforced) `TypedStack`, and `max: 1200 cents` from the interface-based `Comparable` approach with its runtime `instanceof` guard.

## Common Mistakes

- Assuming a PHPDoc `@template T` annotation provides any runtime protection — it doesn't; only a separate static-analysis tool (PHPStan, Psalm) reads and enforces it, as a build/CI step entirely separate from running the PHP file itself.
- Assuming `self` in an interface method type-hints polymorphically the way it might seem to — it resolves per-scope and requires exact (invariant) matching, verified live to fail even when both signatures textually read `self`.
- Using `mixed` as a substitute for genuine type constraints without any runtime validation, silently allowing type-inconsistent collections.

## Best Practices

- Use PHPStan or Psalm with `@template` annotations in any codebase where generic-like type safety genuinely matters — accept that this is a build-time/CI check, not a PHP-runtime guarantee.
- Type interface method parameters with the interface itself (not `self`) when the parameter should accept any implementer, and use an explicit `instanceof` check inside the method body when concrete-type-specific behavior is needed.
- Document a class's intended "generic" type explicitly (via `@template`, naming conventions, or a README note) even without language-level enforcement, so callers understand the intended contract.

## Real-World Usage

Real PHP projects needing generics-like safety (especially large, static-analysis-driven codebases) rely heavily on PHPStan/Psalm's `@template` support in CI pipelines — this is standard practice in modern, professionally-maintained PHP codebases (Symfony, many Composer packages), precisely because the language itself provides no such guarantee.

## Summary

- PHP has no generics at all — no `<T>` syntax, unlike Java/C#/Go/Rust/TypeScript covered earlier in this repository.
- `mixed` provides zero type safety; PHPDoc `@template` provides static-analysis-only safety (PHPStan/Psalm), not runtime enforcement; interface-based constraints are the only genuinely runtime-enforced option, at the cost of needing manual `instanceof` checks for concrete-type-specific behavior.
- `self` in an interface method signature resolves per-scope, not polymorphically — verified live to require exact, invariant matching between an interface and its implementers.

## Key Terms

- **`@template`** — a PHPDoc annotation understood by static analyzers (PHPStan/Psalm) to express generic-like type parameters, with zero PHP-runtime effect on its own.
- **Invariant parameter typing** — PHP's requirement that an interface-implementing method's parameter types match exactly, with no narrowing or widening allowed.

## Interview Questions

1. **Does PHP have generics, and if not, what's the closest real alternative?**
   No — PHP has no generic type parameter syntax at all. The closest practical alternative for genuine type safety is combining an interface-based constraint (e.g., a `Comparable` interface) with a static analysis tool like PHPStan or Psalm reading `@template`/`@param T`/`@return T` PHPDoc annotations to catch type mismatches at analysis time, entirely outside the PHP runtime itself. Without such a tool in the build pipeline, a "generic-looking" class using `mixed` provides no type safety whatsoever — verified directly in this lesson by pushing a string onto a "stack of ints" with no error at any point.

2. **Why did declaring `compareTo(self $other)` identically in both an interface and its implementing class still fail with an incompatibility error?**
   `self` resolves to whatever class/interface scope it's textually declared in — `Comparable` inside the interface's own declaration, but `Money` inside `Money`'s implementation of that same method. PHP requires implementing methods to have exactly the same (invariant) parameter types as the interface declares, and since these two resolved `self` types differ, PHP considers the implementation's signature incompatible with the interface's — a genuine, verified gotcha, not a hypothetical one. The fix is to type the parameter using the interface name itself (`Comparable $other`) in both places, then use an `instanceof` check inside the method body if concrete-type-specific logic is needed.

## Recommended Next Lesson

[14 — Async and Concurrency](../14-Async-and-Concurrency/README.md)
