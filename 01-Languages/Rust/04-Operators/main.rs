// main.rs - arithmetic/comparison/logical, Option<T> instead of null, explicit numeric casts, wrapping_add.

fn main() {
    println!("--- arithmetic, comparison, logical ---");
    let a = 5;
    let b = 10;
    println!("{} {} {} {}", a + b, a == b, a < b, a > 0 && b > 0);

    println!("\n--- Option<T> instead of null ---");
    let some_number: Option<i32> = Some(5);
    let no_number: Option<i32> = None;

    match some_number {
        Some(n) => println!("Got a number: {}", n),
        None => println!("No number"),
    }
    match no_number {
        Some(n) => println!("Got a number: {}", n),
        None => println!("No number"),
    }

    println!("\n--- no implicit numeric conversion ---");
    let x: i32 = 5;
    let y: i64 = 10;
    let sum = x as i64 + y;
    println!("explicit cast sum: {}", sum);

    println!("\n--- integer overflow: explicit wrapping_add ---");
    let max_u8: u8 = 255;
    let wrapped = max_u8.wrapping_add(1);
    println!("255u8.wrapping_add(1) = {}", wrapped);
}
