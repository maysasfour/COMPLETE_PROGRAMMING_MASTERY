# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Use `if`/`elsif`/`else` and `unless`.
- Use postfix conditionals (`STATEMENT if COND;`, `STATEMENT unless COND;`).
- Use `for`, `foreach`, `while`, `until` loops.

## Concept

Perl control flow is C-like with two Perl-specific additions: `unless` (the negated `if`) and postfix modifiers, which let a single statement carry its own condition/loop without a block. See [`control_flow.pl`](control_flow.pl), run with `perl control_flow.pl`. Output (actual):

```
adult
not a minor
postfix if
postfix unless
for: 1
for: 2
for: 3
foreach: apple
foreach: banana
foreach: cherry
while: 0
while: 1
while: 2
until: 0
until: 1
until: 2
```

Notes:
- `for my $i (1..3)` and `foreach my $f (@fruits)` are the same construct — `for`/`foreach` are interchangeable keywords in Perl when iterating a list.
- `unless (COND)` is exactly `if (!COND)`; `until (COND)` is exactly `while (!COND)`. Both exist purely for readability.

## Exercises / Solutions

[Exercises/fizzbuzz.pl](Exercises/fizzbuzz.pl) — print FizzBuzz 1..20 using postfix conditionals/`unless` where natural.

[Solutions/fizzbuzz.pl](Solutions/fizzbuzz.pl) — run with `perl Solutions/fizzbuzz.pl`. Output (actual):

```
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
16
17
Fizz
19
Buzz
```

## Common beginner mistakes

- Forgetting `unless`/`until` are negated forms and stacking a redundant `!` on top (`unless (!$x)` is confusing — just use `if ($x)`).
- Using `unless`/`until` with `elsif`/`else` — Perl disallows `unless ... elsif`; use `if`/`else` instead when there's more than one branch.

## Best practices

- Reserve postfix conditionals for simple, single-statement cases; use block form once logic grows past one line.
- Prefer `if ($x)` over `unless (!$x)` for readability.
