# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Understand the three ways to run Haskell code: `runghc` (interpret a script directly), `ghci` (interactive REPL), and `ghc` (compile to a native binary).
- Get a working GHC toolchain installed and verified in this exact environment.
- Run a first `.hs` file all three ways and compare the output.

## Prerequisites

None — this is the first lesson in the course.

## Concept

GHC (the **G**lasgow **H**askell **C**ompiler) is the reference Haskell implementation and the one this entire course is verified against. Unlike Python (interpreter only) or C (compiler only), GHC genuinely gives you three distinct ways to execute the same source file, and this lesson exercises all three so later lessons can freely say "run it with `runghc`" without re-explaining:

- **`runghc file.hs`** — compiles to bytecode in memory and runs it immediately, no `.exe`/`.hi`/`.o` files left behind. Closest to `python file.py` — good for quick iteration.
- **`ghci`** — an interactive REPL (**G**lasgow **H**askell **C**ompiler **I**nteractive). Load a file with `:load file.hs` (or `:l file.hs`), then call its functions directly, inspect types with `:t expr`, and reload after edits with `:r`. This is where most real Haskell development happens day to day.
- **`ghc file.hs -o file`** — compiles all the way to a native, standalone executable (`.exe` on Windows), plus intermediate `.hi` (interface) and `.o` (object) files. This is the only path that produces something you can ship and run without GHC installed on the target machine.

## How This Environment Was Set Up (Honestly Documented)

This course was built and verified on a Windows 11 machine that had **no GHC, Cabal, or Stack pre-installed** (`ghc --version`, `where ghc`, `where stack`, and `where cabal` all failed at the start of this session). Two installation paths were tried:

1. **Chocolatey (`choco install ghc`)** — this exists as a package (GHC 9.8.2, depending on a `cabal` package) but **failed in this environment**: the portable Chocolatey install here has no admin rights, and the `cabal` package's install script calls a cmdlet (`Test-ProcessAdminRights`) that isn't available in this non-elevated Chocolatey session, so `cabal`'s package install script errored out and `ghc` was skipped as a result ("Failed to install ghc because a previous dependency failed"). This is a real, reproduced failure, not a guess — see the raw Chocolatey log if reproducing.
2. **Direct GHC bindist download (what actually worked)** — GHC publishes plain, self-contained `.tar.xz` archives for Windows at `https://downloads.haskell.org/~ghc/<version>/ghc-<version>-x86_64-unknown-mingw32.tar.xz`, needing no installer/admin rights at all — you just extract it. This course was verified against **GHC 9.8.2**, extracted to `C:\Users\HP\tools\ghc-9.8.2-x86_64-unknown-mingw32\`. `cabal-install` (needed later for Lessons 16–18) was obtained the same way, as a standalone `.zip` of `cabal.exe` from `https://downloads.haskell.org/cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-x86_64-windows.zip`, extracted to `C:\Users\HP\tools\cabal-install\`.

```bash
# What was actually run to set this environment up (Git Bash):
mkdir -p /c/Users/HP/tools
cd /c/Users/HP/tools
curl -L -o ghc.tar.xz "https://downloads.haskell.org/~ghc/9.8.2/ghc-9.8.2-x86_64-unknown-mingw32.tar.xz"
tar -xf ghc.tar.xz    # -> C:\Users\HP\tools\ghc-9.8.2-x86_64-unknown-mingw32\

mkdir -p /c/Users/HP/tools/cabal-install && cd /c/Users/HP/tools/cabal-install
curl -L -o cabal.zip "https://downloads.haskell.org/cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-x86_64-windows.zip"
unzip cabal.zip        # -> cabal.exe

# Then, per session, both were put on PATH:
export PATH="/c/Users/HP/tools/ghc-9.8.2-x86_64-unknown-mingw32/bin:/c/Users/HP/tools/cabal-install:$PATH"
```

**This is not a normal end-user install** (a real GHCup install, `https://www.haskell.org/ghcup/`, is the officially recommended path and manages GHC/Cabal/Stack versions for you) — it's a portable, no-admin-rights workaround specific to this environment, matching this repository's established pattern for other toolchains that couldn't use a normal system installer here (see `BUILD_STATUS.md` for the equivalent story with Maven, Terraform, and other tools). If you're setting this up yourself on a normal machine, **use GHCup instead** — it is the standard, actively maintained installer and handles this all for you.

## Verifying the Install

```bash
$ ghc --version
The Glorious Glasgow Haskell Compilation System, version 9.8.2

$ runghc --version
runghc 9.8.2

$ ghci --version
The Glorious Glasgow Haskell Compilation System, version 9.8.2

$ cabal --version
cabal-install version 3.10.2.0
compiled using version 3.10.2.1 of the Cabal library
```

