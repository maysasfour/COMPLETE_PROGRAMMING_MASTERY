# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Follow Ruby's naming conventions: `snake_case` methods/variables, `CamelCase` classes/modules, `SCREAMING_SNAKE_CASE` constants, `?`/`!` method-name suffixes.
- Understand why overusing `method_missing` (Lesson 11) is considered an anti-pattern, and measure the real cost directly.

## Prerequisites

[18-Testing](../18-Testing/README.md)

## Concept

Ruby style conventions are largely a strong, near-universal community consensus (enforced by tools like RuboCop in real projects, though this lesson demonstrates the conventions directly rather than via a linter): `snake_case` for methods and local variables, `CamelCase` for classes/modules, `SCREAMING_SNAKE_CASE` for constants, a trailing `?` for predicate methods returning something boolean-ish (`active?`), and a trailing `!` for the "more dangerous" or mutating counterpart of an otherwise-similarly-named safer method (`withdraw!` allowing overdraft vs. `withdraw` raising on insufficient funds) — a convention, not a language-enforced rule, so the safer/riskier distinction depends entirely on the author actually following it.

**Overusing `method_missing`** (Lesson 11) is a genuine, measurable anti-pattern: beyond the introspection/`respond_to_missing?` pitfalls already covered, this lesson measures a real ~2.8x slowdown for `method_missing`-based lookups versus an equivalent plain `Hash#[]` lookup over 200,000 identical calls — a real, quantified cost, not just a stylistic objection.

## Detailed Example

See [example.rb](example.rb) — a `UserAccount` class demonstrating every naming convention above, including a "before" `SlowConfigBefore` class relying on `method_missing` for what's really just a Hash lookup, contrasted directly against an "after" `FastConfigAfter` using a plain `Hash#[]`-backed accessor, with both benchmarked over 200,000 identical calls and the real measured slowdown printed.

## Run It

```bash
cd 01-Languages/Ruby/19-Best-Practices
ruby example.rb
```

## Expected Output (real, captured)

```
active? true
balance after safe withdraw: 70
safe withdraw correctly refused: insufficient funds
balance after withdraw! (allowed overdraft): -930
method_missing lookups (200000x): 0.1111s
plain Hash lookups (200000x):      0.0403s
method_missing was 2.8x slower for the identical 200000 lookups
```

## Common Mistakes

- Relying on the `?`/`!` naming convention as if it were compiler-enforced — it isn't; nothing stops a method named `dangerous_thing!` from actually being perfectly safe, or a `?`-suffixed method from returning something other than `true`/`false`. The convention only works because the whole Ruby community actually follows it.
- Reaching for `method_missing` as the default way to implement dynamic-looking attribute access, when a plain Hash, `Struct`, or `OpenStruct` would be simpler, faster (verified directly above), and fully compatible with ordinary introspection tools.
- Mixing naming conventions inconsistently within one codebase (e.g., `getUserName` alongside `set_user_name`) — jarring for anyone reading idiomatic Ruby, and a common tell of code translated mechanically from another language.

## Best Practices

- Follow `snake_case`/`CamelCase`/`SCREAMING_SNAKE_CASE`/`?`/`!` consistently — real Ruby tooling (RuboCop) and every experienced Ruby reader expect it.
- Reserve `method_missing` for genuinely open-ended, dynamic method sets (an ORM's dynamic finder methods, a config wrapper over truly arbitrary keys) — not as a shortcut for what a plain Hash or `Struct` already does simply and faster.
- Pair every `method_missing` with `respond_to_missing?` (Lesson 11) without exception, since forgetting it silently breaks introspection.

## Real-World Usage

RuboCop (Ruby's dominant linter) enforces most of these naming conventions automatically in real projects; ActiveRecord's own use of `method_missing` for dynamic finders is a case where the dynamism is genuinely open-ended enough to justify the pattern, unlike this lesson's deliberately-contrived "before" example.

## Summary

- Ruby's naming conventions (`snake_case`, `CamelCase`, `SCREAMING_SNAKE_CASE`, `?`/`!` suffixes) are strong community convention, not compiler-enforced.
- Overusing `method_missing` where a plain Hash/Struct would do is a real, measurable anti-pattern — verified directly at a 2.8x slowdown over 200,000 identical lookups.

## Key Terms

- **Bang method (`!`)** — by convention, the "more dangerous"/mutating counterpart of a similarly-named safer method; not language-enforced.

## Interview Questions

1. **Are Ruby's `?`/`!` method-naming conventions enforced by the language itself?**
   No — they're a strong community convention, not a compiler/interpreter rule. Nothing stops a method ending in `?` from returning something other than `true`/`false`, or a non-`!`-suffixed method from being just as dangerous as its `!` counterpart. The convention works only because the Ruby community (and tools like RuboCop) consistently follows and enforces it socially/via linting, not via the language runtime.

2. **Why is overusing `method_missing` considered an anti-pattern, beyond the introspection risk covered in Lesson 11?**
   It's measurably slower than the plain method/Hash-lookup alternative it's usually replacing — verified directly in this lesson at roughly 2.8x slower over 200,000 identical calls — on top of breaking `respond_to?`/tooling introspection unless `respond_to_missing?` is also implemented. For anything with a genuinely fixed, known set of "virtual" attributes, a plain Hash-backed accessor or a `Struct` is simpler, faster, and fully compatible with ordinary Ruby tooling.

## Recommended Next Lesson

[20 — Exercises](../20-Exercises/README.md)
