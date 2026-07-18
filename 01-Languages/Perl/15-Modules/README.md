# 15 — Modules

[Back to course overview](../README.md) | [Previous: Concurrency](../14-Concurrency/README.md)

## Learning Objectives

- Create a reusable `package`/`.pm` module and `use` it from another script.
- Understand `@INC` (Perl's module search path) and `use lib`.
- Understand CPAN conceptually as the ecosystem that distributes third-party `.pm` modules.

## Concept

[`MathUtils.pm`](MathUtils.pm):

```perl
package MathUtils;
use strict;
use warnings;
use Exporter 'import';

our @EXPORT_OK = qw(square cube);

sub square { my $n = shift; return $n * $n; }
sub cube   { my $n = shift; return $n * $n * $n; }

1;  # modules must return a truthy value
```

The trailing `1;` is not decorative — `require`/`use` treats the module file as a Perl expression that must evaluate truthy at the end, historically used to signal "this module loaded successfully."

[`use_module.pl`](use_module.pl) loads it and also prints `@INC`, run with `perl use_module.pl`. Output (actual):

```
square(4) = 16
cube(3) = 27
@INC contains:
  .
  /usr/lib/perl5/site_perl
  /usr/share/perl5/site_perl
  /usr/lib/perl5/vendor_perl
  /usr/share/perl5/vendor_perl
  /usr/lib/perl5/core_perl
  /usr/share/perl5/core_perl
```

`use lib '.';` prepends the current directory to `@INC` so `use MathUtils` can find `MathUtils.pm` sitting next to the script — without it, Perl only searches its standard library paths (the `/usr/...` entries shown above, from this msys2 install) plus whatever `PERL5LIB` sets.

`Exporter` + `our @EXPORT_OK` implements the "explicit import list" pattern (`use MathUtils qw(square cube);`) — the safer alternative to `@EXPORT`, which would dump symbols into the caller's namespace unconditionally.

### CPAN (conceptual, recap)

As discussed in [01-Setup](../01-Setup/README.md), CPAN is the ecosystem `use ModuleName;` ultimately draws from for anything not in core — `cpanm ModuleName` installs a `.pm` (and its dependencies) into a location that ends up on `@INC`. This course does not perform live installs; later lessons check module availability directly instead ([16-Database-Access](../16-Database-Access/README.md), [17-API-Integration](../17-API-Integration/README.md)).

## Common beginner mistakes

- Forgetting the trailing `1;` at the end of a `.pm` file — `require`/`use` fails with "did not return a true value."
- Using `@EXPORT` (unconditional) instead of `@EXPORT_OK` (opt-in via explicit import list) — pollutes the caller's namespace by default.
- Forgetting `use lib` (or `PERL5LIB`) when a module lives outside the standard `@INC` paths.

## Best practices

- Prefer `@EXPORT_OK` over `@EXPORT` — force callers to explicitly opt into which symbols they want.
- Namespace modules meaningfully (`My::App::Utils` rather than a flat global name) to avoid collisions with CPAN modules.
