# 13 — No Generics

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

## Honest summary

Perl has **no static type system and no generics**, full stop. There is no equivalent of Java's `List<T>`, TypeScript's `Array<T>`, or Rust's `Vec<T>`. Arrays and hashes are untyped containers by design — any scalar (number, string, reference) can sit next to any other type in the same array, with zero compile-time checking.

Contrast with typed-language courses in this repository: where a Java/TypeScript/Rust course would have a `13-Generics` lesson covering type parameters and constraints, Perl's equivalent lesson is this one — explaining that the concept doesn't exist and why "one function, any type" comes for free rather than through a type-parameter mechanism.

## Concept

See [`no_generics.pl`](no_generics.pl), run with `perl no_generics.pl`. Output (actual):

```
first int:    1
first string: a
first mixed:  1
ints after mixing: 1 2 3 not actually an int, and Perl does not care
```

`first_element` works identically on an array of ints, an array of strings, or a mixed-type array — not because of any generic type parameter, but because Perl scalars/arrays never had a declared element type to begin with. The last line demonstrates the flip side: nothing stops you pushing a string into an array that had only held numbers — there is no `List<int>`-style guarantee anywhere in the language.

## Why this matters

- **Upside**: no boilerplate type parameters, no variance rules, no generic bound syntax to learn — "duck typing" and untyped containers cover the same ground generics solve in typed languages, informally.
- **Downside**: no compiler safety net. A function expecting numeric elements will happily accept a string and fail (or silently coerce) at runtime instead of at compile time. Tools like `Types::Standard` (from CPAN's `Type::Tiny` distribution) exist to add optional runtime type checking, but they are opt-in libraries, not language features, and were not tested live in this course (would require a network CPAN install — see [16-Database-Access](../16-Database-Access/README.md) for this course's policy on that).

## Common beginner mistakes

- Assuming Perl "must have generics somewhere" because most modern languages do — it genuinely doesn't, and reaching for CPAN type-constraint modules is the closest analog.
- Relying on "it happened to work with these types" as informal type safety instead of validating inputs explicitly (`Scalar::Util::looks_like_number`, manual `ref()` checks, etc.).
