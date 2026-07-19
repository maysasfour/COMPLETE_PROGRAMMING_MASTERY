# 07 — Arrays

[Back to Bash course](../README.md)

## Beginner: Indexed Arrays — Verified Live

```bash
$ fruits=("apple" "banana" "cherry")
$ echo "${fruits[0]}"
apple
$ echo "${fruits[@]}"
apple banana cherry
$ echo "count: ${#fruits[@]}"
count: 3
$ fruits+=("date")
$ echo "${fruits[@]}"
apple banana cherry date
```

`declare -a fruits` is the explicit form; a plain `fruits=(...)` implicitly creates an indexed array. `${fruits[@]}` expands to all elements (each staying a separate word when quoted as `"${fruits[@]}"`); `${#fruits[@]}` is the element count; `+=` appends.

## Array Slicing — Verified Live

```bash
$ echo "slice: ${fruits[@]:1:2}"
slice: banana cherry
```

`${array[@]:offset:length}` slices starting at index `offset` for `length` elements — here, starting at index 1 (`banana`), taking 2 elements (`banana cherry`).

## Associative Arrays (Bash 4+) — Verified Live

```bash
$ declare -A colors
$ colors[apple]="red"
$ colors[banana]="yellow"
$ for k in "${!colors[@]}"; do echo "$k -> ${colors[$k]}"; done
apple -> red
banana -> yellow
```

`declare -A` is **mandatory** for associative arrays — without it, `colors[apple]="red"` silently creates an *indexed* array where the string `apple` is coerced to the numeric index `0`, which is rarely what's intended. `"${!colors[@]}"` expands to the *keys*, not the values — the `!` prefix is what switches indexed-array-style expansion from values to keys/indices.

## Common Beginner Mistakes

- Forgetting `declare -A` before using string keys — the assignment appears to work but silently uses numeric coercion instead of the string key.
- Iterating with `for v in "${array[@]}"` when order matters for an associative array — Bash does not guarantee associative-array iteration order.
- Using `${array[@]}` unquoted in a loop, which reintroduces the word-splitting bug from the prerequisite lesson if any element contains whitespace.

## Best Practices

- Always quote array expansions: `"${array[@]}"`, not `${array[@]}`.
- Use `declare -a`/`declare -A` explicitly at the top of scripts that use arrays, for readability even where not strictly required.
- Prefer associative arrays over parallel indexed arrays (`names[i]` / `ages[i]`) when data is naturally key-value.

## Interview Questions

1. What happens if you assign `map[key]=value` without first running `declare -A map`?
2. How do you get the number of elements in an array? The keys of an associative array?
3. Why must array expansions almost always be quoted?

## Exercises and Solutions

See [Exercises](Exercises/README.md) and [Solutions](Solutions/README.md).
