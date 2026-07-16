// main.rs - Before/after: three common Rust anti-patterns and their idiomatic fixes.
// Run directly with: rustc main.rs -o main && ./main

use std::collections::HashMap;

// --- Anti-pattern 1: needless `.clone()` to dodge the borrow checker instead of borrowing ---
fn total_len_bad(words: Vec<String>) -> usize {
    let mut total = 0;
    for w in words.clone() { // clones the WHOLE Vec<String> just to iterate over it
        total += w.len();
    }
    total // `words` (the original) is now unused after being needlessly cloned
}

fn total_len_good(words: &[String]) -> usize {
    words.iter().map(|w| w.len()).sum() // borrows; no clone, no ownership taken at all
}

// --- Anti-pattern 2: `.unwrap()` on fallible parsing instead of propagating the error ---
fn parse_and_double_bad(input: &str) -> i32 {
    let n: i32 = input.parse().unwrap(); // panics the whole program on bad input
    n * 2
}

fn parse_and_double_good(input: &str) -> Result<i32, std::num::ParseIntError> {
    let n: i32 = input.parse()?; // propagates a proper error to the caller instead
    Ok(n * 2)
}

// --- Anti-pattern 3: repeated `+` string concatenation in a loop (reallocates every time) ---
fn build_report_bad(items: &[(&str, i32)]) -> String {
    let mut report = String::new();
    for (name, count) in items {
        report = report + name + ": " + &count.to_string() + "\n"; // new allocation each iteration
    }
    report
}

fn build_report_good(items: &[(&str, i32)]) -> String {
    let mut report = String::with_capacity(items.len() * 16); // one allocation up front
    for (name, count) in items {
        report.push_str(name);
        report.push_str(": ");
        report.push_str(&count.to_string());
        report.push('\n');
    }
    report
}

fn main() {
    println!("--- Anti-pattern 1: needless clone vs. borrowing ---");
    let words = vec!["hello".to_string(), "world".to_string(), "rust".to_string()];
    println!("bad (clones):  {}", total_len_bad(words.clone()));
    println!("good (borrows): {}", total_len_good(&words));

    println!("\n--- Anti-pattern 2: .unwrap() vs. proper error propagation ---");
    println!("bad:  parse_and_double_bad(\"21\") = {}", parse_and_double_bad("21"));
    match parse_and_double_good("21") {
        Ok(n) => println!("good: parse_and_double_good(\"21\") = Ok({})", n),
        Err(e) => println!("good: error: {}", e),
    }
    match parse_and_double_good("not a number") {
        Ok(n) => println!("good: parse_and_double_good(\"not a number\") = Ok({})", n),
        Err(e) => println!("good: parse_and_double_good(\"not a number\") = Err({}) -- handled gracefully, no panic", e),
    }

    println!("\n--- Anti-pattern 3: repeated string concatenation vs. push_str ---");
    let items = [("apples", 3), ("bananas", 5), ("cherries", 12)];
    let bad_report = build_report_bad(&items);
    let good_report = build_report_good(&items);
    print!("bad report:\n{}", bad_report);
    print!("good report:\n{}", good_report);
    assert_eq!(bad_report, good_report, "both should produce identical output");
    println!("(identical output confirmed -- the fix changes performance, not behavior)");

    println!("\n--- Bonus: HashMap entry API instead of contains_key + insert ---");
    let mut counts: HashMap<&str, i32> = HashMap::new();
    for (name, _) in &items {
        *counts.entry(name).or_insert(0) += 1; // idiomatic: one lookup, not two
    }
    println!("counts: {:?}", counts);
}
