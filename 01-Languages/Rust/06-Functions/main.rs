// main.rs - ownership-aware parameters: takes-ownership, borrows, mutably-borrows.

fn takes_ownership(s: String) -> usize {
    s.len()
}

fn borrows(s: &String) -> usize {
    s.len()
}

fn mutably_borrows(s: &mut String) {
    s.push_str(" (modified)");
}

fn add(a: i32, b: i32) -> i32 {
    a + b
}

fn main() {
    println!("--- takes ownership ---");
    let owned = String::from("hello");
    let len = takes_ownership(owned);
    // println!("{}", owned); // would fail to COMPILE -- owned was moved
    println!("length: {}", len);

    println!("\n--- borrows (caller's variable stays valid) ---");
    let s = String::from("world");
    let len2 = borrows(&s);
    println!("{} still valid, length {}", s, len2);

    println!("\n--- mutably borrows (actually modifies the caller's value) ---");
    let mut s2 = String::from("world");
    mutably_borrows(&mut s2);
    println!("{}", s2);

    println!("\n--- expression-based return ---");
    println!("add(2, 3) = {}", add(2, 3));
}
