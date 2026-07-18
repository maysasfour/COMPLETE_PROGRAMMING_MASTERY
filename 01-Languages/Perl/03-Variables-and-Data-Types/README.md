# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Understand Perl's three built-in data structures: scalar, array, hash.
- Understand `my` (lexical scope) vs `our` (package-global) vs no declaration.
- Understand why `use strict; use warnings;` is near-mandatory in modern Perl — verified live.

## Concept

Perl has three core variable types, distinguished by sigil (see [02-Syntax](../02-Syntax/README.md)):

- **Scalar** (`$x`): a single value — number, string, or reference. Perl doesn't distinguish int/float/string at the language level; numeric-looking strings auto-convert.
- **Array** (`@x`): an ordered, 0-indexed, heterogeneous list.
- **Hash** (`%x`): unordered key → scalar value pairs.

See [`vars.pl`](vars.pl), run with `perl vars.pl`. Output (actual):

```
int=42 float=3.14 str=hello undef is undef
arr has 4 elements; arr[1]=two
hash{name}=Ada hash{year}=1815
inside block: only visible in this block
package_global=visible via full name too, also as $main::package_global=visible via full name too
```

### `my` vs `our` vs no declaration

- `my $x` — lexically scoped to the enclosing block/file. This is what you should use almost always.
- `our $x` — declares a *package* (global) variable, accessible via its fully-qualified name (`$main::x` from outside the package), useful for module-level config or singletons.
- No declaration at all — Perl auto-vivifies a package global on first use, **silently**, unless `use strict` is active.

### `use strict; use warnings;` — verified live

Without `strict`, a typo'd variable name is silently accepted as a brand-new global:

```bash
$ perl -e '$undeclared = "oops, silently works without strict"; print "$undeclared\n";'
```
Output (actual):
```
oops, silently works without strict
```

With `strict` active, the exact same typo is caught at **compile time**:

```bash
$ perl -e 'use strict; use warnings; $undeclared = "oops"; print "$undeclared\n";'
```
Output (actual):
```
Global symbol "$undeclared" requires explicit package name (did you forget to declare "my $undeclared"?) at -e line 1.
Global symbol "$undeclared" requires explicit package name (did you forget to declare "my $undeclared"?) at -e line 1.
Execution of -e aborted due to compilation errors.
```

This is the single biggest reason `use strict; use warnings;` is considered near-mandatory in every modern Perl file: without it, a misspelled variable name is not an error — it's a brand new global initialized to `undef`, which is one of the most notorious classes of Perl bugs historically. `use warnings` additionally flags things like using `undef` in numeric/string context, which `strict` alone does not catch.

## Common beginner mistakes

- Omitting `use strict; use warnings;` "to save typing" — this removes your best static safety net.
- Forgetting `scalar(@array)` to get an array's length as a number (in list context `@array` is its elements, not its count).
- Assuming hash key order is insertion order or sorted — it's neither; iterate with `sort keys %hash` if order matters.

## Best practices

- Put `use strict; use warnings;` as the first two lines of every `.pl`/`.pm` file, no exceptions.
- Default to `my`; reach for `our` only for genuine package-level state (rare in application code, more common in modules).
