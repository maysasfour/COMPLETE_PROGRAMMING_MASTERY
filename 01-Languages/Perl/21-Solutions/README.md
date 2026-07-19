# 21 — Solutions

[Back to course overview](../README.md) | [Previous: Exercises](../20-Exercises/README.md)

Worked, verified solutions to all eight [20-Exercises](../20-Exercises/README.md) problems (`ex1_reverse_words.pl` through `ex8_memoized_fib.pl`). Each was actually run with `perl` (5.38.2, bundled with Git for Windows at `C:\Program Files\Git\usr\bin\perl.exe`); the captured output below is real, not hand-computed.

> **Note on 20-Exercises/README.md**: that file's prose currently describes a different set of seven problems (word-frequency counter, version comparator, retry-with-backoff, etc.) than the eight `ex*.pl` files actually present in the folder (`reverse_words`, `palindrome`, `unique_sorted`, `hash_invert`, `temperature_class`, `safe_divide`, `word_frequency_file`, `memoized_fib`). The solutions here follow the actual exercise files/comments, since those are the concrete, checked-in specification. The README text is stale and should be corrected separately to describe the eight exercises that exist.

## Solution 1 — Reverse Words

[solution-01-reverse_words.pl](solution-01-reverse_words.pl)

```
input:  the quick brown fox jumps over the lazy dog
output: dog lazy the over jumps fox brown quick the
```

## Solution 2 — Palindrome Check (case/punctuation-insensitive)

[solution-02-palindrome.pl](solution-02-palindrome.pl)

```
"A man, a plan, a canal: Panama" -> PALINDROME
"Was it a car or a cat I saw?" -> PALINDROME
"Hello, World!" -> not a palindrome
"Madam, I'm Adam" -> PALINDROME
```

## Solution 3 — Unique, Numerically Sorted

[solution-03-unique_sorted.pl](solution-03-unique_sorted.pl)

```
input:  (5, 3, 8, 3, 1, 5, 9, 1, 0, 8, -2)
output: (-2, 0, 1, 3, 5, 8, 9)
```

`sort { $a <=> $b }` is required here — a default `sort` is lexical/string-based and would put `9` before `-2`.

## Solution 4 — Hash Invert

[solution-04-hash_invert.pl](solution-04-hash_invert.pl)

```
original:
  Egypt => Cairo
  France => Paris
  Japan => Tokyo
inverted:
  Cairo => Egypt
  Paris => France
  Tokyo => Japan
```

## Solution 5 — Temperature Class (bless-based OOP)

[solution-05-temperature_class.pl](solution-05-temperature_class.pl)

```
0.0C (32.0F)
37.0C (98.6F)
100.0C (212.0F)
-40.0C (-40.0F)
```

## Solution 6 — Safe Divide (eval/die instead of crashing)

[solution-06-safe_divide.pl](solution-06-safe_divide.pl)

```
safe_divide(10, 2) = 5
safe_divide(7, 0) = undef
safe_divide(9, 3) = 3
script did not crash -- reached the end
```

A `warn` (`safe_divide(7, 0) failed: division by zero`) is also emitted to STDERR for the zero-division case; interleaving with STDOUT may vary depending on buffering, but all four lines above are always printed and the script always reaches its final line.

## Solution 7 — Word Frequency From a File (top 3)

[solution-07-word_frequency_file.pl](solution-07-word_frequency_file.pl) reads [sample.txt](sample.txt) (checked in alongside it, resolved with `FindBin` so it works regardless of the caller's working directory):

```
the: 7
fox: 4
dog: 3
```

## Solution 8 — Memoized Fibonacci (closure over a private `%cache`)

[solution-08-memoized_fib.pl](solution-08-memoized_fib.pl)

```
fib(0) = 0
fib(1) = 1
fib(2) = 1
fib(5) = 5
fib(10) = 55
fib(20) = 6765
fib(30) = 832040
```

`fib(30)` computing instantly (rather than the ~2.7 million recursive calls plain unmemoized Fibonacci would take) demonstrates the `%cache` closure is actually doing its job.

## Run Them All

```bash
cd 01-Languages/Perl/21-Solutions
for f in solution-*.pl; do echo "=== $f ==="; perl "$f"; done
```

## Recommended Next Lesson

[22 — Mini-Projects](../22-Mini-Projects/README.md)
