// main.rs - ownership, moves, borrowing, the borrowing rules, mut vs immutable.

fn calculate_length(s: &String) -> usize {
    s.len()
}

fn main() {
    println!("--- ownership and moves ---");
    let s1 = String::from("hello");
    let s2 = s1; // s1 is MOVED into s2
    // println!("{}", s1); // would fail to COMPILE: E0382, use of moved value
    println!("s2 owns the value now: {}", s2);

    println!("\n--- borrowing: using a value without taking ownership ---");
    let s3 = String::from("world");
    let len = calculate_length(&s3); // borrow -- s3 is still valid afterward
    println!("{} has length {}", s3, len);

    println!("\n--- borrowing rules: multiple immutable, or exactly one mutable ---");
    let mut x = 5;
    {
        let r1 = &x;
        let r2 = &x; // multiple immutable borrows are fine simultaneously
        println!("r1={}, r2={}", r1, r2);
    } // r1, r2 go out of scope here
    let r3 = &mut x; // now a mutable borrow is fine, since no immutable borrows are active
    *r3 += 1;
    println!("x after mutable borrow: {}", x);

    println!("\n--- mut vs immutable ---");
    let immutable_val = 10;
    println!("immutable_val: {}", immutable_val);
    let mut mutable_val = 10;
    mutable_val += 5;
    println!("mutable_val after += 5: {}", mutable_val);
}
