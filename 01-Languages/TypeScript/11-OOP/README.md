# 11 — OOP

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Use access modifiers (`public`, `private`, `protected`) and compare them with JavaScript's runtime `#private` fields.
- Implement an `interface` with a class, and extend an `abstract class`.
- Use parameter properties to reduce constructor boilerplate.

## Prerequisites

[10-File-Handling](../10-File-Handling/README.md)

## Concept

Classes work exactly as in [01-Languages/JavaScript/11-OOP](../../JavaScript/11-OOP/README.md) (`extends`/`super`, `static`, getters). TypeScript adds **compile-time-only** access modifiers (`public`, `private`, `protected`) as an alternative/complement to JavaScript's runtime-enforced `#private` fields, plus `interface implements` and `abstract class` for defining contracts a class must fulfill.

## Access Modifiers vs. `#private`

```ts
class BankAccount {
  private balance: number; // compile-time only -- erased at runtime, NOT truly private

  constructor(initialBalance: number) {
    this.balance = initialBalance;
  }

  deposit(amount: number): void {
    this.balance += amount;
  }

  getBalance(): number {
    return this.balance;
  }
}

const account = new BankAccount(100);
// account.balance; // error: Property 'balance' is private -- but only a COMPILE-time error
```

`private`/`protected` are enforced only by the compiler — the emitted JavaScript has no protection at all (`(account as any).balance` bypasses it completely at runtime, and plain JavaScript code calling into compiled output has zero restriction). The JavaScript course's `#private` fields (Lesson 11) are enforced by the *runtime itself*, a fundamentally stronger guarantee. Modern TypeScript style increasingly favors real `#private` fields for genuine encapsulation and reserves `private`/`protected` mainly for `protected` (which `#` fields cannot express, since `#` fields aren't inherited-and-accessible the same way).

## Interfaces and `implements`

```ts
interface Shape {
  area(): number;
  perimeter(): number;
}

class Rectangle implements Shape {
  constructor(private width: number, private height: number) {} // parameter properties

  area(): number {
    return this.width * this.height;
  }

  perimeter(): number {
    return 2 * (this.width + this.height);
  }
}
```

`implements Shape` is a compile-time-only contract check: it verifies `Rectangle` has every method `Shape` requires, with compatible signatures — nothing about `implements` exists at runtime (no `instanceof Shape` is possible for a plain interface, since interfaces are erased entirely; only classes exist at runtime).

## Abstract Classes

```ts
abstract class Employee {
  constructor(protected name: string) {}

  abstract calculatePay(): number; // no body -- every subclass MUST implement this

  describe(): string {
    return `${this.name} earns ${this.calculatePay()}`;
  }
}

class SalariedEmployee extends Employee {
  constructor(name: string, private annualSalary: number) {
    super(name);
  }
  calculatePay(): number {
    return this.annualSalary / 12;
  }
}

// new Employee("Ada"); // error: Cannot create an instance of an abstract class
```

Unlike an `interface` (fully erased, no runtime trace), an `abstract class` **does** exist at runtime as a real class — it just cannot be instantiated directly (`new Employee(...)` is a compile-time error), and can provide real, shared implementation (`describe()` above) alongside abstract members subclasses must fill in.

## Detailed Example

See [example.ts](example.ts).

## Expected Output

Compiling and running `example.ts` prints a `private`-protected `BankAccount` used correctly, a demonstration that `private` is compile-time-only (bypassed via an explicit `as any` cast, which the example uses deliberately to prove the point, not as a recommended pattern), an interface implemented by a class, and an abstract class with a concrete subclass computing pay correctly.

## Common Mistakes

- Believing `private`/`protected` provide the same guarantee as `#private` fields — they don't; they're compile-time only and can be bypassed by an `as any` cast or from plain JavaScript calling into the compiled output.
- Trying to `instanceof` an `interface` — interfaces have zero runtime representation; only classes (including `abstract class`) exist at runtime and support `instanceof`.
- Forgetting an `abstract class` still can't be instantiated directly even though it looks like a normal class otherwise.

## Best Practices

- Prefer `#private` fields (from the JavaScript course, Lesson 11) for genuine runtime encapsulation; use `private`/`protected` mainly where `protected` inheritance access is specifically needed, or in a codebase/team convention that already standardizes on TypeScript-only modifiers.
- Use `interface` to define a contract multiple unrelated classes can implement; use `abstract class` when subclasses should share real, concrete base behavior in addition to a contract.
- Use parameter properties (`constructor(private width: number)`) to eliminate repetitive field-declaration-plus-assignment boilerplate.

## Real-World Usage

`interface`-based contracts are the standard way to define pluggable strategies (a `PaymentProcessor` interface with `StripeProcessor`/`PayPalProcessor` implementations) in TypeScript backend code; `abstract class` is common for base classes providing shared infrastructure (logging, common validation) alongside a few methods each subclass must define itself.

## Summary

- `private`/`protected` are compile-time-only access modifiers; `#private` fields (JavaScript course, Lesson 11) are the stronger, runtime-enforced alternative.
- `interface implements` is a compile-time-only contract check with zero runtime trace; `abstract class` exists at runtime as a real (non-instantiable-directly) class.
- Parameter properties reduce constructor boilerplate for simple field-assigning classes.

## Key Terms

- **Access modifier** — `public`/`private`/`protected`, TypeScript's compile-time-only visibility control.
- **`implements`** — a compile-time contract check that a class provides everything an interface requires.
- **`abstract class`** — a class that cannot be instantiated directly, potentially mixing concrete and `abstract` (must-be-overridden) members.

## Review Questions

1. Why can `(account as any).balance` bypass a `private` field but not a `#private` field?
2. Why can't you use `instanceof` against a plain `interface`?
3. What can an `abstract class` provide that a plain `interface` cannot?

## Interview Questions

1. **What's the difference between TypeScript's `private` and JavaScript's `#private` fields in terms of actual enforcement?**
   `private` is a compile-time-only annotation — `tsc` reports an error if you access it from outside the class, but the emitted JavaScript has no restriction at all, so a type assertion (`as any`) or plain JavaScript code calling into the compiled output can access it freely. `#private` fields are enforced by the JavaScript engine itself at runtime — there is no way to access them from outside the class body, in compiled output or otherwise.

2. **Can you use `instanceof` to check if an object implements a TypeScript `interface`?**
   No — interfaces are a purely compile-time construct and are completely erased during compilation; there is no runtime representation of an interface to check against. `instanceof` only works against actual runtime constructs: classes (including `abstract class`), which do exist after compilation.

3. **What's the difference between an `abstract class` and an `interface`?**
   An `interface` is fully erased at compile time and can only declare a shape/contract, with zero runtime existence. An `abstract class` exists as a real class at runtime, can provide concrete shared method implementations alongside `abstract` methods that subclasses must implement, and cannot be instantiated directly itself — it sits between a plain interface (pure contract) and a normal class (fully concrete).

## Recommended Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
