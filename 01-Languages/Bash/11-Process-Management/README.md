# 11 — Process Management

[Back to Bash course](../README.md)

## Why This Lesson Is Bash's "OOP-Adjacent" Chapter

Bash has no classes, no objects, no inheritance — there is nothing structurally analogous to OOP. What Bash *does* have, uniquely among the languages in this repository, is a rich, native vocabulary for managing **processes**: backgrounding, waiting, subshells, and process substitution. Composing behavior out of independent processes piped and orchestrated together is the closest thing Bash has to "designing a system," so this lesson stands in for that architectural layer.

## Background Jobs and `wait` — Verified Live

```bash
$ sleep 1 &
$ bgpid=$!
$ echo "started background pid $bgpid"
started background pid 7956
$ wait $bgpid
$ echo "background done, exit $?"
background done, exit 0
```

`&` runs a command in the background and immediately returns control to the shell; `$!` holds the PID of the most recently backgrounded job; `wait $bgpid` blocks until that specific process finishes (bare `wait` with no argument waits for *all* background jobs).

## Subshells — Verified Live

```bash
$ (cd /tmp && echo "in subshell: $(pwd)")
in subshell: /tmp
$ echo "back in original shell: $(pwd)"
back in original shell: /c/Users/.../scratchpad/bashtest
```

`( ... )` runs its contents in a **subshell** — a forked child process with its own copy of the environment. The `cd /tmp` inside only affected that subshell; the parent shell's working directory was untouched. This is the standard way to make temporary state changes (directory, variables, `set` options) that don't leak back out.

## Process Substitution — Verified Live

```bash
$ diff <(echo -e "a\nb\nc") <(echo -e "a\nx\nc") || echo "diffs found (expected)"
2c2
< b
---
> x
diffs found (expected)
```

`<(command)` runs `command` and exposes its output as if it were a temporary file, letting tools like `diff` (which expect file arguments, not stdin streams) operate directly on the live output of two other commands without manually creating temp files first.

## Common Beginner Mistakes

- Forgetting `wait`, letting the script exit while background jobs are still running (they may be silently killed or become orphaned).
- Expecting `cd` inside `( )` to persist afterward — it deliberately doesn't, since it's a separate process.
- Assuming process substitution `<(...)` works identically to a real file path in every context — some programs specifically require seekable files and reject the pseudo-file `/dev/fd/N` Bash gives them.

## Best Practices

- Always capture `$!` immediately after backgrounding a job if you'll need to `wait` on it specifically later.
- Use subshells `( ... )` deliberately to scope directory changes or option changes (`set`) without needing to restore them manually afterward.
- Prefer `diff <(cmd1) <(cmd2)` over writing two temp files by hand when comparing command output.

## Interview Questions

1. What does `$!` hold, and when does it get set?
2. Why does `cd` inside `( ... )` not affect the calling shell?
3. What problem does process substitution (`<(...)`) solve that a plain pipe can't?
