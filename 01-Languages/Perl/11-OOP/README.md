# 11 — OOP

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Build traditional bless-based OOP by hand: `bless`, `@ISA` inheritance, method dispatch.
- Verify live whether the experimental `class` feature (Perl 5.38+) works in this install, and use it if so.

## Concept

### Traditional: `bless`

Perl's core language has no `class` keyword historically — OOP is a convention built from packages, hashrefs, and `bless`. See [`bless_oop.pl`](bless_oop.pl), run with `perl bless_oop.pl`. Output (actual):

```
Creature says Grr
Rex says Woof
Rex fetches the ball
dog isa Animal? yes
ref($dog) = Dog
```

Key mechanics:
- `bless $self, $class` tags a plain hashref with a class name so `->` method calls know where to look up methods.
- `our @ISA = ('Animal');` in package `Dog` is the classic inheritance mechanism — Perl walks `@ISA` to find inherited methods (`speak` is defined only on `Animal`, called successfully on a `Dog`).
- `->isa('Animal')` and `ref($dog)` confirm the object's class identity at runtime.

### Modern: experimental `class` feature — verified live

This Perl 5.38.2 build **does** support `use feature 'class'`, confirmed by running real code including field defaults, methods with parameters, and inheritance via `:isa(...)`. See [`class_feature.pl`](class_feature.pl), run with `perl class_feature.pl`. Output (actual):

```
(3, 4)
(4, 3)
(1, 2) z=9
```

```perl
use v5.38;
use feature 'class';
no warnings 'experimental::class';

class Point {
    field $x :param = 0;
    field $y :param = 0;
    method show { return "($x, $y)"; }
    method move ($dx, $dy) { $x += $dx; $y += $dy; }
}

class Point3D :isa(Point) {
    field $z :param = 0;
    method show { my $base = $self->SUPER::show; return "${base} z=$z"; }
}
```

`no warnings 'experimental::class'` is required — the feature is explicitly marked experimental in 5.38 and its syntax/semantics may still change in later Perl releases. `field` declares private instance state (no manual `$self->{x}` bookkeeping needed), `method` implicitly receives `$self`, and `:isa(Point)` plus `$self->SUPER::show` demonstrate that inheritance and superclass method calls both work as expected in this build.

## Common beginner mistakes

- Forgetting `bless` — a plain hashref with methods defined "nearby" is not an object; `bless` is what wires the hashref to its package's method table.
- Modifying `@ISA` at runtime in ways that create surprising diamond inheritance — Perl's default MRO is depth-first left-to-right unless `use mro 'c3';` is requested.
- Using the `class` feature in production code without acknowledging it's experimental and may change between Perl versions.

## Best practices

- For new code on Perl 5.38+, prefer the `class` feature for its clarity — but pin/verify the Perl version in your deployment target, since it's still experimental.
- For code that must run on older Perls or match existing codebase conventions, `bless`-based OOP remains completely standard and battle-tested.
