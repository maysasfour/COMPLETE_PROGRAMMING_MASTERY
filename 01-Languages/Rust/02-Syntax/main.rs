// main.rs - expression-oriented syntax: if-as-expression, block values, function return values.

fn add_one(x: i32) -> i32 {
    x + 1 // no semicolon -- this IS the return value
}

fn main() {
    let x = 5;
    let y = if x > 0 { "positive" } else { "non-positive" };
    println!("y = {}", y);

    let z = {
        let a = 1;
        let b = 2;
        a + b
    };
    println!("z = {}", z);

    println!("add_one(4) = {}", add_one(4));
}
