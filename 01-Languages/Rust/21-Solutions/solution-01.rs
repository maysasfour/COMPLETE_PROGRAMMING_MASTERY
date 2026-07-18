// solution-01.rs - Lifetimes and Borrowing
// See: ../20-Exercises/README.md#exercise-01--lifetimes-and-borrowing-beginner
//
// Run with:
//     rustc solution-01.rs -o solution-01 && ./solution-01

// The lifetime 'a ties the returned &str to the input &str's borrow -- the
// compiler statically guarantees the returned slice can never outlive `text`,
// with zero runtime cost (no reference counting, no GC). `max_by_key` walks
// the split iterator once and keeps the first-seen max on ties, since it only
// replaces the current max on a strictly-greater key.
fn longest_word<'a>(text: &'a str) -> &'a str {
    text.split_whitespace()
        .max_by_key(|w| w.len())
        .unwrap_or("")
}

// Borrowing `&[String]` (not `Vec<String>` by value, not even `&Vec<String>`)
// is the idiomatic signature: it accepts a slice of any String-backed
// collection without forcing the caller to give up ownership, and a plain
// slice is more flexible for callers than a reference to a specific Vec.
fn total_chars(words: &[String]) -> usize {
    words.iter().map(|w| w.chars().count()).sum()
}

fn main() {
    let text = String::from("the quick brown fox jumps over extraordinarily");
    let word = longest_word(&text);
    println!("Longest word: {} (len {})", word, word.len());
    // `text` was only ever borrowed (&'a str), never moved -- still usable here.
    println!("Original text still usable: {}", text);

    let words = vec!["hello".to_string(), "world".to_string(), "rust".to_string()];
    let total = total_chars(&words);
    println!("Total chars across {} words: {}", words.len(), total);
    // Same guarantee: `words` was borrowed as &[String], not consumed.
    println!("Words vec still owned by caller: {:?}", words);
}
