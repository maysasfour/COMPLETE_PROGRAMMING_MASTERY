# Solutions — Arrays

## 1. Sum and average

```bash
#!/usr/bin/env bash
nums=(3 7 2 9 4)
total=0
for n in "${nums[@]}"; do
  total=$((total + n))
done
echo "Sum: $total"
echo "Average: $(( total / ${#nums[@]} ))"
```

Verified live:

```
Sum: 25
Average: 5
```

(Integer division: 25/5 = 5 exactly here; note Bash arithmetic truncates toward zero for non-exact divisions since there's no floating point in `$(( ))`.)

## 2. Word count with an associative array

```bash
#!/usr/bin/env bash
declare -A counts
words=(apple banana apple cherry banana apple)
for w in "${words[@]}"; do
  counts[$w]=$(( ${counts[$w]:-0} + 1 ))
done
for k in "${!counts[@]}"; do
  echo "$k: ${counts[$k]}"
done
```

Verified live:

```
cherry: 1
apple: 3
banana: 2
```

`${counts[$w]:-0}` uses the "default value" parameter expansion — if `counts[$w]` is unset (first time seeing that word), it evaluates to `0` instead of an empty string, avoiding an arithmetic error on the first increment. Note the iteration order (`cherry`, `apple`, `banana`) is not insertion order — associative arrays make no ordering guarantee.
