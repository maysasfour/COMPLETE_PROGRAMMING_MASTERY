# 15 — Modules

[Back to course overview](../README.md) | [Previous: Laziness and Concurrency](../14-Laziness-and-Concurrency/README.md)

## Learning Objectives

- Declare a `module` and use `import` to bring names into scope, including qualified and selective imports.
- Understand Cabal (and Stack) conceptually as Haskell's package/project management layer, extending Lesson 01's single-file `ghc`/`runghc` story to real multi-file projects with dependencies.
- Build and run a genuine multi-file, multi-module program with `ghc`.

## Prerequisites

[14-Laziness-and-Concurrency](../14-Laziness-and-Concurrency/README.md)

## Concept: `module` and `import`

Every `.hs` file this course has written so far has been an implicit `Main` module (GHC assumes this when no `module` line is given and the file has a `main`). A real multi-file program names its modules explicitly and exports only what it intends to be public:

```haskell
-- File: MathUtils.hs
module MathUtils
  ( add          -- explicit EXPORT list -- only these names are visible to importers
  , multiply
  ) where

add :: Int -> Int -> Int
add x y = x + y

multiply :: Int -> Int -> Int
multiply x y = x * y

helperNotExported :: Int -> Int    -- NOT in the export list -- invisible outside this module
helperNotExported x = x + 1
```

```haskell
-- File: Main.hs
import MathUtils (add, multiply)     -- selective import -- only bring in what's named

main :: IO ()
main = do
    print (add 2 3)
    print (multiply 2 3)
```

## Qualified Imports

```haskell
import qualified Data.Map as Map     -- must write Map.lookup, Map.insert, etc.
import Data.List (sort)              -- unqualified, selective -- just `sort` directly
```

Qualified imports (`import qualified X as Y`) are the idiomatic way to avoid name clashes between modules that export functions with the same name (e.g., both `Data.Map` and `Prelude` have a function called `lookup` with different signatures) — a real, common pattern any time a module with generically-named functions (`Map`, `Set`, `Text`) is imported.

## Detailed Example

See [MathUtils.hs](MathUtils.hs) and [Main.hs](Main.hs) — a genuine two-file, two-module program, compiled together.

## Verified Output

```bash
$ ghc -o modules_demo Main.hs MathUtils.hs
[1 of 3] Compiling MathUtils        ( MathUtils.hs, MathUtils.o )
[2 of 3] Compiling Main             ( Main.hs, Main.o )
[3 of 3] Linking modules_demo.exe
$ ./modules_demo.exe
add 2 3 = 5
multiply 2 3 = 6
sorted [3,1,2] = [1,2,3]
Map lookup "b" = Just 2
```

## Cabal and Stack — Conceptually, and Genuinely Used

**Cabal** and **Stack** are Haskell's two mainstream project/package management tools — roughly analogous to Rust's Cargo or Node's npm, in that both declare a project's dependencies and orchestrate building against them. This course actually uses real Cabal projects starting here where dependencies are genuinely needed: [16-Database-Access](../16-Database-Access/README.md) (`sqlite-simple`), [17-API-Integration](../17-API-Integration/README.md) (an HTTP client package, if genuinely available in this environment — see that lesson's honesty note), [18-Testing](../18-Testing/README.md), and [22-Mini-Projects](../22-Mini-Projects/README.md) — exactly parallel to how the Rust course uses plain `rustc` for most lessons and switches to a real `Cargo.toml` project only where a crate dependency is actually needed.

A minimal Cabal project looks like:

```
my-project/
  my-project.cabal      -- declares name, dependencies, executable/library stanzas
  app/
    Main.hs
  src/
    MyLibrary.hs
```

```
# my-project.cabal (abbreviated)
cabal-version:      2.4
name:                my-project
version:             0.1.0.0
build-type:          Simple

executable my-project
    main-is:          Main.hs
    hs-source-dirs:   app
    build-depends:    base, sqlite-simple
    default-language: Haskell2010
```

```bash
cabal build      # resolve dependencies, compile
cabal run        # build (if needed) and run
cabal test       # run the test suite stanza, if one is declared
```

## Common Mistakes

- **Forgetting an export list means "export everything"** — a `module Foo where` with no explicit `( ... )` list exports every top-level name, which can leak implementation details never meant to be public; an explicit export list is the deliberate, idiomatic choice.
- **Name clashes from two unqualified imports both exporting the same name** (e.g., `Prelude`'s `lookup` vs. `Data.Map`'s `lookup`) — a genuine, common compile error (`Ambiguous occurrence`); qualified imports (`import qualified Data.Map as Map`) are the standard fix.
- **Compiling only one file of a multi-module program** — `ghc Main.hs` alone, when `Main.hs` imports `MathUtils`, needs `MathUtils.hs` findable (either passed explicitly, as in this lesson's example, or discoverable via GHC's module search path) or it fails with a "Could not find module" error.

## Best Practices

- Always write an explicit export list for a module meant to be imported elsewhere — it documents the module's public API directly in code, checked by the compiler.
- Use qualified imports for any module (`Data.Map`, `Data.Set`, `Data.Text`) whose function names are likely to clash with `Prelude` or with each other.
- Reach for a real Cabal (or Stack) project the moment a program needs an external dependency or spans more than one or two files — matching exactly the point where this course itself switches from single-file `ghc`/`runghc` invocations to real Cabal projects.

## Real-World Usage

Every real, non-trivial Haskell project uses Cabal or Stack, with explicit module export lists forming the project's actual public API boundary — this is directly analogous to how every other language course in this repository eventually needs its language's own package manager (Cargo, npm, pip, Maven) the moment a project grows past a single file or needs a third-party dependency.

## Summary

- `module Name (exports) where` declares a module and its public API; `import`/`import qualified`/selective imports bring names from other modules into scope.
- Qualified imports (`import qualified X as Y`) avoid name clashes between modules exporting identically-named functions.
- Cabal/Stack are Haskell's project/package managers — this course uses real Cabal projects starting exactly where genuine dependencies are needed (Lessons 16–18, 22), matching the single-file-until-actually-needed pattern already established by this repository's Rust course.

## Key Terms

- **Module** — a named unit of Haskell code with an explicit (or implicit, exports-everything) public API, declared via `module Name (...) where`.
- **Qualified import** — `import qualified X as Y`, requiring `Y.name` at use sites, avoiding name clashes.
- **Cabal/Stack** — Haskell's mainstream project/dependency management tools, roughly analogous to Cargo/npm/Maven in other language ecosystems.

## Interview Questions

1. **What happens if a module declaration has no explicit export list, and why is that usually undesirable?**
   `module Foo where` with no `( ... )` list exports every top-level binding in the module as part of its public API — including internal helper functions never meant to be used elsewhere. This can leak implementation details and make refactoring riskier (any exported name is potentially depended on by importers). An explicit export list (`module Foo (publicFn1, publicFn2) where`) is the idiomatic choice, documenting the module's actual intended public surface directly in code.

2. **When would you use a qualified import instead of a plain one?**
   Whenever a module's exported names are likely to clash with `Prelude` or another already-imported module's names — `Data.Map`'s `lookup`/`insert`/`filter` all shadow `Prelude` functions of the same name, for instance. `import qualified Data.Map as Map` requires writing `Map.lookup` at every use site, resolving the ambiguity explicitly rather than relying on GHC to guess (which it won't — an unqualified clash is a compile error, not a silent pick).

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
