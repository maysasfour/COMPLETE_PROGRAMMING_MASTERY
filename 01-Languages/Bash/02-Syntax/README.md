# 02 — Syntax

[Back to Bash course](../README.md)

## Beginner: Keywords Instead of Braces

Unlike C-family languages, Bash does not use `{ }` to delimit blocks — it uses paired keywords (`if`/`fi`, `do`/`done`, `case`/`esac`). There is no statement-terminating semicolon requirement either — newlines terminate statements, and `;` is only needed to fit multiple statements on one line.

```bash
$ x=5
$ if [ $x -gt 3 ]; then echo "big"; fi
big
```

Here `; then` is required only because `if [ $x -gt 3 ]` and `then` are on the same line — write it across multiple lines and the semicolons disappear:

```bash
if [ $x -gt 3 ]
then
  echo "big"
fi
```

## The `[ ]` Whitespace Rule — Verified Live

`[` is not punctuation — it is a real command (equivalent to `test`), which means every token around it needs whitespace exactly like arguments to any other command:

```bash
$ if [ $x -gt 3 ]; then echo "big"; fi
big

$ if [$x -gt 3 ]; then echo "big"; fi
/usr/bin/bash: line 23: [5: command not found
```

The second form fails because `[$x` (with no space) is parsed as a single word — the shell first substitutes `$x` to get `[5`, then tries to run a command literally named `[5`, which doesn't exist. The `[` command **must** be its own separate token, with a space on both sides, and it **must** have a matching `]` at the end, also space-separated.

## `[[ ]]` — The Bash-Only Alternative

Modern Bash also supports `[[ ]]`, a keyword (not a command) with looser quoting rules and extra operators (`&&`, `||`, regex `=~`) built in directly:

```bash
[[ $x -gt 3 && $x -lt 10 ]] && echo "in range"
```

`[[ ]]` is Bash-specific (not POSIX `sh`) but generally preferred in Bash scripts for its safety around unquoted variables and richer syntax.

## Common Beginner Mistakes

- Missing the space after `[` or before `]` — produces "command not found," not an obvious syntax error.
- Forgetting the closing keyword (`fi`, `done`, `esac`) — Bash will just wait for more input or report "unexpected EOF."
- Assuming `{ }` blocks work like C — `{ }` in Bash is a grouping command with its own rules (needs a trailing `;` or newline before `}` and a leading space after `{`), not a block delimiter for `if`/`for`.

## Best Practices

- Prefer `[[ ]]` over `[ ]` in Bash-only scripts for safer word-splitting behavior.
- Always leave a space around `[`, `]`, `[[`, `]]`.
- Indent block bodies consistently even though Bash doesn't enforce it — readability matters more here than in most languages given how little syntax is there to lean on.

## Interview Questions

1. Why does `[$x -gt 3 ]` fail with "command not found" instead of a syntax error?
2. What closes an `if` block? A `case` block? A `for`/`while` loop?
3. What's the practical difference between `[ ]` and `[[ ]]`?
