// main.rs - closures (by ref, by mut ref, by move), iterator adapters, generic function over Fn.

fn apply<F: Fn(i32) -> i32>(f: F, x: i32) -> i32 {
    f(x)
}

fn main() {
    println!("--- closure capturing by reference ---");
    let multiplier = 3;
    let by_reference = |n: i32| n * multiplier;
    println!("by_reference(5): {}", by_reference(5));

    println!("\n--- closure capturing by mutable reference ---");
    let mut count = 0;
    let mut by_mut_reference = || {
        count += 1;
        count
    };
    println!("by_mut_reference(): {}", by_mut_reference());
    println!("by_mut_reference(): {}", by_mut_reference());

    println!("\n--- move closure taking ownership ---");
    let s = String::from("hello from a moved closure");
    let by_move = move || println!("{}", s);
    by_move();

    println!("\n--- iterator adapter chain ---");
    let numbers = vec![1, 2, 3, 4, 5];
    let result: i32 = numbers.iter().filter(|&&n| n % 2 == 0).map(|n| n * n).sum();
    println!("sum of squares of evens: {}", result);

    println!("\n--- generic function accepting any Fn(i32) -> i32 ---");
    let double = |n| n * 2;
    println!("apply(double, 5): {}", apply(double, 5));
}
