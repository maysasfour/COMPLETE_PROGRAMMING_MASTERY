# 06 — Functions

[Back to Bash course](../README.md)

## Beginner: Defining Functions

Two equivalent syntaxes:

```bash
function greet {
  echo "Hello, $1"
}

greet2() {
  echo "Hello, $1"
}
```

The `name() { }` form is more portable (works in POSIX `sh` too); the `function name { }` form is Bash-specific. Arguments are accessed positionally as `$1`, `$2`, ... and `"$@"` for all of them — there is no named-parameter syntax.

## The Core Constraint: No Real Return Values — Verified Live

This is the single most distinctive thing about Bash functions coming from any other language: `return` does **not** hand back a value — it only sets the function's **exit code**, an integer from 0 to 255, exactly like a whole script's exit code.

```bash
$ greet() {
>   local name="$1"
>   echo "Hello, $name"
>   return 0
> }
$ greet "Mays"
Hello, Mays
$ echo "exit code: $?"
exit code: 0
```

`return 0` here just means "success" — it has nothing to do with the string `"Hello, Mays"` that was printed. If you actually need computed data out of a function, you print it to stdout and capture that with command substitution:

```bash
$ add() {
>   local sum=$(( $1 + $2 ))
>   echo "$sum"
> }
$ result=$(add 4 7)
$ echo "captured result: $result"
captured result: 11
```

`add` "returns" 11 by *printing* it, not by `return`-ing it; `$(add 4 7)` captures whatever the function writes to stdout. This split — exit code vs. stdout — is exactly analogous to a Unix process itself, which is not a coincidence: a Bash function behaves like a miniature process.

## Exit Codes as Booleans — Verified Live

Because `return`'s only real job is to signal exit status, functions compose naturally with `&&`/`||`, exactly like any other command:

```bash
$ check_even() {
>   if (( $1 % 2 == 0 )); then return 0; else return 1; fi
> }
$ check_even 4 && echo "4 is even (exit $?)"
4 is even (exit 0)
$ check_even 5 || echo "5 is odd (exit $?)"
5 is odd (exit 1)
```

`0` conventionally means "success"/true; any nonzero value (1–255) means "failure"/false — the opposite convention from booleans in most languages, but consistent with every Unix command's exit status.

## `local` vs. Global Variables

```bash
count=100
modify() {
  local count=1     # shadows the global inside this function only
  count=$((count + 1))
  echo "inside: $count"
}
modify
echo "outside: $count"
```

Without `local`, any variable assigned inside a function silently becomes (or mutates) a **global** variable — a frequent source of bugs in longer scripts where multiple functions reuse common names like `i`, `result`, or `tmp`.

## Common Beginner Mistakes

- Trying `x=$(add 4 7); return $x` to "pass along" a computed value through `return` — this truncates/wraps anything outside 0–255 and conflates a data value with an exit status.
- Forgetting `local`, causing a helper function to unintentionally clobber a same-named variable used elsewhere in the script.
- Assuming `return` with no argument returns "nothing" — it actually returns the exit status of the last command run inside the function.

## Best Practices

- Use `local` for every variable that doesn't need to escape the function.
- Use `echo`/`printf` + command substitution to return data; use `return`'s 0–255 exclusively for success/failure signaling.
- Keep functions small enough that "what does this return, the exit code or the printed text?" is never ambiguous to a reader.

## Interview Questions

1. What does `return 5` actually communicate, and how is that different from "returning the number 5" in Python?
2. How do you capture a function's computed output as a value in a variable?
3. What happens to a variable assigned inside a function without `local`?

## Exercises and Solutions

See [Exercises](Exercises/README.md) and [Solutions](Solutions/README.md).
