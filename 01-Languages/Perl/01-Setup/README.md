# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Confirm a working `perl` interpreter and know how to check its version.
- Run a `.pl` script from the command line.
- Know how to read documentation with `perldoc`.
- Understand CPAN conceptually (this course does not run live `cpan install` — see rationale below).

## Concept

Perl ships as an interpreter (`perl`) that executes `.pl` scripts directly — no separate compile step for the developer. This course's environment already has Perl installed as part of Git for Windows (an msys2 build), so no Strawberry Perl or ActivePerl installation was performed.

### Verified live

```bash
$ perl -v
```

Output (actual, captured in this environment):

```
This is perl 5, version 38, subversion 2 (v5.38.2) built for x86_64-msys-thread-multi

Copyright 1987-2023, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.
```

Location: `C:\Program Files\Git\usr\bin\perl.exe` (on `PATH` as `perl`).

### Running a script

[`hello.pl`](hello.pl):

```perl
#!/usr/bin/env perl
use strict;
use warnings;

print "Hello, Perl $]!\n";
```

Run with:

```bash
$ perl hello.pl
```

Output (actual):

```
Hello, Perl 5.038002!
```

`$]` is a built-in variable holding the running Perl version number.

### perldoc

`perldoc perlintro` and `perldoc -f <function>` (e.g. `perldoc -f sort`) are the built-in offline documentation system. Verified available in this environment:

```bash
$ perldoc -f sort | head -3
```
Output (actual):
```
    sort SUBNAME LIST
    sort BLOCK LIST
    sort LIST
```

### CPAN (conceptual)

CPAN (comprehensive perl archive network, https://metacpan.org) is Perl's package repository, browsable via the `cpan` command-line client or `cpanm` (App::cpanminus). This course does **not** perform live `cpan install` calls — installing modules requires network access and can be slow/unreliable in a sandboxed CI-like environment, and doing so is unnecessary risk for a setup lesson. Instead, later lessons ([16-Database-Access](../16-Database-Access/README.md), [17-API-Integration](../17-API-Integration/README.md)) each **check** with `perl -MModuleName -e "print 1"` whether a module is already present, and are honest about what is/isn't available in this Perl 5.38.2 msys build.

## Common beginner mistakes

- Forgetting the shebang line — irrelevant when invoking `perl script.pl` explicitly (as this course always does), but required if you `chmod +x` and run `./script.pl` directly on Unix.
- Assuming `cpan install Foo` "just works" offline — it needs network access to CPAN mirrors.

## Best practices

- Always check `perl -v` at the start of a new environment/project to know your baseline feature set (e.g. whether `try`/`catch` or `class` are available — both need 5.34+/5.38+ respectively).
