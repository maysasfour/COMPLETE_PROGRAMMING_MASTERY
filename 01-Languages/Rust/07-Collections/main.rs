// main.rs - Vec, HashMap, safe .get() vs panicking index, borrow-vs-move iteration, iterator adapters.

use std::collections::HashMap;

fn main() {
    println!("--- Vec ---");
    let mut scores = vec![95, 88, 76];
    scores.push(100);
    println!("scores[0]: {}", scores[0]);
    println!("scores.get(0): {:?}", scores.get(0));
    println!("scores.get(100) (safe, out of range): {:?}", scores.get(100));

    println!("\n--- HashMap ---");
    let mut ages: HashMap<String, i32> = HashMap::new();
    ages.insert(String::from("Ada"), 30);
    match ages.get("Ada") {
        Some(age) => println!("Ada is {}", age),
        None => println!("not found"),
    }
    match ages.get("Unknown") {
        Some(age) => println!("Unknown is {}", age),
        None => println!("not found"),
    }

    println!("\n--- iterating by reference leaves the Vec usable afterward ---");
    let numbers = vec![1, 2, 3];
    for n in &numbers {
        print!("{} ", n);
    }
    println!();
    println!("numbers still usable: {:?}", numbers);

    println!("\n--- iterator adapters: map, filter, fold ---");
    let doubled: Vec<i32> = numbers.iter().map(|n| n * 2).collect();
    let evens: Vec<&i32> = numbers.iter().filter(|&&n| n % 2 == 0).collect();
    let total: i32 = numbers.iter().fold(0, |acc, n| acc + n);
    println!("doubled: {:?}", doubled);
    println!("evens: {:?}", evens);
    println!("total: {}", total);
}
