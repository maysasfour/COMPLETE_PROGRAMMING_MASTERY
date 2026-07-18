# Perl

Perl is a dynamically-typed, sigil-based scripting language born in 1987 for text processing and system administration, later famous as "the duct tape of the internet" for CGI web work in the 1990s. It remains widely used for text munging, sysadmin/DevOps glue scripts, bioinformatics pipelines, and legacy enterprise systems. This course uses **Perl 5.38.2**, installed as part of Git for Windows (`C:\Program Files\Git\usr\bin\perl.exe`, an msys2/x86_64 build), which is what every example in this course was actually run against.

## Why learn Perl

- Enormous legacy footprint: sysadmin scripts, bioinformatics (BioPerl), telecom, and financial back-office systems still run on it.
- Regex is a first-class language feature (`=~`, `m//`, `s///`), not a bolted-on library — arguably the best regex ergonomics of any mainstream language.
- CPAN (Comprehensive Perl Archive Network) is one of the oldest and largest package ecosystems, predating npm/PyPI by a decade.
- Modern Perl (5.34+) has gained `try`/`catch` and an experimental `class` feature, narrowing the gap with more modern languages while staying backward compatible to 1994.

## Disadvantages

- Sigil/context rules (`$`, `@`, `%`, scalar vs list context) have a steep learning curve and are a frequent source of "line noise" complaints.
- No enforced OOP or type system baked into the core language — both are either hand-rolled (`bless`) or very recently experimental (`class`).
- Community and job market have shrunk significantly relative to Python/Ruby/Go since the 2000s.
- Easy to write dense, hard-to-read code if `strict`/`warnings` and naming discipline aren't enforced.

## Install / Verify

This environment already has Perl on `PATH` via Git for Windows. Verify with:

```bash
perl -v
```

No separate install (e.g. Strawberry Perl) was needed or used for this course — see [01-Setup](01-Setup/README.md) for the actual verified output.

## How to run examples

Every `.pl` file in this course was executed for real with:

```bash
perl path/to/script.pl
```

Lesson `README.md` files paste the **real** stdout/stderr from running these scripts as "Output" blocks — never fabricated.

## Common beginner mistakes

- Forgetting `use strict; use warnings;` — Perl will silently auto-vivify typo'd variables without them.
- Confusing `==`/`!=` (numeric) with `eq`/`ne` (string) comparison — see [04-Operators](04-Operators/README.md), verified live.
- Forgetting that array/hash interpolation only happens inside **double**-quoted strings, not single-quoted — see [08-Strings](08-Strings/README.md).
- Assuming a sub returns list context; use `wantarray` to know for sure — see [06-Functions](06-Functions/README.md).

## Best practices (short version)

Always `use strict; use warnings;` at the top of every file. See [19-Best-Practices](19-Best-Practices/README.md) for a full anti-pattern/fix pair.

## Interview questions

1. What is the difference between `my`, `our`, and `local`?
2. Why does `"10" == "10.0"` return true while `"10" eq "10.0"` returns false?
3. What is context (scalar vs list) in Perl, and how does `wantarray` let a sub detect it?
4. How does traditional Perl OOP with `bless` work, without any built-in `class` keyword?
5. What's the difference between `die`/`eval` and the newer `try`/`catch` feature?

## Table of Contents

| # | Section | Notes |
|---|---------|-------|
| 01 | [Setup](01-Setup/README.md) | perl, perldoc, CPAN |
| 02 | [Syntax](02-Syntax/README.md) | sigils verified live |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | scalars/arrays/hashes, strict/warnings |
| 04 | [Operators](04-Operators/README.md) | numeric vs string comparison, verified live |
| 05 | [Control Flow](05-Control-Flow/README.md) | if/unless, postfix, loops + exercises |
| 06 | [Functions](06-Functions/README.md) | @_, wantarray verified live + exercises |
| 07 | [Collections](07-Collections/README.md) | arrays/hashes, map/grep/sort + exercises |
| 08 | [Strings](08-Strings/README.md) | interpolation, regex, verified live |
| 09 | [Error Handling](09-Error-Handling/README.md) | eval/die and native try/catch, verified live |
| 10 | [File Handling](10-File-Handling/README.md) | open/close, JSON::PP |
| 11 | [OOP](11-OOP/README.md) | bless-based OOP + experimental `class` feature |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | closures, anon subs, map/grep |
| 13 | [No Generics](13-No-Generics/README.md) | honest short lesson |
| 14 | [Concurrency](14-Concurrency/README.md) | threads, fork() on msys perl |
| 15 | [Modules](15-Modules/README.md) | package, use/require, @INC, CPAN |
| 16 | [Database Access](16-Database-Access/README.md) | DBI/DBD::SQLite availability check |
| 17 | [API Integration](17-API-Integration/README.md) | HTTP::Tiny live HTTP calls |
| 18 | [Testing](18-Testing/README.md) | Test::More + prove, real output |
| 19 | [Best Practices](19-Best-Practices/README.md) | anti-pattern/fix, both run |
| 20 | [Exercises](20-Exercises/README.md) | 8 problems |
| 21 | [Solutions](21-Solutions/README.md) | run for real |
| 22 | [Mini-Projects](22-Mini-Projects/README.md) | CLI Task Tracker |
