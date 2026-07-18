# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Define subs with `sub`; understand `@_` as the implicit argument list.
- Understand Perl has no named parameters by default — you unpack `@_` yourself.
- Understand context-sensitivity: a sub can behave differently in list vs scalar vs void context, detected via `wantarray()`.

## Concept

```perl
sub add {
    my ($a, $b) = @_;   # unpack positional args yourself
    return $a + $b;
}
```

There's no parameter syntax in `sub NAME { ... }` — every call's arguments arrive flattened into `@_`, and idiomatic Perl unpacks them with `my (...) = @_;` at the top of the sub body.

### `wantarray` — verified live

`wantarray()` returns true in list context, defined-but-false in scalar context, and `undef` in void context. [`functions.pl`](functions.pl) defines a `stats` sub that genuinely branches on this:

```perl
sub stats {
    my @nums = @_;
    if (wantarray()) {
        return (min => ..., max => ...);
    } elsif (defined wantarray()) {
        return scalar(@nums);
    } else {
        return;
    }
}
```

Run with `perl functions.pl`. Output (actual):

```
add(2,3) = 5
list context: min=1 max=9
scalar context: count=5
called in void context too (no return value used)
```

This confirms the *same call expression* `stats(4, 8, 1, 9, 3)` returns a min/max hash-list when assigned to `%s`, but a plain count when assigned to `$count` — genuinely different behavior driven purely by the calling context, not by different arguments.

## Exercises / Solutions

[Exercises/minmax.pl](Exercises/minmax.pl) — write `min_max(@nums)` returning `(min,max)` in list context and `"min-max"` string in scalar context, using `wantarray`.

[Solutions/minmax.pl](Solutions/minmax.pl) — run with `perl Solutions/minmax.pl`. Output (actual):

```
list: lo=1 hi=9
scalar: 1-9
```

## Common beginner mistakes

- Forgetting to unpack `@_` and accidentally using `@_` directly further down after having modified it (aliasing gotcha: `@_` elements are aliases to the caller's variables).
- Assuming `wantarray()` is always defined — check `defined wantarray()` to distinguish "scalar context" from "void context" (both are falsy on their own).

## Best practices

- Unpack `@_` into named lexicals immediately (`my ($a, $b, $c) = @_;`) — don't index `@_` directly throughout the body.
- Only branch on `wantarray()` when there's a genuine, well-documented reason (like `localtime`); overusing it makes API behavior surprising.
