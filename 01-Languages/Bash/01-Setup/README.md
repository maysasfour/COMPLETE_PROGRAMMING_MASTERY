# 01 — Setup

[Back to Bash course](../README.md)

## Beginner: The Shebang Line

Every executable Bash script starts with a shebang — a comment line that tells the OS which interpreter to use when the script is run directly:

```bash
#!/usr/bin/env bash
echo "Hello, Bash!"
```

`#!/usr/bin/env bash` finds `bash` on the current `$PATH`, which is more portable across systems than hardcoding `#!/bin/bash` (some systems keep Bash elsewhere). The shebang only matters when you execute the file directly (`./script.sh`); it is ignored if you run `bash script.sh` explicitly.

## Three Ways to Run a Script — Verified Live

```bash
$ bash --version | head -1
GNU bash, version 5.2.37(1)-release (x86_64-pc-msys)

$ chmod +x hello.sh
$ ./hello.sh
Hello, Bash!

$ bash hello.sh
Hello, Bash!

$ sh hello.sh
Hello, Bash!
```

All three produced identical output here because this environment's `sh` is also Bash-compatible, but they are not always equivalent:

- **`./hello.sh`** — the kernel reads the shebang and execs the named interpreter. Requires the execute bit (`chmod +x`) and requires the file to actually be at that path.
- **`bash hello.sh`** — explicitly invokes Bash on the file. Does **not** require the execute bit at all, since you're not asking the OS to run the file as a program — you're asking `bash` to read it as input.
- **`sh hello.sh`** — invokes whatever `/bin/sh` is symlinked to on this system (often `dash` on Debian/Ubuntu, which is stricter POSIX and does NOT support Bash-only features like arrays or `[[ ]]`). Never assume `sh` behaves like `bash`.

## `chmod +x` in Practice

```bash
$ ls -la hello.sh
-rwxr-xr-x 1 HP 197121 40 Jul 19 13:22 hello.sh
```

The `x` bits (`rwx`) mean the file is now executable by owner, group, and others. Before `chmod +x`, `./hello.sh` fails with a permission error even though `bash hello.sh` would still work — this trips up beginners constantly.

## Common Beginner Mistakes

- Forgetting `chmod +x` and being confused why `bash script.sh` works but `./script.sh` doesn't.
- Assuming `sh` and `bash` are the same program — `sh` may reject Bash-specific syntax like `[[ ]]` or arrays.
- Putting the shebang anywhere other than the very first line/first two characters of the file (a leading blank line breaks it).

## Best Practices

- Always use `#!/usr/bin/env bash` for portability.
- `chmod +x` any script meant to be run as a standalone program.
- Keep a `.sh` extension for discoverability even though Bash itself doesn't require it.

## Interview Questions

1. What's the difference between `./script.sh` and `bash script.sh` in terms of what the OS/interpreter does?
2. Why is `#!/usr/bin/env bash` generally preferred over `#!/bin/bash`?
3. Why might a script that works with `bash script.sh` fail with `sh script.sh`?
