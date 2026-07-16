// main.rs - exhaustive match (with guards/ranges), loop/while/for, loop returning a value.

enum Direction {
    North,
    South,
    East,
    West,
}

fn describe(d: Direction) -> &'static str {
    match d {
        Direction::North => "going up",
        Direction::South => "going down",
        Direction::East => "going right",
        Direction::West => "going left",
    }
}

fn main() {
    println!("--- exhaustive match over an enum ---");
    println!("{}", describe(Direction::North));
    println!("{}", describe(Direction::South));
    println!("{}", describe(Direction::East));
    println!("{}", describe(Direction::West));

    println!("\n--- match with guards and range patterns ---");
    for n in [-5, 0, 5, 50] {
        let description = match n {
            x if x < 0 => "negative",
            0 => "zero",
            1..=9 => "single digit",
            _ => "large number",
        };
        println!("{}: {}", n, description);
    }

    println!("\n--- loop, while, for ---");
    let mut count = 0;
    loop {
        if count >= 3 {
            break;
        }
        print!("{} ", count);
        count += 1;
    }
    println!();

    while count < 6 {
        print!("{} ", count);
        count += 1;
    }
    println!();

    for i in 0..3 {
        print!("{} ", i);
    }
    println!();

    println!("\n--- loop returning a value via break ---");
    let result = loop {
        count += 1;
        if count == 10 {
            break count * 2;
        }
    };
    println!("loop result: {}", result);
}
