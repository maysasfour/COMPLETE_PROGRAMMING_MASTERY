# Exercise 01 — Word Frequency with `std::map` and `<algorithm>`

[Back to lesson](../README.md)

## Task

Write `std::map<std::string, int> wordFrequency(const std::string& text)` that lowercases and strips basic punctuation (`.`, `,`, `!`, `?`), splits on spaces, and returns a frequency map. Then write `std::vector<std::pair<std::string,int>> topN(const std::map<std::string,int>& freq, int n)` returning the `n` most frequent entries (ties broken alphabetically) using `std::sort` on a copied vector of pairs.

## Constraints

- Use `<algorithm>`'s `std::sort` with a custom comparator for `topN` — no manual sorting loop.
- `"Cats, cats, and dogs. Dogs love cats!"` should count `"cats"` as 3.

## Starter Code

```cpp
std::map<std::string, int> wordFrequency(const std::string& text) {
    std::map<std::string, int> freq;
    // clean, split, count
    return freq;
}

std::vector<std::pair<std::string, int>> topN(const std::map<std::string, int>& freq, int n) {
    std::vector<std::pair<std::string, int>> entries(freq.begin(), freq.end());
    std::sort(entries.begin(), entries.end(), [](const auto& a, const auto& b) {
        if (a.second != b.second) return a.second > b.second;
        return a.first < b.first;
    });
    if (static_cast<int>(entries.size()) > n) entries.resize(n);
    return entries;
}
```

## Expected Output

```
cats: 3
dogs: 2
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.cpp](../Solutions/solution-01.cpp).
