# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Use array/hash slices.
- Use `map`, `grep`, `sort` with custom comparators.
- Combine hash lookups inside a sort comparator to rank data.

## Concept

See [`collections.pl`](collections.pl), run with `perl collections.pl`. Output (actual):

```
slice [1..3]: 2 9 1
squares: 25 4 81 1 49 9
evens: 2
desc: 9 7 5 3 2 1
ranked: alice carol bob
hash slice: 90 88
```

Key points:
- `@nums[1..3]` is an **array slice** — returns multiple elements as a list; sigil stays `@` because the result is plural.
- `@score{qw(alice carol)}` is a **hash slice** — same idea for hashes.
- `sort { $b <=> $a } @nums` uses the special globals `$a`/`$b` (implicit block-local for `sort`) as the two-element comparator, returning negative/zero/positive.
- `sort { $score{$b} <=> $score{$a} } keys %score` sorts hash *keys* by looking up their associated *values* inside the comparator — a very common idiom for ranking.

## Exercises / Solutions

[Exercises/wordcount.pl](Exercises/wordcount.pl) — given a list of words, count occurrences and print sorted by count descending, alphabetical tie-break.

[Solutions/wordcount.pl](Solutions/wordcount.pl) — run with `perl Solutions/wordcount.pl`. Output (actual):

```
apple: 3
banana: 2
cherry: 1
```

The comparator `$count{$b} <=> $count{$a} || $a cmp $b` demonstrates chaining a numeric primary sort with an alphabetical tie-break using Perl's `||` short-circuit (falls through to the second comparison only when the first returns `0`).

## Common beginner mistakes

- Forgetting default `sort` is lexicographic (`cmp`-based) even on numbers — `sort (10, 9, 2)` gives `(10, 2, 9)`, not `(2, 9, 10)`, unless you supply `{ $a <=> $b }`.
- Using `$a`/`$b` as regular variable names elsewhere in the same scope as a `sort` block — they're package globals `sort` relies on, so shadowing them with `my $a` breaks the comparator silently.

## Best practices

- Always specify an explicit comparator for `sort` unless you genuinely want default string ordering.
- Prefer `map`/`grep` over manual `for` loops with `push` when building a transformed/filtered list — more idiomatic and often faster.
