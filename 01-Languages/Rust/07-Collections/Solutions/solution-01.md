# Solution 01 — Word Frequency with Iterator Adapters

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `text.to_lowercase().chars().filter(|c| !".,!?".contains(*c)).collect()` builds the cleaned string via a chained iterator: lowercase first, then filter out punctuation characters one at a time, then `.collect()` back into a `String` — a purely iterator-adapter-based cleaning pipeline, no manual string-building loop.
- `*freq.entry(word.to_string()).or_insert(0) += 1` is Rust's idiomatic "increment or initialize" pattern: `.entry(key)` gets a handle to the map slot (creating it with `.or_insert(0)` if absent), and `*...  += 1` dereferences and increments through that handle in one line — equivalent in spirit to `GetValueOrDefault`/`getOrDefault` patterns from the C#/Java courses, but expressed as a single mutating expression.
- `top_n` collects the map into a `Vec<(String, i32)>` (since `HashMap` has no defined iteration order) and sorts with `.sort_by`, using `Ordering::then_with` to chain a count-descending comparison with an alphabetical tie-break — directly mirroring the comparator-composition pattern from the C#/Java/C++/Go courses' equivalent exercises.

## Verification

Ran with `rustc main.rs -o main.exe && ./main.exe`; actual output:

```
cats: 3
dogs: 2
```

Matches the exercise's expected output exactly.
