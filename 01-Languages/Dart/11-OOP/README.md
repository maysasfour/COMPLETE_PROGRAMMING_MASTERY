# 11 — OOP

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Use abstract classes, named constructors, and factory constructors.
- Use **mixins** (via the `with` keyword) — a genuinely distinctive Dart language construct for horizontal code reuse, Dart's own dedicated answer to the same problem PHP's traits and Kotlin's protocol-extension-style default methods solve differently.
- Use getters/setters and the `fromJson`/`toJson` convention (building on Lesson 10's `dart:convert`).

## Prerequisites

[10-File-Handling](../10-File-Handling/README.md)

## Concept

Dart's OOP is single-inheritance (`extends`), like Java/Kotlin/C# covered elsewhere in this repository, but Dart provides **mixins** as a first-class, dedicated language construct for horizontal code reuse — genuinely its own mechanism, distinct from both PHP's traits (compiler-copied method implementations) and Kotlin's protocol-extension-style default methods (interface + extension combination).

## Abstract Classes and Polymorphism

```dart
abstract class Animal {
  final String name;
  Animal(this.name);
  String makeSound(); // abstract -- must be implemented by concrete subclasses
  String describe() => '$name says ${makeSound()}';
}

class Dog extends Animal {
  Dog(super.name); // super-parameter shorthand: forwards directly to the superclass constructor
  @override
  String makeSound() => 'Woof!';
}
```

## Mixins: A Dedicated Language Construct for Code Reuse

```dart
mixin Loggable {
  void log(String message) => print('[$runtimeType] $message');
}

class Service with Loggable { // "with" mixes Loggable's behavior in -- not inheritance
  void start() => log('service started'); // log() comes from the mixin
}
```

Verified live: `Service` gained the `log()` method purely by declaring `with Loggable`, with no inheritance relationship at all — `Service` doesn't `extend Loggable`. A class can mix in multiple mixins simultaneously (`class X with A, B, C`), something single-inheritance `extends` alone could never provide. This is Dart's own dedicated construct — not an interface-plus-extension combination like Kotlin's approach, and not a compiler-level method-copying mechanism like PHP's traits, but a distinct kind of type in Dart's language grammar (`mixin`) specifically designed for this purpose.

## Named and Factory Constructors

```dart
class Point {
  final int x, y;
  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0; // a NAMED constructor -- an alternate way to construct

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(json['x'] as int, json['y'] as int); // factory: can validate/return an existing instance
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y}; // pairs with dart:convert (Lesson 10)

  int get sum => x + y; // getter -- a computed property, no stored backing field
}
```

Named constructors (`ClassName.name(...)`) provide alternate ways to construct a type without needing distinct class names; factory constructors (`factory ClassName.name(...)`) can contain arbitrary logic before constructing, or even return an existing/cached instance instead of always creating a new one — a plain constructor cannot do either of these things. The `fromJson`/`toJson` naming convention (verified live) is the idiomatic Dart pattern for JSON serialization, pairing directly with `dart:convert`'s `jsonEncode`/`jsonDecode` from Lesson 10.

## Detailed Example

See [example.dart](example.dart) — an abstract `Animal` class with polymorphic subclasses, a `Loggable` mixin mixed into `Service`, and a `Point` class demonstrating a named constructor, a factory constructor, `toJson()`, and a getter.

## Run It

```bash
cd 01-Languages/Dart/11-OOP
dart run example.dart
```

## Expected Output

Running `dart run example.dart` prints `Rex says Woof!` and `Whiskers says Meow!` (polymorphism), `[Service] service started` (confirming the mixin-provided method), and the named/factory constructor demonstrations (`p1.sum: 7, p2.sum: 0` and `p3.sum: 11, p3.toJson(): {x: 5, y: 6}`) — all confirmed by actual execution.

## Common Mistakes

- Confusing mixins with interfaces or inheritance — a mixin provides actual method implementations (like a trait) but is applied via `with`, not `extends`, and multiple mixins can be combined on one class, unlike single inheritance.
- Forgetting `factory` constructors cannot use `this.field` initializer shorthand or an initializer list the way regular/named constructors can — they must construct and explicitly `return` an instance from the constructor body.
- Assuming `jsonDecode`'s dynamically-typed result (Lesson 10) can be passed directly to typed code without a `fromJson`-style conversion — an explicit factory constructor (as shown here) is the idiomatic way to bridge dynamically-typed JSON data into a strongly-typed Dart class.

## Best Practices

- Use mixins for genuinely cross-cutting behavior (logging, equality helpers, common utility methods) shared across otherwise-unrelated class hierarchies.
- Use the `fromJson`/`toJson` factory-constructor convention consistently for any class needing JSON serialization, pairing with `dart:convert` (Lesson 10).
- Use named constructors to provide clear, self-documenting alternate ways to construct a type (like `Point.origin()`) rather than overloading a single constructor with many optional/boolean parameters.

## Real-World Usage

Mixins are widely used in real Flutter code — many of Flutter's own framework classes use mixins (e.g., `SingleTickerProviderStateMixin` for animation support in a `State` class) to add specific, well-defined capabilities to a class without requiring a particular inheritance hierarchy; the `fromJson`/`toJson` factory-constructor pattern is the de facto standard for JSON model classes throughout the Dart/Flutter ecosystem.

## Summary

- Dart is single-inheritance (`extends`) like Java/Kotlin/C#, but adds **mixins** (`with`) as a dedicated, distinct language construct for horizontal code reuse — verified live to add a method to a class with no inheritance relationship involved.
- Named constructors (`ClassName.name()`) and factory constructors (`factory ClassName.name()`, which can validate/return existing instances) provide flexible construction patterns beyond a single default constructor.
- The `fromJson`/`toJson` convention, paired with `dart:convert` (Lesson 10), is Dart's idiomatic JSON serialization pattern.

## Key Terms

- **Mixin** — a Dart language construct (`mixin` keyword, applied via `with`) providing reusable method implementations to multiple, otherwise-unrelated classes.
- **Factory constructor** — a constructor (marked `factory`) that can run arbitrary logic and return any instance (new or existing) rather than always constructing a fresh one.

## Interview Questions

1. **How does a Dart mixin differ from both inheritance (`extends`) and an interface, and what problem does it solve?**
   A mixin (declared with the `mixin` keyword and applied via `with`) provides actual, concrete method implementations — like a class — but a class can mix in mixins *in addition to* extending a single superclass, and can mix in *multiple* mixins simultaneously (`class X with A, B, C`), something single inheritance alone cannot do. This was verified live: `Service with Loggable` gained a working `log()` method with no `extends` relationship to `Loggable` at all. An interface, by contrast, only declares method signatures with no implementation. Mixins solve the "I need this behavior in several otherwise-unrelated classes, without giving up my one inheritance slot or implementing the logic redundantly in each class" problem — the same class of problem PHP's traits and Kotlin's protocol-extension-default-methods pattern each solve with their own distinct mechanisms.

2. **What can a `factory` constructor do that a regular constructor cannot?**
   A `factory` constructor's body can run arbitrary logic — validation, caching lookups, conditional construction — before deciding what to return, and critically, it can return an *existing* instance instead of always constructing a brand-new one (useful for implementing a cache or a singleton pattern). A regular constructor, by contrast, always constructs a new instance of its own class and cannot return anything else; its initializer list is limited to setting `final` fields and calling the superclass constructor. This was demonstrated in this lesson with `Point.fromJson()`, a factory constructor that extracts and validates fields from a dynamically-typed JSON `Map` before constructing (and returning) a `Point` — logic a plain constructor's initializer-list-only body couldn't express as directly.

## Recommended Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