All four commands above were actually run in this environment and produced exactly this output.

## Detailed Example

See [hello.hs](hello.hs) — a trivial `main :: IO ()` program run all three ways.

## Verified Output

```bash
$ runghc hello.hs
Hello, Haskell!

$ ghc -o hello hello.hs
[1 of 2] Compiling Main             ( hello.hs, hello.o )
[2 of 2] Linking hello.exe
$ ./hello.exe
Hello, Haskell!
```

(`ghci` usage is shown interactively below since it doesn't fit a single non-interactive command line.)

```
$ ghci hello.hs
GHCi, version 9.8.2: https://www.haskell.org/ghc/  :? for help
[1 of 1] Compiling Main             ( hello.hs, interpreted )
Ok, one module loaded.
ghci> main
Hello, Haskell!
ghci> 2 + 2
4
ghci> :type main
main :: IO ()
ghci> :quit
Leaving GHCi.
```

## Common Mistakes

- **Expecting a `.hs` file to "just run" like a shell script** — you must invoke it through `runghc`, `ghci`, or compile it first with `ghc`; there's no shebang-based direct execution convention as universal as Python's.
- **Forgetting `ghc` leaves build artifacts behind** (`.hi`, `.o`, and the executable itself) in the same directory — `runghc` is cleaner for quick iteration precisely because it leaves nothing on disk.
- **Confusing `ghci`'s `:load`/`:l` (loads a file's definitions into the REPL) with actually running the file** — after `:load`, you still have to call `main` yourself if you want the `IO` action to execute; loading alone just makes the names available.

## Best Practices

- Use `ghci` for exploration and quick "what's the type of this?" checks (`:t`) during development — this is genuinely how most Haskell programmers iterate day to day, more like a Python/Node REPL workflow than a typical Java/C++ compile-edit-run loop.
- Use `runghc` for quick "does this whole file work end to end" checks without leaving build artifacts around.
- Use `ghc` (or a build tool like Cabal/Stack, which wrap `ghc` and manage dependencies) only when you actually need a standalone binary to ship or benchmark.
- Prefer a real [GHCup](https://www.haskell.org/ghcup/) install for your own machine — it manages multiple GHC/Cabal/Stack versions cleanly, unlike this course's one-off portable workaround.

## Real-World Usage

Production Haskell projects almost always use **Stack** or **Cabal** (with a `.cabal`/`package.yaml` file declaring dependencies) rather than invoking `ghc` directly on a single file — this course starts with single-file `ghc`/`runghc` invocations (Lessons 01–15, matching the style of every other single-file language course in this repository) and switches to a real Cabal project structure specifically where it's needed (Lessons 16–18 for dependencies, 22 for the mini-project), exactly parallel to how the Rust course uses plain `rustc` for most lessons and a real `Cargo.toml` project only where a crate dependency is genuinely needed.

## Summary

- `runghc` interprets a script directly, no artifacts left behind.
- `ghci` is the interactive REPL — load files, call functions, inspect types live.
- `ghc` compiles to a real, standalone native executable, leaving `.hi`/`.o` artifacts and the binary itself.
- This environment's GHC 9.8.2 + Cabal 3.10.2 were installed via direct, no-admin-rights bindist downloads after Chocolatey's own `ghc`/`cabal` packages genuinely failed here — a documented, reproducible workaround, not the officially recommended path (use GHCup on a normal machine).

## Key Terms

- **GHC** — the Glasgow Haskell Compiler, the reference Haskell implementation this course is verified against.
- **GHCi** — GHC's interactive REPL.
- **`runghc`** — runs a `.hs` file directly via GHC's bytecode interpreter, no artifacts.
- **Bindist** — a pre-built "binary distribution" archive, ready to extract and run without compiling GHC itself from source.

## Interview Questions

1. **What are the three ways to execute a Haskell source file with GHC, and when would you use each?**
   `runghc file.hs` interprets it directly with no build artifacts, best for quick one-off checks. `ghci` is the interactive REPL, best for exploration, type-checking expressions (`:t`), and iterative development. `ghc file.hs -o file` compiles to a standalone native executable, the only option that produces something shippable/runnable without GHC installed.

2. **What's the difference between GHC and GHCup?**
   GHC is the compiler itself. GHCup is a separate installer/version-manager tool (conceptually like `rustup` for Rust, or `nvm` for Node) that downloads, installs, and lets you switch between multiple GHC/Cabal/Stack versions. This course's environment used a direct bindist download instead of GHCup specifically because a normal admin-rights install path wasn't available here — GHCup remains the officially recommended route on a normal machine.

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
