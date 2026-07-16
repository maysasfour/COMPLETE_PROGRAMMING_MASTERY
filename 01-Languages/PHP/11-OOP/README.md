# 11 — OOP

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Use classes, interfaces, abstract classes, and constructor property promotion.
- Use traits for horizontal code reuse — PHP's answer to the lack of multiple inheritance.
- Use PHP 8.1+ backed enums, which can have methods and implement interfaces, unlike a plain class-of-constants workaround.

## Prerequisites

[10-File-Handling](../10-File-Handling/README.md)

## Concept

PHP's OOP is single-inheritance (like Java, C#, Go's lack of inheritance entirely, and unlike C++'s multiple inheritance) with interfaces for multiple type conformance, plus two features worth calling out specifically: **traits** (a mechanism for sharing method implementations across otherwise-unrelated classes, since single inheritance alone can't do this) and **enums** (PHP 8.1+, genuinely richer than most languages' plain integer/string constants).

## Classes, Interfaces, Abstract Classes, Polymorphism

```php
interface Speaker { public function speak(): string; }

abstract class Animal implements Speaker {
    public function __construct(protected string $name) {} // promoted property
    abstract public function speak(): string;
    public function describe(): string { return "{$this->name} says: " . $this->speak(); }
}

class Dog extends Animal { public function speak(): string { return "Woof!"; } }
```

`describe()` is defined once on `Animal` but calls the overridden `speak()` on whichever concrete subclass is actually instantiated — standard runtime polymorphism, exactly like every other OOP-supporting language in this repository.

## Traits: Horizontal Code Reuse

```php
trait Loggable {
    public function log(string $message): void {
        echo "[" . static::class . "] {$message}\n";
    }
}

class Service {
    use Loggable; // "inherits" log() via composition, not class inheritance
}
```

Since PHP classes can only extend one parent class, traits let unrelated classes share method implementations without an inheritance relationship — the compiler literally copies the trait's methods into each using class at compile time, distinct from both inheritance and interfaces (which declare a contract but no implementation).

## Backed Enums (PHP 8.1+)

```php
enum Status: string {
    case Active = "active";
    case Inactive = "inactive";
    case Pending = "pending";

    public function label(): string {
        return match ($this) {
            Status::Active => "Currently Active",
            Status::Inactive => "No Longer Active",
            Status::Pending => "Awaiting Activation",
        };
    }
}

Status::Active->value;          // "active"
Status::from("pending")->label(); // "Awaiting Activation" -- converts a raw value back to a case
```

PHP enums are genuinely typed objects (each case is a singleton instance of the enum type), can have methods (as shown), can implement interfaces, and — when "backed" by a scalar type (`: string` or `: int`) — provide `->value` and the static `::from()`/`::tryFrom()` conversion methods. This is a much richer feature than a plain set of class constants, which is how enum-like values were emulated in PHP before 8.1.

## Static Members and Readonly Properties

```php
class Counter {
    private static int $count = 0;
    public function __construct(public readonly int $id) { self::$count++; }
    public static function total(): int { return self::$count; }
}
```

## Detailed Example

See [example.php](example.php) — all of the above, run and verified: polymorphic `describe()` calls, the trait-based `log()` method, both enum demonstrations, and the static counter.

## Run It

```bash
cd 01-Languages/PHP/11-OOP
php example.php
```

## Expected Output

Running `php example.php` prints `Rex says: Woof!` and `Whiskers says: Meow!` (polymorphism), `[Service] service started` (the trait-provided method), `active: Currently Active` and `from string: Awaiting Activation` (the enum demonstrations), and `total counters created: 2` (the static counter).

## Common Mistakes

- Reaching for a plain class of `const` values to emulate an enum in PHP 8.1+ — backed enums provide type safety, methods, and interface implementation that a class-of-constants can't, with no real downside once 8.1+ is available.
- Confusing traits with interfaces — a trait provides actual method *implementations* copied into the using class; an interface only declares a *contract* with no implementation at all.
- Forgetting `abstract` methods must be implemented by every concrete (non-abstract) subclass — omitting one produces a fatal error at the point the subclass is instantiated.

## Best Practices

- Use backed enums (PHP 8.1+) instead of loose string/int constants for any fixed, closed set of values.
- Use traits sparingly, for genuinely cross-cutting concerns (logging, timestamps) shared across otherwise-unrelated classes — overuse of traits can obscure a class's actual behavior, since trait methods aren't visible in the class's own declaration.
- Favor constructor property promotion (`public readonly Type $prop`) for simple, immutable data-holding classes.

## Real-World Usage

Backed enums are widely adopted in modern PHP (8.1+) codebases for representing fixed domain concepts (order status, user roles, HTTP methods) with real type safety, replacing the older, weaker "class full of string constants" pattern; traits are common in frameworks (Laravel's `SoftDeletes`, `Notifiable` traits) for adding well-defined, reusable behavior to model classes without inheritance.

## Summary

- PHP OOP is single-inheritance with interfaces, like Java/C#; traits fill the multiple-inheritance-shaped gap by sharing method implementations.
- Backed enums (PHP 8.1+) are genuinely typed objects with methods, `->value`, and `::from()`/`::tryFrom()` — richer than plain constants.
- Constructor property promotion combines declaration, typing, and assignment in the constructor signature.

## Key Terms

- **Trait** — a set of method implementations that can be "used" (mixed in) by multiple otherwise-unrelated classes.
- **Backed enum** — a PHP 8.1+ enum whose cases each map to an underlying scalar value (`string`/`int`), enabling `->value` and `::from()`.

## Interview Questions

1. **How do traits solve a problem that neither single inheritance nor interfaces can solve alone in PHP?**
   PHP classes can extend only one parent class (single inheritance) and interfaces declare method signatures with no implementation at all. Traits provide actual, reusable method *implementations* that can be mixed into any number of otherwise-unrelated classes via `use TraitName;` — the compiler effectively copies the trait's methods into each using class. This solves the "I need this behavior in two unrelated class hierarchies" problem without requiring multiple inheritance (which PHP deliberately doesn't support) or duplicating the method's code manually in each class.

2. **What makes a PHP 8.1+ backed enum different from a class full of `const` values?**
   A backed enum is a genuine type: each case (`Status::Active`) is a singleton instance of the `Status` enum type, checkable with `instanceof`, usable in type declarations (a parameter can require `Status` specifically), and can have its own methods (like `label()` in this lesson's example) and implement interfaces. A backed enum also provides `->value` to get its underlying scalar representation and static `::from()`/`::tryFrom()` methods to safely convert a raw value back into the correct case, with `::from()` throwing on an invalid value and `::tryFrom()` returning `null` instead. A plain class of `const` values provides none of this — it's just loose strings/ints with no type-level guarantee they represent a valid case at all.

## Recommended Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
