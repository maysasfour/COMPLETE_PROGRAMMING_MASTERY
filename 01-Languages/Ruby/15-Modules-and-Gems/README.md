# 15 — Modules and Gems

[Back to course overview](../README.md) | [Previous: Threads and Fibers](../14-Threads-and-Fibers/README.md)

## Learning Objectives

- Use `require` (standard-library/installed-gem loading) vs. `require_relative` (path-relative-to-this-file loading).
- Understand RubyGems (`gem`) as Ruby's bundled package manager.
- Understand a `Gemfile`/Bundler conceptually as Ruby's dependency-manifest/lockfile mechanism.

## Prerequisites

[14-Threads-and-Fibers](../14-Threads-and-Fibers/README.md)

## Concept

`require "name"` loads a standard-library file or an installed gem by name, searched via `$LOAD_PATH`. `require_relative "./path"` instead resolves relative to the *file calling it*, not the process's current working directory — this means `ruby example.rb` behaves identically regardless of which directory it's actually invoked from, a real, practical difference from a plain `require "./helper"` (which depends on the working directory at the time the process was launched).

**RubyGems** (`gem`) is Ruby's bundled package manager (confirmed working in Lesson 01, and used for real to install the `sqlite3` gem for Lessons 16 and 22). **Bundler** (a `Gemfile` + `bundle install`, generating a `Gemfile.lock`) is the layer on top that pins exact, mutually-compatible dependency versions for reproducible installs across machines — Ruby's equivalent of npm's `package.json`/`package-lock.json` or PHP's `composer.json`/`composer.lock`.

## Detailed Example

See [example.rb](example.rb) (loading a sibling [helper.rb](helper.rb) via `require_relative`, plus stdlib `json` via plain `require`), and [Gemfile](Gemfile) — a real, minimal Bundler manifest declaring the exact gems (`sqlite3`, `minitest`) this course actually depends on for later lessons.

## Run It

```bash
cd 01-Languages/Ruby/15-Modules-and-Gems
ruby example.rb
```

## Expected Output (real, captured)

```
LOADED VIA REQUIRE_RELATIVE!
{"ok":true}
Gem.loaded_specs includes 'json'? true
RubyGems version: 3.6.9
# A minimal Bundler Gemfile -- Ruby's equivalent of package.json/composer.json.
# `bundle install` reads this, resolves compatible versions of every
# dependency (and their own transitive dependencies), and writes the exact
# resolved set to Gemfile.lock for reproducible installs on any machine.
source "https://rubygems.org"

gem "sqlite3", "~> 2.9"   # used later in this course, Lessons 16 and 22
gem "minitest", "~> 5.25"  # Ruby's built-in-to-the-ecosystem test framework, Lesson 18
```

## Common Mistakes

- Using plain `require "./helper"` instead of `require_relative "helper"` — the former depends on the process's current working directory at launch time, so the exact same script can work or fail to find its own sibling file depending on where it was run from; `require_relative` always resolves relative to the requiring file itself.
- Requiring the same file twice expecting it to run twice — both `require` and `require_relative` only load a given file once per process (tracked internally), a real and often-relied-upon behavior.
- Installing a gem globally (`gem install`) instead of scoping it via a project's `Gemfile`/Bundler — fine for quick experiments (as this course does directly with `sqlite3` for simplicity), but real projects should pin versions via Bundler for reproducibility across machines/teammates.

## Best Practices

- Use `require_relative` for a project's own sibling files; reserve plain `require` for standard-library and installed-gem loading.
- Maintain a `Gemfile` (and commit its generated `Gemfile.lock`) for any real, multi-dependency project, so every install resolves to the identical set of gem versions.
- Keep gem version constraints (`~> 2.9`) permissive enough to receive patch/minor updates but pinned enough to avoid an unexpected breaking major-version bump.

## Real-World Usage

Every real Ruby project (Rails apps, gems themselves) ships a `Gemfile`/`Gemfile.lock`; `require_relative` is the standard way any multi-file Ruby project (including this course's own Lesson 22 mini-project) wires its own files together.

## Summary

- `require` loads stdlib/gems by name; `require_relative` loads a sibling file relative to the requiring file's own path, not the working directory.
- RubyGems (`gem`) is Ruby's bundled package manager; Bundler (`Gemfile`/`Gemfile.lock`) pins exact, reproducible dependency versions on top of it.

## Key Terms

- **`require_relative`** — loads a file relative to the *calling file's* location, independent of the process's working directory.
- **Bundler** — the dependency-resolution/locking layer built on RubyGems, driven by a `Gemfile`.

## Interview Questions

1. **What's the practical difference between `require` and `require_relative`?**
   `require "name"` searches `$LOAD_PATH` for a standard-library file or installed gem by name; `require_relative "path"` resolves the path relative to the *file that calls it*, regardless of the process's current working directory at launch — meaning a multi-file script wired together with `require_relative` behaves identically no matter where `ruby` is invoked from, unlike a plain `require "./sibling"`.

2. **What problem does a `Gemfile`/Bundler solve that plain `gem install` doesn't?**
   Plain `gem install` installs whatever the latest (or explicitly requested) version happens to be at that moment, with no record of what a given project actually needs. A `Gemfile` declares every dependency with a version constraint, and `bundle install` resolves a single mutually-compatible set of exact versions (including transitive dependencies), recording it in `Gemfile.lock` — so any teammate or deployment target running `bundle install` gets the *identical* dependency versions, not just "whatever's newest right now."

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
