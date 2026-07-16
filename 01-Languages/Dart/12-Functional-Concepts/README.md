# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP](../11-OOP/README.md)

## Learning Objectives

- Use **extension methods** — Dart's version of Kotlin's extension functions (covered in this repository's Kotlin course), adding "methods" (including getters) to existing types without inheritance or modifying their source.
- Use `typedef` to name function types, and write higher-order functions and function composition.

## Prerequisites

[11-OOP](../11-OOP/README.md)

## Concept

Dart's `extension` declarations let new methods (and getters/setters) be added to an existing type — including types Dart itself defines, like `String` — without subclassing or modifying the original type's source. This is functionally very close to Kotlin's extension functions (covered in this repository's Kotlin course) and C#'s extension methods: resolved statically at compile time based on the declared type, not through genuine runtime dynamic dispatch or monkey-patching.

## Extension Methods and Getters

```dart
extension StringExtras on String {
  String shout() => '${toUpperCase()}!';
  bool get isPalindrome { // an extension GETTER, not just a method
    var cleaned = toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == cleaned.split('').reversed.join('');
  }
}

'hello'.shout();               // "HELLO!" -- called AS IF it were a real String method
'racecar'.isPalindrome;          // true -- called like a property, not a method call
```

Verified live: `'hello'.shout()` and `'racecar'.isPalindrome` both worked exactly as if `String` itself had defined these members — Dart resolves the extension based on the value's static type at compile time, the same mechanism Kotlin's extension functions use.

## `typedef` and Function Composition

```dart
typedef IntTransformer = int Function(int); // names a function type for readability

int compose(IntTransformer f, IntTransformer g, int x) => f(g(x));

IntTransformer addOne = (x) => x + 1;
IntTransformer square = (x) => x * x;
compose(square, addOne, 4); // (4+1)^2 = 25
```

## Higher-Order Functions and Named-Function Arguments

```dart
IntTransformer multiplier(int factor) => (x) => x * factor;
var triple = multiplier(3);
triple(5); // 15

bool isEven(int n) => n % 2 == 0;
nums.where(isEven).toList(); // passing a named function directly, like Kotlin's ::isEven
```

## Detailed Example

See [example.dart](example.dart) — an extension on `String` with both a method and a getter, `typedef`-based function composition, a higher-order function returning a closure, and passing a named function directly to `.where()`.

## Run It

```bash
cd 01-Languages/Dart/12-Functional-Concepts
dart run example.dart
```

## Expected Output

Running `dart run example.dart` prints `HELLO!`, `true`, `true`, `false` (the extension method and getter demonstrations), `25` (the composed function), `15` (the higher-order function), and `[2, 4, 6]` (the named-function-based `.where()`) — all confirmed by actual execution.

## Common Mistakes

- Assuming an extension method can access a type's private members — it can't; it's resolved as an ordinary external member and only has access to the type's public API, exactly like Kotlin's extension functions.
- Confusing extension resolution with dynamic dispatch — extensions are resolved statically based on the *declared* type of the expression they're called on, not the runtime type, which can matter if a value is held through a variable typed as a different (super)type than where the extension is declared.
- Forgetting `typedef` in modern Dart (since Dart 2.13) can name *any* type alias, not just function types — though naming function types remains one of its most common, useful applications for readability.

## Best Practices

- Use extension methods to add utility behavior to existing types (including Dart's own core types like `String`/`List`) instead of writing separate static utility/helper classes — mirroring the same idiom recommended for Kotlin's extension functions.
- Use `typedef` to name complex or frequently-reused function type signatures, improving readability over repeating the full `ReturnType Function(ArgType)` syntax everywhere.
- Prefer passing named functions directly (as with `isEven` above) over wrapping them in a redundant closure, when no additional logic is needed.

## Real-World Usage

Extension methods are widely used in real Dart/Flutter code to add convenience methods to Flutter's own core types (e.g., extensions on `BuildContext` for shorthand theme/media-query access) or to Dart's core collection types — a genuinely popular, idiomatic pattern in the Flutter ecosystem for keeping utility code discoverable via autocomplete on the types it's most relevant to.

## Summary

- Dart's extension methods (and getters) add member-call-syntax behavior to existing types without inheritance — verified live, resolved statically, matching Kotlin's extension functions.
- `typedef` names function types for readability; higher-order functions and named-function arguments work as in any functional-capable language.

## Key Terms

- **Extension method** — a method (or getter/setter) added to an existing type via an `extension` declaration, resolved statically.
- **`typedef`** — names a type (commonly a function type) for reuse and readability.

## Interview Questions

1. **How does a Dart extension method compare to Kotlin's extension functions, both covered in this repository?**
   Both add member-call-syntax behavior to an existing type without modifying its source or using inheritance, and both are resolved statically at compile time based on the expression's declared type — not genuine runtime dynamic dispatch. Verified live in this lesson: `'hello'.shout()` and `'racecar'.isPalindrome` both worked as if defined directly on `String`, exactly mirroring how Kotlin's `fun String.shout()` (covered in the Kotlin course) would behave. The two languages' extension mechanisms are functionally very close, differing mainly in syntax (`extension Name on Type { }` in Dart vs. `fun Type.methodName()` in Kotlin) rather than in underlying semantics.

2. **What does `typedef` provide in Dart, and why is it especially useful for function types?**
   `typedef` creates a named alias for a type, most commonly (and usefully) a function type signature like `int Function(int)`. Naming this `IntTransformer` (as in this lesson) makes function-type parameters and variables read more clearly — `IntTransformer f` communicates intent more directly than repeating `int Function(int) f` at every usage site, especially once a function type signature becomes more complex (multiple parameters, named parameters, etc.). This is purely a readability/maintainability aid — `typedef`'d types are fully interchangeable with their underlying type, with no runtime distinction at all.

## Recommended Next Lesson

[13 — Generics](../13-Generics/README.md)
