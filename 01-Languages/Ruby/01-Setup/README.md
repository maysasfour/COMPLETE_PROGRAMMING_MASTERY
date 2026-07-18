# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Understand that Ruby is interpreted with no build step: `ruby file.rb` parses and runs the file directly.
- Know the three core CLI tools: `ruby` (the interpreter), `irb` (the interactive REPL), and `gem` (RubyGems, the bundled package manager).
- Confirm the exact toolchain version this course was verified against.

## Prerequisites

None — this is the first lesson.

## Concept

Ruby (like Python, JavaScript, and PHP elsewhere in this repository) has no compile step. `ruby example.rb` reads the source file and executes it top to bottom in one pass; there is no `.exe`/`.class`/`.o` artifact left behind afterward. This makes the edit-run loop immediate, at the cost of catching type/syntax errors only at run time rather than at a separate compile stage.

Three tools ship together in a standard Ruby install:

- **`ruby`** — the interpreter itself. `ruby script.rb` runs a file; `ruby -e '...'` runs a one-liner.
- **`irb`** ("Interactive Ruby") — a REPL for typing expressions one at a time and seeing results immediately, Ruby's equivalent of Python's `python` prompt or Node's `node` prompt.
- **`gem`** — RubyGems, Ruby's bundled package manager, used to install third-party libraries ("gems") such as the `sqlite3` gem used later in this course (Lessons 16 and 22).

## How to Install

Windows has no system Ruby by default. This course used a portable RubyInstaller build extracted to a non-system-wide location rather than a machine-wide install:

```bash
# Downloaded via choco's cached package (a portable RubyInstaller .exe), then
# installed silently to an isolated directory instead of Program Files:
rubyinstaller-3.4.10-1-x64.exe /verysilent /dir="C:\Users\HP\tools\Ruby34" /tasks="" /norestart

# Add to PATH for the current shell only (not persisted system-wide):
export PATH="/c/Users/HP/tools/Ruby34/bin:$PATH"
ruby -v
```

This mirrors the repository's established pattern (see the Go, Rust, PHP, and Kotlin courses) of downloading toolchains into an isolated, per-project location rather than a persistent system-wide install.

## Detailed Example

See [example.rb](example.rb) — prints the interpreter version, platform, engine, and RubyGems version, confirming the toolchain that every other lesson in this course was run against.

## Run It

```bash
cd 01-Languages/Ruby/01-Setup
ruby example.rb
```

## Expected Output (real, captured)

```
RUBY_VERSION:    3.4.10
RUBY_PLATFORM:   x64-mingw-ucrt
RUBY_ENGINE:     ruby
__FILE__:        example.rb
RubyGems ver:    3.6.9
2 + 2 = 4
```

This is the exact toolchain (Ruby 3.4.10, x64-mingw-ucrt, RubyGems 3.6.9) every subsequent lesson in this course was actually executed against.

## Common Mistakes

- Expecting a `.rbc`/build artifact after running a script — there isn't one; Ruby re-parses the source every run.
- Assuming `irb` and `ruby script.rb` behave identically — `irb` auto-prints every expression's return value; a plain script only prints what you explicitly `puts`/`print`.
- Forgetting that on a fresh Windows machine, neither `ruby` nor `gem` exists on `PATH` until an interpreter is actually installed — unlike Python, which recent Windows versions sometimes stub via the Microsoft Store.

## Best Practices

- Pin down and record the exact Ruby version a project needs (a `.ruby-version` file, covered conceptually in Lesson 15) since Ruby's standard library and syntax do evolve across major versions.
- Use `irb` for quick one-off experiments; use real `.rb` files (run via `ruby`) for anything meant to be reused or tested.

## Real-World Usage

Every Ruby web framework (Rails), tool (Jekyll, Homebrew's own installer scripts), and gem you will ever install depends on exactly this triad — a `ruby` interpreter, `gem`/Bundler for dependencies, and no separate build step for plain Ruby code.

## Summary

- Ruby is interpreted, not compiled: `ruby file.rb` runs the file directly, no build artifacts.
- `irb` is the REPL, `gem` is the package manager, both ship with every Ruby install.
- This course was verified against Ruby 3.4.10 (x64-mingw-ucrt), installed portably rather than system-wide.

## Key Terms

- **MRI/CRuby** — the reference C implementation of Ruby (`RUBY_ENGINE == "ruby"`), what this course uses; alternatives include JRuby and TruffleRuby.
- **RubyGems** — Ruby's bundled package manager, invoked as `gem`.

## Interview Questions

1. **Does Ruby have a compile step like Java or C#?**
   No. `ruby file.rb` interprets the source directly on every run; there's no separate compilation phase or build artifact, the same trade-off Python and PHP make elsewhere in this repository — faster iteration, but errors (including simple typos in rarely-executed branches) only surface at run time.

2. **What is the difference between `ruby`, `irb`, and `gem`?**
   `ruby` is the interpreter that executes `.rb` files or `-e` one-liners; `irb` is an interactive REPL for typing and immediately evaluating Ruby expressions one at a time; `gem` is RubyGems, the bundled package manager used to install and manage third-party libraries.

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
