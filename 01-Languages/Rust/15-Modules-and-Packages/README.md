# 15 — Modules and Packages

[Back to course overview](../README.md) | [Previous: Async and Concurrency](../14-Async-and-Concurrency/README.md)

## Learning Objectives

- Use `mod` to organize code into modules, and `pub` to control visibility (like Go's capitalization rule, but an explicit keyword instead).
- Understand a Rust **crate** (a compilation unit) vs. a **package** (one or more crates, described by `Cargo.toml`).
- Use `cargo` for real multi-file projects, dependencies, and builds.

## Prerequisites

[14-Async-and-Concurrency](../14-Async-and-Concurrency/README.md)

## Concept

A Rust **crate** is the compiler's actual unit of compilation (a binary or a library); a **package** is one or more crates plus a `Cargo.toml` manifest describing them and their dependencies — roughly analogous to a Go module containing multiple packages, or an npm package. Within a crate, `mod` declares modules (which can be separate files, like `mathutils.rs`, or inline blocks), and `pub` explicitly marks items as visible outside their module — Rust's equivalent of Go's capitalization convention, but as an explicit keyword rather than a naming rule.

## `mod` and `pub`

```rust
// src/mathutils.rs
pub fn add(a: i32, b: i32) -> i32 { a + b } // pub -- visible outside this module
fn internal_helper() -> i32 { 42 }           // no pub -- private to this module
```

```rust
// src/main.rs
mod mathutils; // brings src/mathutils.rs into the crate as the `mathutils` module

fn main() {
    println!("{}", mathutils::add(2, 3)); // fine -- add is pub
    // mathutils::internal_helper(); // would fail to COMPILE -- private
}
```

## Crates vs. Packages, and `Cargo.toml`

```toml
[package]
name = "modulesdemo"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = "1.0" # a real dependency would be declared here
```

```bash
cargo new my_project    # scaffolds a new package
cargo build               # compiles
cargo run                  # compiles and runs
cargo add some_crate        # adds a dependency, updating Cargo.toml/Cargo.lock
```

Like Go's `go.mod`/`go.sum`, **`Cargo.toml`/`Cargo.lock` are meant to be committed** — small text files declaring the package's identity and exact dependency versions, not the dependency code itself (which lives in Cargo's shared registry cache, downloaded on demand). The `target/` build output directory, by contrast, is never committed (analogous to `node_modules`/Go's `go build` output).

## Detailed Example

See [Cargo.toml](Cargo.toml), [src/main.rs](src/main.rs), and [src/mathutils.rs](src/mathutils.rs) — a genuine multi-file Cargo package with a module split across files and explicit `pub` visibility control.

## Run It

```bash
cd 01-Languages/Rust/15-Modules-and-Packages
cargo run
```

## Expected Output

Running `cargo run` prints results from `mathutils::add`/`multiply`/`uses_internal_helper` — functions defined in a separate module file, with `pub` explicitly controlling what's visible from `main.rs`.

## Common Mistakes

- Forgetting `pub` on an item meant to be used from another module — Rust defaults to **private** visibility, the opposite of some languages' "everything visible unless marked otherwise" default.
- Confusing a crate (the compilation unit) with a package (the `Cargo.toml`-described unit that can contain multiple crates, e.g., a library crate plus a binary crate).
- Committing the `target/` directory — like `node_modules`/Go's build output, it's regenerated and should be excluded from version control.

## Best Practices

- Default to private (no `pub`) and only expose what genuinely needs to be part of a module's public API.
- Commit `Cargo.toml`/`Cargo.lock`; exclude `target/`.
- Use `cargo add`/`cargo remove` to manage dependencies rather than hand-editing `Cargo.toml`'s version strings, letting Cargo resolve compatible versions.

## Real-World Usage

Every real Rust project uses Cargo; the crate/package/module structure scales from a single-file binary crate (as used in most of this course's lessons) up to large workspaces with many interdependent crates, all managed through the same `Cargo.toml`/`cargo` tooling.

## Summary

- A crate is the compiler's unit of compilation; a package (described by `Cargo.toml`) can contain multiple crates.
- `mod` organizes code into modules (files or inline blocks); `pub` explicitly controls visibility, defaulting to private.
- `Cargo.toml`/`Cargo.lock` are meant to be committed; `target/` (build output) is not.

## Key Terms

- **Crate** — Rust's actual compilation unit (a binary or library).
- **Package** — one or more crates plus a `Cargo.toml` manifest.
- **`pub`** — the keyword marking an item as visible outside its module; the default is private.

## Interview Questions

1. **What's the difference between a Rust crate and a package?**
   A crate is the compiler's actual unit of compilation — either a binary crate (produces an executable) or a library crate (produces a reusable library). A package is a higher-level concept: one or more crates plus a `Cargo.toml` manifest describing the package's identity, version, and dependencies. A package commonly contains exactly one library crate and/or one binary crate, though it can contain more in larger setups (a Cargo "workspace").

2. **What is the default visibility of an item in a Rust module, and how do you change it?**
   Private — an item (function, struct, field, etc.) is visible only within its own module and any child modules by default. The `pub` keyword explicitly makes an item visible outside its module (to whatever the surrounding visibility rules allow, e.g., the whole crate or genuinely public if the crate is published). This is the opposite default from some languages, and a more explicit mechanism than Go's capitalization-based rule.

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
