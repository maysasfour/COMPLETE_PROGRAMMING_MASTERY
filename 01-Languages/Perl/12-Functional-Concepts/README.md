# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP](../11-OOP/README.md)

## Learning Objectives

- Use anonymous subs (`sub { ... }`) as first-class values.
- Verify live that closures capture and privately retain lexical state per-instance.
- Chain `map`/`grep` as the functional filter/transform idiom, and pass subs as arguments.

## Concept

See [`functional.pl`](functional.pl), run with `perl functional.pl`. Output (actual):

```
square(5) = 25
c1: 0 1 2
c2: 100 101
c1 and c2 have independent state (verified: c1 unaffected by c2 calls)
even squares: 4 16 36 64 100
apply_twice(square, 3) = 81
```

- `my $square = sub { ... };` — subs are values assignable to scalars, invoked with `->()`.
- `make_counter` returns a new anonymous sub each call, and each returned sub closes over its **own** `$count` lexical — `$c1` and `$c2` were confirmed to increment completely independently (`c1: 0 1 2`, `c2: 100 101`, no cross-contamination).
- `map { $_ * $_ } grep { $_ % 2 == 0 } @nums` composes two functional primitives in one pipeline: filter evens, then square each.
- `apply_twice($fn, $val)` shows a sub reference passed as a plain argument and invoked twice — Perl subs are ordinary values, so higher-order functions need no special syntax.

## Common beginner mistakes

- Believing closures share state across all instances returned from the same factory sub — they don't; each closure gets its own copy of captured lexicals per invocation of the factory.
- Forgetting `->()` to invoke a sub reference (`$square(5)` is a syntax error; it must be `$square->(5)`, or `&$square(5)`).

## Best practices

- Use closures for genuinely private, encapsulated state (counters, memoization caches) instead of package globals.
- Prefer `map`/`grep` pipelines over manual accumulator loops for simple transform/filter logic — more declarative and idiomatic.
