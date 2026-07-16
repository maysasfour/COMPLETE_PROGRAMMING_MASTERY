// main.rs - capitalize_first (mutable borrow, in place) vs shout (immutable borrow, returns new String).

fn capitalize_first(s: &mut String) {
    if let Some(first) = s.chars().next() {
        let capitalized = first.to_uppercase().collect::<String>() + &s[first.len_utf8()..];
        *s = capitalized;
    }
}

fn shout(s: &str) -> String {
    s.to_uppercase()
}

fn main() {
    let mut name = String::from("ada");
    capitalize_first(&mut name);
    println!("{}", name);

    let original = String::from("hello");
    let shouted = shout(&original);
    println!("{} / {}", original, shouted);
}
