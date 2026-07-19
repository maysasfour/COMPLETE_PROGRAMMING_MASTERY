# 03 — Variables and Data Types

[Back to Bash course](../README.md)

## Beginner: Everything Is Fundamentally a String

Bash has no real type system. Every variable's value is stored as text; Bash only *reinterprets* that text as a number when you use it in an arithmetic context (`$(( ))`). There's no `int`, `float`, `bool`, or `string` declaration.

```bash
$ num=5
$ num="now a string"
$ echo "$num"
now a string
```

The same variable held something that looked like a number and then held arbitrary text with no error or warning — Bash never enforced a type on `num` in the first place.

## `$VAR` vs `${VAR}` — Verified Live

```bash
$ name="World"
$ echo "Hello, $name"
Hello, World
$ echo "Hello, ${name}!"
Hello, World!
```

`${name}` is identical to `$name` when the variable name is unambiguous, but the braces are **required** when concatenating directly against more identifier-like characters — `"Hello, $name!"` works fine (`!` isn't part of a variable name), but something like `"${name}s"` needs braces because `$names` would otherwise be parsed as a single (different, and here undefined) variable name.

## Shell Variables vs. Environment Variables — Verified Live

A plain assignment (`VAR=value`) creates a *shell* variable, visible only in the current shell — it is **not** inherited by child processes (subshells, scripts you invoke, `bash -c`) unless explicitly exported with `export`:

```bash
$ export GLOBAL_VAR="visible to children"
$ bash -c 'echo "child sees: $GLOBAL_VAR"'
child sees: visible to children

$ LOCAL_ONLY="not exported"
$ bash -c 'echo "child sees local: [$LOCAL_ONLY]"'
child sees local: []
```

`GLOBAL_VAR` was exported and the child `bash -c` process could see it; `LOCAL_ONLY` was never exported and the child saw an empty string — the two subprocesses do not share a variable table with the parent shell by default.

## Common Beginner Mistakes

- Writing `num = 5` (with spaces around `=`) — Bash parses this as running a command called `num` with arguments `=` and `5`, not an assignment. Assignment must be `num=5`, no spaces.
- Expecting a variable to automatically be visible to a script you call (`./child.sh`) without `export`.
- Assuming quotes create a different type — `x="5"` and `x=5` are identical in Bash; both are just the string `5`.

## Best Practices

- Use `${VAR}` when concatenating directly against other text, `$VAR` otherwise (either is fine when followed by whitespace or punctuation that can't be part of an identifier).
- `export` only variables that genuinely need to reach child processes — over-exporting pollutes the environment of every subprocess you launch.
- Use `readonly VAR=value` for constants that should never be reassigned.

## Interview Questions

1. Why does `x=5; x="hello"` not raise an error?
2. What is the actual difference between a shell variable and an environment variable?
3. Why did `num = 5` (with spaces) fail, and what did Bash actually try to do?
