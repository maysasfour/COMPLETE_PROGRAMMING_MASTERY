# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Know that statements must end with `;`.
- Understand sigils (`$`, `@`, `%`) as *access* markers, not type declarations.
- Verify live that `$x`, `@x`, and `%x` are three completely independent variables.

## Concept

Perl requires a semicolon `;` to terminate statements (the last statement in a block may omit it, but idiomatic style always includes it). Omitting it is a compile-time error:

```bash
$ perl -e 'print "a"
print "b"'
```
Output (actual):
```
syntax error at -e line 2, near "print"
Execution of -e aborted due to compilation errors.
```

### Sigils are not types — they're access syntax

`$foo` accesses a scalar, `@foo` an array, `%foo` a hash, all named `foo`. Critically, **these are three separate variables that happen to share a name** — Perl keeps a distinct namespace per sigil. See [`sigils.pl`](sigils.pl):

```perl
my $x = "I am a scalar";
my @x = ("I", "am", "an", "array");
my %x = (type => "I am a hash");
```

Output (actual, from `perl sigils.pl`):

```
scalar $x = I am a scalar
array  @x = I am an array
hash   %x{type} = I am a hash

after mutation:
$x = scalar changed
@x = I am an array extended
```

Mutating `$x` (reassigning the scalar) and `@x` (pushing onto the array) confirms they are fully independent storage — changing one has zero effect on the other, despite sharing the identifier `x`.

Note also `$x{type}` inside the hash line: when *accessing a single element* of `%x`, the sigil switches to `$` (because one element of a hash is a scalar), but the variable being indexed is still `%x`.

## Common beginner mistakes

- Thinking `$x`, `@x`, `%x` are "the same variable in different forms" — they are not; they're independent slots.
- Forgetting semicolons at statement ends (Perl won't infer them from newlines the way JS sometimes does).
- Confusing `@array` (the whole array, in list context) with `$array[0]` (one scalar element, hence `$`).

## Best practices

- Always terminate statements with `;`, even the last one in a block — makes future edits (adding a line after) safe.
- Don't rely on the "same name, different sigil" trick in real code even though it works — it's confusing to readers. Use distinct names.
