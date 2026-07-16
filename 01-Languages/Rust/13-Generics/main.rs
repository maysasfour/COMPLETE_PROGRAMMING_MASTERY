// main.rs - generic functions, trait bounds, generic structs.

fn first<T>(items: &[T]) -> &T {
    &items[0]
}

fn largest<T: PartialOrd + Copy>(items: &[T]) -> T {
    let mut largest = items[0];
    for &item in items {
        if item > largest {
            largest = item;
        }
    }
    largest
}

struct Stack<T> {
    items: Vec<T>,
}

impl<T> Stack<T> {
    fn new() -> Self {
        Stack { items: Vec::new() }
    }
    fn push(&mut self, item: T) {
        self.items.push(item);
    }
    fn pop(&mut self) -> Option<T> {
        self.items.pop()
    }
    fn len(&self) -> usize {
        self.items.len()
    }
}

fn main() {
    println!("--- generic function with inference ---");
    println!("{}", first(&[1, 2, 3]));
    println!("{}", first(&["a", "b"]));

    println!("\n--- trait-bounded generic function ---");
    println!("largest of ints: {}", largest(&[3, 7, 2, 9, 4]));
    println!("largest of floats: {}", largest(&[1.5, 9.9, 2.2]));

    println!("\n--- generic struct Stack<T> ---");
    let mut number_stack: Stack<i32> = Stack::new();
    number_stack.push(1);
    number_stack.push(2);
    number_stack.push(3);
    println!("number_stack.len(): {}", number_stack.len());
    println!("number_stack.pop(): {:?}", number_stack.pop());

    let mut string_stack: Stack<String> = Stack::new();
    string_stack.push("a".to_string());
    string_stack.push("b".to_string());
    println!("string_stack.pop(): {:?}", string_stack.pop());

    let mut empty_stack: Stack<i32> = Stack::new();
    println!("empty_stack.pop(): {:?}", empty_stack.pop());
}
