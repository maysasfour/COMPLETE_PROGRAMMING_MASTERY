# Bash Cheat Sheet

[Back to Bash course](README.md)

## Shebang & Execution

```bash
#!/usr/bin/env bash
chmod +x script.sh
./script.sh        # needs +x and shebang
bash script.sh      # doesn't need +x
source script.sh    # runs in CURRENT shell (variables persist)
```

## Variables

```bash
name="value"          # no spaces around =
echo "$name" "${name}"
export NAME="value"   # visible to child processes
readonly PI=3.14159
unset name
```

## Arithmetic (NOT bare +)

```bash
echo $((3 + 4))        # 7
let "x = 3 + 4"
(( x++ ))
echo "3" + "4"          # WRONG -> prints "3 + 4" literally, string concat
```

## Comparisons

| Type | Equal | Not equal | Greater | Less |
|------|-------|-----------|---------|------|
| String | `=` or `==` | `!=` | `\>` (lexical) | `\<` |
| Numeric | `-eq` | `-ne` | `-gt` | `-lt` |

```bash
[ "$a" -eq "$b" ]     # numeric
[ "$a" = "$b" ]       # string
[[ $a -gt $b ]]       # modern test, no quoting required for numerics
```

## Conditionals & Loops

```bash
if [ cond ]; then ...; elif [ cond2 ]; then ...; else ...; fi
case "$x" in pattern) ... ;; *) ... ;; esac
for i in 1 2 3; do ...; done
for f in *.txt; do ...; done      # glob, not `$(ls)`
while [ cond ]; do ...; done
until [ cond ]; do ...; done
```

## Functions

```bash
greet() { echo "Hello, $1"; }       # $1 = first arg, "$@" = all args
greet() { local x="$1"; return 0; } # return = exit code 0-255 ONLY
result=$(greet "Mays")              # capture real output via command substitution
```

## Arrays

```bash
arr=(a b c)
arr+=(d)
echo "${arr[0]}" "${arr[@]}" "${#arr[@]}"
echo "${arr[@]:1:2}"                 # slice

declare -A map
map[key]="value"
for k in "${!map[@]}"; do echo "$k=${map[$k]}"; done
```

## Strings (parameter expansion)

```bash
${var#prefix}    # remove shortest prefix match
${var%suffix}    # remove shortest suffix match
${var/find/repl} # replace first match
${var//find/repl}# replace all
${var^^} / ${var,,}  # uppercase / lowercase
printf "%-10s|%5d\n" "item" 42
```

## Error Handling

```bash
set -e            # exit on any command failure
set -u            # error on undefined variables
set -o pipefail   # a failing command in a pipe fails the whole pipe
set -euo pipefail # "strict mode" - use at the top of every real script

command; echo $?  # inspect last exit code
trap 'echo cleanup; rm -f "$tmp"' EXIT
```

## File Handling

```bash
echo "x" > file      # overwrite
echo "y" >> file      # append
cmd < file             # redirect stdin
while read -r line; do echo "$line"; done < file
[ -f file ] && [ -d dir ] && [ -e path ]
```

## Process Management

```bash
long_cmd &            # background
pid=$!
wait $pid
(cd /tmp && pwd)       # subshell — cd doesn't affect parent
diff <(cmd1) <(cmd2)   # process substitution
```

## Concurrency

```bash
for i in 1 2 3; do slow_task "$i" & done; wait   # parallel
seq 1 10 | xargs -P4 -I{} do_thing {}             # 4 workers
```

## Sourcing

```bash
source ./lib.sh   # or: . ./lib.sh
```

## Quoting (the #1 real-world bug source)

```bash
for f in $(ls dir); do ...; done   # BREAKS on filenames with spaces
for f in dir/*; do ...; done        # correct — glob, no re-splitting
rm $file                             # BREAKS if $file has spaces
rm "$file"                           # correct
```
