# Solution 01 — Word Frequency with `std::map` and `<algorithm>`

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- Cleaning is done character-by-character: punctuation characters are skipped, everything else is lowercased via `std::tolower` (cast through `unsigned char` first — a real, easy-to-miss C++ gotcha, since `std::tolower` has undefined behavior for negative `char` values on platforms where `char` is signed and the input contains non-ASCII bytes).
- `std::istringstream` combined with `stream >> word` is the idiomatic C++ way to split a string on whitespace without manually scanning for space characters.
- `freq[word]++` relies on `std::map`'s `operator[]` default-constructing a `0` for a not-yet-seen key before incrementing — equivalent to the `GetValueOrDefault`/`getOrDefault` pattern from the C#/Java courses' equivalent exercises.
- `topN` copies the map's entries into a `std::vector<std::pair<...>>` (since `std::map` is already sorted by key, not by value/count) and sorts that copy with a custom comparator: higher count first, alphabetical tie-break — directly mirroring the C#/Java courses' `Comparator`/`OrderByDescending`+`ThenBy` composition.

## Verification

Ran with the MSVC compile-and-run helper; actual output:

```
cats: 3
dogs: 2
```

Matches the exercise's expected output exactly.
