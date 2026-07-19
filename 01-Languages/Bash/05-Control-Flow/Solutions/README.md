# Solutions — Control Flow

## 1. `fizzbuzz.sh`

```bash
#!/usr/bin/env bash
for i in $(seq 1 15); do
  if (( i % 15 == 0 )); then echo "FizzBuzz"
  elif (( i % 3 == 0 )); then echo "Fizz"
  elif (( i % 5 == 0 )); then echo "Buzz"
  else echo "$i"
  fi
done
```

Verified live:

```
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
```

## 2. `classify.sh`

```bash
#!/usr/bin/env bash
case "$1" in
  *.sh) echo "shell script" ;;
  *.txt) echo "text file" ;;
  *) echo "unknown type" ;;
esac
```

Verified live:

```
$ bash classify.sh hello.sh
shell script
$ bash classify.sh notes.txt
text file
$ bash classify.sh photo.png
unknown type
```
