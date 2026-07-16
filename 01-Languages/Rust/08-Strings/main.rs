// main.rs - String vs &str, no direct integer indexing, byte length vs char count, common ops.

fn takes_str(s: &str) -> usize {
    s.len()
}

fn main() {
    println!("--- String vs &str ---");
    let owned: String = String::from("hello");
    let borrowed: &str = "hello";
    println!("takes_str(&owned): {}", takes_str(&owned));
    println!("takes_str(borrowed): {}", takes_str(borrowed));

    println!("\n--- no direct integer indexing; use .chars() instead ---");
    let s = String::from("héllo");
    let first_char = s.chars().next();
    println!("first_char: {:?}", first_char);
    // let x = s[0]; // would fail to COMPILE: `String` cannot be indexed by `{integer}`

    println!("\n--- byte length vs char count ---");
    println!("s.len() [byte length]: {}", s.len());
    println!("s.chars().count() [actual character count]: {}", s.chars().count());

    println!("\n--- common operations ---");
    let padded = "  hello  ";
    println!("trim: [{}]", padded.trim());
    println!("to_uppercase: {}", padded.to_uppercase());
    println!("contains 'ell': {}", padded.contains("ell"));
    println!("split: {:?}", "a,b,c".split(',').collect::<Vec<&str>>());
    println!("join: {}", ["a", "b"].join("-"));
}
