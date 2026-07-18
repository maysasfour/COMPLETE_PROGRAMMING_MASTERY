# Ruby

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What Ruby Is

Ruby is a dynamically-typed, interpreted, purely object-oriented scripting language — even integers, `nil`, and `true`/`false` are real objects with real methods, with no separate "primitive" category at all. Like PHP and Python elsewhere in this repository, Ruby has no build step: `ruby file.rb` parses and executes a script directly, every run. Ruby is best known as the language behind Ruby on Rails, one of the most influential web frameworks in the industry's history.

## Why / Where It's Used

- **Web development** — Ruby on Rails remains a major full-stack web framework (GitHub, Shopify, Basecamp, and many other well-known products were built on it).
- **DevOps tooling** — Chef and (historically) Vagrant were written in Ruby; many infrastructure-automation scripts still use it.
- **Static site generation** — Jekyll (which also powers GitHub Pages) is a Ruby tool.
- **Scripting and automation** — Ruby's expressive, English-like syntax makes it a popular choice for CLI tools and one-off automation scripts.

## Advantages

- Genuinely elegant, expression-oriented syntax — `if`/`case`/`begin` all evaluate to a value, and postfix conditionals read like plain English (Lesson 02).
- A real, distinctive three-way split between blocks, Procs, and lambdas, giving fine control over closure semantics (arity strictness, `return` scope) that most languages compress into a single function-value type (Lesson 06).
- `Enumerable`, mixed into `Array`/`Hash`/`Range`/many other classes, provides dozens of chainable, declarative iteration methods from a single `each` implementation (Lesson 07).
- Modules-as-mixins (`include`/`extend`) give genuine horizontal code reuse without forcing an inheritance relationship (Lesson 11), and `method_missing` offers uniquely dynamic metaprogramming (also Lesson 11) — though it should be reached for deliberately, not by default (Lesson 19, with a real measured cost).
- JSON and a genuine standard-library HTTP client (`Net::HTTP`) both ship with zero gem installs (Lessons 10, 17), and Minitest — a full test framework — ships with the language itself (Lesson 18).

## Disadvantages

- No generics at all (Lesson 13) — like Python and PHP, type safety for container-like classes depends entirely on discipline and duck typing (`respond_to?`), not the language itself.
- MRI/CRuby's GVL (Global VM Lock, Ruby's name for what Python calls the GIL) means `Thread`s never give genuine CPU parallelism — measured directly in this course at a real 0.97x "speedup" for four CPU-bound threads on a 12-core machine (Lesson 14).
- Ruby's flexibility (operator overloading, `method_missing`, monkey-patching core classes) is a real double-edged sword: powerful when used deliberately, a genuine maintainability risk when overused (Lesson 19).
- Historically slower raw execution speed than compiled languages in this repository — this course's own GVL benchmark took roughly 19 seconds for a single 40-million-iteration arithmetic loop, illustrating MRI/CRuby's interpreted-execution cost directly.

## How to Install

Windows has no system Ruby by default. This course used a portable RubyInstaller build extracted to an isolated, non-system-wide directory:

```bash
# A portable RubyInstaller .exe (obtained via choco's cached package),
# installed silently to an isolated directory rather than Program Files:
rubyinstaller-3.4.10-1-x64.exe /verysilent /dir="C:\Users\HP\tools\Ruby34" /tasks="" /norestart

export PATH="/c/Users/HP/tools/Ruby34/bin:$PATH"   # current shell only, not persisted system-wide
ruby -v
gem install sqlite3   # needed for Lessons 16 and 22
```

This course was written and verified against **Ruby 3.4.10 (x64-mingw-ucrt), RubyGems 3.6.9**, with the `sqlite3` gem (2.9.5) installed via a precompiled native binary (no separate build toolchain needed).

## How to Run the Examples

Every lesson folder has a `README.md` and a runnable `example.rb` (or `example_test.rb` for Lesson 18). From the repository root:

```bash
cd 01-Languages/Ruby/03-Variables-and-Data-Types
ruby example.rb
```

Lessons 16 and 22 need the `sqlite3` gem installed first (`gem install sqlite3`); every other lesson runs with zero additional installs.

## Common Beginner Mistakes

- **Confusing `Proc` and lambda `return` semantics** — `return` inside a lambda exits only the lambda; `return` inside a plain `Proc` exits the *enclosing method* the Proc was created in, verified live in Lesson 06 (including a line that provably never executes because of it).
- **Assuming `JSON.parse` returns symbol keys** — it returns **string** keys by default; `symbolize_names: true` must be passed explicitly, verified live in Lesson 10.
- **Assuming Ruby `Thread`s give real CPU parallelism** — MRI/CRuby's GVL prevents it; measured directly in Lesson 14 at a real ~1x "speedup" for CPU-bound work (vs. a real ~3x speedup for I/O-bound work, where the GVL actually is released).
- **Overusing `method_missing`** where a plain Hash or `Struct` would do — genuinely measured 2.8x slower than an equivalent direct lookup in Lesson 19, on top of breaking introspection if `respond_to_missing?` is forgotten.

## Best Practices

- Subclass `StandardError` (never `Exception` directly) for custom exceptions, so bare `rescue` clauses actually catch them (Lesson 09).
- Always use parameterized (`?`) SQL queries — verified live in Lesson 16 to defuse a real, reproduced SQL injection that succeeds when the same query is built via string interpolation instead.
- Follow Ruby's naming conventions (`snake_case`, `CamelCase`, `SCREAMING_SNAKE_CASE`, `?`/`!` suffixes) consistently — they are community convention, not language-enforced, but expected throughout idiomatic Ruby (Lesson 19).
- Use `respond_to?` at any boundary where an argument's shape isn't statically guaranteed, since Ruby has no generics or compile-time type checking to catch a mismatch earlier (Lesson 13).

