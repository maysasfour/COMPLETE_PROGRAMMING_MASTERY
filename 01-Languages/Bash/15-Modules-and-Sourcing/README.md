# 15 — Modules and Sourcing

[Back to Bash course](../README.md)

## Beginner: `source` (or `.`) — Verified Live

Bash has no `import`/`require` system in the sense of a module namespace — the closest equivalent is **sourcing** another script, which literally executes its contents in the *current* shell (as opposed to running it as a separate process the way `./script.sh` or `bash script.sh` would):

```bash
$ cat mathlib.sh
square() { echo $(( $1 * $1 )); }
PI="3.14159"

$ cat usemath.sh
#!/usr/bin/env bash
source ./mathlib.sh
echo "PI=$PI"
echo "square of 6 = $(square 6)"

$ bash usemath.sh
PI=3.14159
square of 6 = 36
```

After `source ./mathlib.sh`, the `square` function and `PI` variable defined in `mathlib.sh` become directly available in `usemath.sh`'s own shell environment — as if their definitions had been typed inline. `.  ./mathlib.sh` (a single dot) is a POSIX-portable synonym for `source`.

## Sourcing vs. Executing

| | `source ./lib.sh` | `bash ./lib.sh` / `./lib.sh` |
|---|---|---|
| Runs in | current shell process | new child process |
| Variables/functions defined | persist in the caller afterward | disappear when the child exits |
| Use case | libraries of shared functions/constants | standalone scripts/programs |

## Honest Limitation: No Real Package Manager

Every other language course in this repository has a package manager (`pip`, `gem`, `npm`, `cargo`, `go get`, ...) for pulling in third-party, versioned code. Bash has **none** of its own. In practice, Bash "dependency management" means:

- Manually vendoring/copying `.sh` files into the project and `source`-ing them directly (as shown above).
- Relying on system package managers (`apt`, `brew`, `choco`) to install *external CLI tools* the script shells out to (`jq`, `curl`, `sqlite3`) — but that installs a program, not a Bash library, and there's no manifest file or lockfile equivalent tracking those dependencies' versions the way `requirements.txt`/`package.json`/`Gemfile` do.
- A handful of community conventions exist (e.g., `bash-it`, informal "framework" repos to `git clone` and `source`), but none is a de facto standard the way `npm`/`pip` is for their respective languages.

## Common Beginner Mistakes

- Using `bash ./lib.sh` instead of `source ./lib.sh` and being confused why the library's functions aren't available afterward.
- Sourcing a script that itself calls `exit` — since sourcing runs in the *current* shell, an `exit` inside the sourced file will exit the calling shell/script too, not just "return" from the library.
- Assuming there's a standard place Bash looks for "modules" analogous to `node_modules` or a Python package path — there isn't; sourcing always uses an explicit path.

## Best Practices

- Keep sourced library files free of top-level `exit` calls (use `return` at top-level scope in a sourced file if you need to short-circuit it).
- Use relative paths carefully when sourcing — `source ./lib.sh` depends on the *current working directory* at the time the sourcing script runs, not the sourcing script's own location; use `source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"` for a path relative to the script itself.
- Document any external CLI tool dependencies (`jq`, `sqlite3`, `curl`) explicitly in a README, since there's no manifest file to encode them.

## Interview Questions

1. What's the practical difference between `source lib.sh` and `bash lib.sh`?
2. Why can an `exit` inside a sourced file be dangerous?
3. What does Bash use instead of a package manager, and what are the practical limits of that approach?
