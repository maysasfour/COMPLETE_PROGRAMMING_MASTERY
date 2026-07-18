# 11 — OOP

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Define classes, `attr_accessor`/`attr_reader`, and inheritance (`<`).
- Use modules as **mixins** (`include`/`extend`) — Ruby's mechanism for horizontal code reuse across unrelated classes, distinct from (but conceptually comparable to) PHP's traits and Dart's mixins.
- Implement `method_missing` (plus the required `respond_to_missing?` companion) — a uniquely dynamic Ruby metaprogramming feature, demonstrated live rather than only described.

## Prerequisites

[10-File-Handling](../10-File-Handling/README.md)

## Concept

Classes and single inheritance (`class Dog < Animal`) work much like other object-oriented languages in this repository. `attr_accessor :name` generates a getter and setter in one line; `attr_reader`/`attr_writer` generate just one side.

The genuinely distinctive feature is **modules as mixins**. A Ruby `module` groups methods that can be mixed directly into a class's instance method set with `include` (making them ordinary instance methods, with zero inheritance relationship to the module) or into the class's own singleton/class-level methods with `extend` (a real, verified difference: `Widget.extend(Describable)` gives `Widget.description` as a class method, but `Widget.new.description` genuinely raises `NoMethodError`, proven live below). This lets behavior be shared across completely unrelated classes without forcing them into a common superclass — the same problem PHP's traits and Dart's mixins solve, with different mechanics.

**`method_missing`** is Ruby's uniquely dynamic metaprogramming hook: when a method call targets a name the object has no real method for, Ruby calls `method_missing(name, *args)` instead of immediately raising `NoMethodError`, letting a class respond to an open-ended, runtime-determined set of "method names" (this lesson builds a small dynamic-attribute record class around it). Overriding `method_missing` **must** be paired with overriding `respond_to_missing?`, or introspection (`respond_to?`, `.methods`) will lie about what actually works — also demonstrated live.

## Detailed Example

See [example.rb](example.rb) — `Animal`/`Dog`/`Cat` with `attr_accessor` and polymorphic `speak`; two mixins (`Greetable`, `Auditable`) `include`d into `Animal` with zero inheritance involved; `Describable` `extend`ed into `Widget`, proving live that `extend` gives a class method while calling it on an instance genuinely raises `NoMethodError`; and a `DynamicRecord` class implementing `method_missing`/`respond_to_missing?` for dynamic getters/setters, including a genuine `NoMethodError` for a truly unknown field name (proving the fallback `super` call still works correctly).

## Run It

```bash
cd 01-Languages/Ruby/11-OOP
ruby example.rb
```

## Expected Output (real, captured)

```
Rex says Woof!
Tom says Meow!
Hi, I'm Rex.
Dog: no actions logged yet
Dog(Rex, 3)
dog is now 4
a describable thing
confirmed: extend gives a CLASS method, not an instance method (NoMethodError)
Rex says Woof!
Tom says Meow!
Ruby Course
22
23
responds_to? title = true
responds_to? nope = false
correctly raised for truly unknown method: NoMethodError
```

## Common Mistakes

- Confusing `include` (adds instance methods) with `extend` (adds class/singleton methods) — verified directly above: `Widget.extend(Describable)` makes `Widget.description` work but `Widget.new.description` genuinely raise `NoMethodError`.
- Overriding `method_missing` without also overriding `respond_to_missing?` — `respond_to?`/`.methods` will then report `false`/omit the dynamically-handled names even though calling them actually works, a real, confusing introspection lie.
- Forgetting to call `super` in `method_missing`'s fallback (else) branch for genuinely unhandled names — without it, an unknown method call silently returns `nil` instead of raising the expected `NoMethodError`, hiding real bugs.

## Best Practices

- Prefer `include` (mixins) over deep inheritance chains for sharing behavior across otherwise-unrelated classes.
- Always implement `respond_to_missing?` alongside `method_missing`, and always fall back to `super` for names the class doesn't actually understand.
- Reserve `method_missing` for genuinely open-ended, dynamic method sets (as this lesson's `DynamicRecord` demonstrates) — see Lesson 19 for why overusing it is considered an anti-pattern in most real code.

## Real-World Usage

ActiveRecord's dynamic finder-like behavior and OpenStruct-style objects are built on `method_missing`; Ruby's own `Comparable` and `Enumerable` (Lessons 04 and 07) are the canonical standard-library examples of mixins providing large behavior sets from one or two methods a class implements itself.

## Summary

- Classes/inheritance are standard; `attr_accessor` generates getter+setter in one line.
- Modules mixed in via `include` become instance methods; via `extend` become class methods — a real, verified difference, not just a naming convention.
- `method_missing` (paired with `respond_to_missing?`) is Ruby's dynamic metaprogramming hook for handling calls to methods that don't concretely exist.

## Key Terms

- **Mixin** — a module's methods incorporated into a class via `include`/`extend`, without a formal inheritance relationship.
- **`method_missing`** — the hook Ruby calls instead of immediately raising `NoMethodError` when no real method matches the called name.

## Interview Questions

1. **What's the difference between `include` and `extend` for a module?**
   `include SomeModule` mixes the module's methods in as ordinary **instance** methods of the including class — every instance gets them. `extend SomeModule` mixes them in as methods on the receiver's own singleton class instead — when `extend` is called at the class level (`class Widget; extend Describable; end`), the module's methods become **class** methods (`Widget.description`), and calling the same method on an *instance* genuinely raises `NoMethodError`, verified directly in this lesson.

2. **What is `method_missing`, and what's the risk of using it?**
   It's a hook method Ruby calls when a method call targets a name the receiver has no real method for, letting a class handle an open-ended, runtime-determined set of "methods" dynamically (this lesson's `DynamicRecord` uses it for arbitrary attribute getters/setters). The risk: it must be paired with `respond_to_missing?` (or `respond_to?` lies about what works) and must `super` for genuinely unhandled names (or unknown-method typos silently return `nil` instead of raising, hiding real bugs) — see Lesson 19 for the fuller anti-pattern discussion.

## Recommended Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