## Interview Questions

1. **What's the difference between a Ruby block, a `Proc`, and a lambda?**
   A block is the `{ ... }`/`do...end` syntax attached to a method call — not an object, invoked via `yield`. A `Proc` is a block turned into a real, storable object with lenient argument-count checking and a `return` that exits the *enclosing method*. A lambda is a stricter `Proc` — strict arity checking (`ArgumentError` on mismatch) and a `return` that exits only the lambda itself. This was verified live in Lesson 06, including a `Proc`'s `return` genuinely terminating its enclosing method before a following line could run.

2. **Does Ruby have generics, and what's the idiomatic alternative?**
   No — there is no `<T>` type-parameter syntax anywhere in the language, the same gap as Python and PHP elsewhere in this repository. Ruby relies on duck typing (an object is compatible if it responds to the needed methods, regardless of class) and `respond_to?` as the runtime-checkable substitute for a compile-time generic constraint, demonstrated in Lesson 13 by pushing four genuinely mismatched types onto the same untyped `Stack` class with zero complaint.

3. **Does MRI/CRuby's GVL mean Ruby `Thread`s are useless?**
   Not useless, but limited to I/O-bound concurrency — the GVL ensures only one thread executes Ruby bytecode at a time, so CPU-bound work sees no real parallel speedup (measured directly in Lesson 14 at 0.97x for four CPU-bound threads on a 12-core machine). The GVL is released during blocking I/O, though, so threads genuinely help overlap I/O-bound work — also measured directly, at a real 3.21x speedup for four concurrent `sleep`-based operations.

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | Interpreted execution, no build step, `ruby`/`irb`/`gem` |
| 02 | [Syntax](02-Syntax/README.md) | No semicolons required, `end`-delimited blocks, everything-is-an-expression |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | Dynamic typing, `nil`, symbols, everything is an object |
| 04 | [Operators](04-Operators/README.md) | Operator overloading via `def +`, the spaceship operator `<=>`, `Comparable` |
| 05 | [Control Flow](05-Control-Flow/README.md) | `if`/`unless`, postfix conditionals, `case`/`when` via `===` |
| 06 | [Functions](06-Functions/README.md) | Methods, the block/Proc/lambda three-way split, `yield` |
| 07 | [Collections](07-Collections/README.md) | Array/Hash/Range, `Enumerable` (`map`/`select`/`reduce`/`group_by`) |
| 08 | [Strings](08-Strings/README.md) | Mutable strings (vs. Python's immutable), interpolation, heredocs |
| 09 | [Error Handling](09-Error-Handling/README.md) | `begin`/`rescue`/`ensure`/`raise`, custom exceptions, `retry` |
| 10 | [File Handling](10-File-Handling/README.md) | `File`/`IO`, genuinely built-in JSON (`require "json"`) |
| 11 | [OOP](11-OOP/README.md) | Classes, mixins (`include`/`extend`), `attr_accessor`, `method_missing` |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | Blocks/Procs/lambdas revisited, `Enumerable`, lambda composition |
| 13 | [Duck Typing](13-Duck-Typing/README.md) | No generics at all; duck typing + `respond_to?` as the alternative |
| 14 | [Threads and Fibers](14-Threads-and-Fibers/README.md) | `Thread`, the GVL (measured), `Fiber` cooperative concurrency |
| 15 | [Modules and Gems](15-Modules-and-Gems/README.md) | `require`/`require_relative`, RubyGems, Bundler/`Gemfile` |
| 16 | [Database Access](16-Database-Access/README.md) | `sqlite3` gem CRUD, parameterized queries vs. live SQL injection |
| 17 | [API Integration](17-API-Integration/README.md) | `Net::HTTP` (stdlib), no exception on 404 |
| 18 | [Testing](18-Testing/README.md) | Minitest (stdlib, no gem install needed) |
| 19 | [Best Practices](19-Best-Practices/README.md) | Naming conventions, `method_missing` overuse — reproduced live |
| 20 | [Exercises](20-Exercises/README.md) | 7 standalone problems: symbols/Hash validation, spaceship+Comparable, case/when dispatch, retry-with-backoff, Enumerable chaining, custom exception hierarchy, mixin+duck-typing capstone |
| 21 | [Solutions](21-Solutions/README.md) | Worked, verified solutions to all 20-Exercises problems |
| 22 | [Mini-Projects](22-Mini-Projects/README.md) | CLI Task Tracker — `sqlite3` persistence, Minitest suite |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md).

## Suggested Path

Work through 01 → 19 in order. Lessons 05, 06, and 07 have `Exercises`/`Solutions` pairs. Lesson 13 (Duck Typing) is worth reading closely even though Ruby has no generics — it explains the real, idiomatic alternative. Lesson 14's GVL benchmark is a genuinely measured result, not an assumed one, and takes about 3 minutes to run. After finishing the core course, [20-Exercises](20-Exercises/README.md)/[21-Solutions](21-Solutions/README.md) offer 7 further standalone problems spanning the whole course, and [22-Mini-Projects](22-Mini-Projects/README.md) is a complete CLI Task Tracker (`sqlite3` + Minitest) worth reading end-to-end as a real, if small, application.

Ruby is not one of the original 12 specified languages (Python through Dart) — it's an addition from the broader spec's remaining language list. **Previous language (in the original 12-language build order):** [Dart](../Dart/README.md), which remains the last language in that specific order; Ruby was built afterward as one of the additional languages (alongside C, Haskell, and others) from the fuller original spec.
