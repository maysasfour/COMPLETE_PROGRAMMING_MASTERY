# 21 — Solutions

[Back to Bash course](../README.md)

All eight solutions below were actually run with real Bash; every output block is copied verbatim from that run.

## 1. Setup

```bash
#!/usr/bin/env bash
echo "Bash version: $(bash --version | head -1)"
echo "Current directory: $(pwd)"
```

Verified live:

```
Bash version: GNU bash, version 5.2.37(1)-release (x86_64-pc-msys)
Current directory: /c/Users/HP/AppData/Local/Temp/.../scratchpad/bashtest
```

## 2. Operators

```bash
#!/usr/bin/env bash
a="$1"; b="$2"
if [ "$a" -gt "$b" ]; then echo "$a > $b"
elif [ "$a" -lt "$b" ]; then echo "$a < $b"
else echo "$a == $b"
fi
```

Verified live:

```
$ bash ex2.sh 7 3
7 > 3
$ bash ex2.sh 3 7
3 < 7
$ bash ex2.sh 5 5
5 == 5
```

## 3. Control Flow

```bash
#!/usr/bin/env bash
for i in $(seq 1 20); do
  case $i in
    [1-7]) label="low" ;;
    [8-9]|1[0-4]) label="mid" ;;
    *) label="high" ;;
  esac
  echo "$i: $label"
done
```

Verified live (excerpt): `1: low` ... `7: low`, `8: mid` ... `14: mid`, `15: high` ... `20: high` — all 20 lines produced correctly in one run.

## 4. Functions

```bash
#!/usr/bin/env bash
to_uppercase() { echo "${1^^}"; }
for s in "hello" "Bash Course" "MiXeD case"; do
  echo "$(to_uppercase "$s")"
done
```

Verified live:

```
HELLO
BASH COURSE
MIXED CASE
```

## 5. Arrays

```bash
#!/usr/bin/env bash
files=("report.txt" "install.sh" "notes.txt" "deploy.sh" "readme.md")
txt_files=()
sh_files=()
for f in "${files[@]}"; do
  case "$f" in
    *.txt) txt_files+=("$f") ;;
    *.sh) sh_files+=("$f") ;;
  esac
done
echo "txt: ${txt_files[@]}"
echo "sh: ${sh_files[@]}"
```

Verified live:

```
txt: report.txt notes.txt
sh: install.sh deploy.sh
```

(`readme.md` correctly matched neither pattern and was excluded from both arrays.)

## 6. Error Handling

```bash
#!/usr/bin/env bash
set -euo pipefail
tmpfile=$(mktemp)
trap 'echo "TRAP RAN: cleaning up $tmpfile"; rm -f "$tmpfile"' EXIT
echo "created $tmpfile"
this_command_does_not_exist
echo "unreachable"
```

Verified live:

```
created /tmp/tmp.gTyu2SjaTt
ex6.sh: line 6: this_command_does_not_exist: command not found
TRAP RAN: cleaning up /tmp/tmp.gTyu2SjaTt
script exited with code 127
```

`set -e` stopped the script at the failing command; `echo "unreachable"` never ran; the `trap` still fired during the abnormal exit, proving cleanup runs even on a `set -e` triggered failure.

## 7. File Handling + Strings

```bash
#!/usr/bin/env bash
while IFS='=' read -r key value; do
  [ -z "$key" ] && continue
  echo "$key -> $value"
done < config.txt
```

Given a `config.txt` with `name=Bash Course`, `version=1.0`, a blank line, then `author=Mays`, verified live:

```
name -> Bash Course
version -> 1.0
author -> Mays
```

The blank line was correctly skipped via `[ -z "$key" ] && continue`.

## 8. Mini-Integration

```bash
#!/usr/bin/env bash
set -euo pipefail
URL="https://jsonplaceholder.typicode.com/todos/2"
status=$(curl -s -o /tmp/ex8resp.json -w "%{http_code}" "$URL")
echo "HTTP status: $status"
if [ "$status" = "200" ]; then
  completed=$(grep -o '"completed": *[a-z]*' /tmp/ex8resp.json | sed -E 's/"completed": *([a-z]*)/\1/')
  echo "completed: $completed"
fi
rm -f /tmp/ex8resp.json
```

Verified live against the real API:

```
HTTP status: 200
completed: false
```
