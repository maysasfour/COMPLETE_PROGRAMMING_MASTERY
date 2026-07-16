# Exercise 01 — Word Frequency with Iterator Adapters

[Back to lesson](../README.md)

## Task

Write `fn word_frequency(text: &str) -> HashMap<String, i32>` that lowercases and strips basic punctuation, splits on whitespace, and returns a frequency map. Then write `fn top_n(freq: &HashMap<String, i32>, n: usize) -> Vec<(String, i32)>` returning the `n` most frequent entries (ties broken alphabetically), using iterator adapters (`.collect()`, `.sort_by()`) — no manual sorting loop.

## Constraints

- `word_frequency` must take `&str` (borrowed), not `String`.
- `"Cats, cats, and dogs. Dogs love cats!"` should count `"cats"` as 3.

## Starter Code

```rust
use std::collections::HashMap;

fn word_frequency(text: &str) -> HashMap<String, i32> {
    let cleaned: String = text
        .to_lowercase()
        .chars()
        .filter(|c| !".,!?".contains(*c))
        .collect();

    let mut freq = HashMap::new();
    for word in cleaned.split_whitespace() {
        *freq.entry(word.to_string()).or_insert(0) += 1;
    }
    freq
}

fn top_n(freq: &HashMap<String, i32>, n: usize) -> Vec<(String, i32)> {
    let mut entries: Vec<(String, i32)> = freq.iter().map(|(k, v)| (k.clone(), *v)).collect();
    entries.sort_by(|a, b| b.1.cmp(&a.1).then_with(|| a.0.cmp(&b.0)));
    entries.truncate(n);
    entries
}
```

## Expected Output

```
cats: 3
dogs: 2
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/main.rs](../Solutions/main.rs).
