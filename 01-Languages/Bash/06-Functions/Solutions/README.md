# Solutions — Functions

## 1. `max_of`

```bash
#!/usr/bin/env bash
max_of() {
  if (( $1 > $2 )); then echo "$1"; else echo "$2"; fi
}
m=$(max_of 7 12)
echo "Max: $m"
```

Verified live:

```
Max: 12
```

## 2. `is_palindrome`

**Bug found and fixed during verification:** an initial version piped through the external `rev` command (`rev=$(echo "$s" | rev)`), which is not installed in every environment — it failed here with `rev: command not found` on this Git Bash setup, silently returning wrong results for every word. Rewritten with a pure-Bash substring-reversal loop that has no external dependency:

```bash
#!/usr/bin/env bash
is_palindrome() {
  local s="$1"
  local rev=""
  local i
  for (( i=${#s}-1; i>=0; i-- )); do
    rev+="${s:$i:1}"
  done
  [ "$s" = "$rev" ]
}
for word in "racecar" "hello" "level"; do
  if is_palindrome "$word"; then
    echo "$word is a palindrome"
  else
    echo "$word is NOT a palindrome"
  fi
done
```

Verified live:

```
racecar is a palindrome
hello is NOT a palindrome
level is a palindrome
```

This is a genuine, real-world lesson in itself: relying on external commands (`rev`, and many other coreutils) is not guaranteed to be portable across every Bash environment, whereas pure parameter-expansion/loop-based string manipulation (Lesson 08) always works.
