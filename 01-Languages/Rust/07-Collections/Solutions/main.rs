// main.rs - word frequency counting with HashMap, ranked via iterator adapters and sort_by.

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

fn main() {
    let freq = word_frequency("Cats, cats, and dogs. Dogs love cats!");
    for (word, count) in top_n(&freq, 2) {
        println!("{}: {}", word, count);
    }
}
