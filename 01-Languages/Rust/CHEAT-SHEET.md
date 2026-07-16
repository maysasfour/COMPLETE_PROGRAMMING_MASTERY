# Rust Cheat Sheet

[Back to course overview](README.md)

## Variables and Ownership

```rust
let age: i32 = 30;
let name = "Ada";        // inferred, &str
let mut count = 0;        // mut required to reassign -- immutable by default
count += 1;

let s1 = String::from("hi");
let s2 = s1;               // MOVE -- s1 is no longer valid after this
let s3 = s2.clone();       // explicit deep copy, s2 still valid

const PI: f64 = 3.14159;   // must have an explicit type, always compile-time constant
```

## Borrowing (Many Immutable XOR One Mutable)

```rust
fn len(s: &String) -> usize { s.len() }   // borrow -- doesn't take ownership
let r1 = &s;
let r2 = &s;      // OK -- multiple immutable borrows
// let m = &mut s; // ERROR while r1/r2 are alive

let m = &mut s;   // OK once r1/r2 are out of scope -- one mutable borrow
```

## Control Flow (Expressions, Not Just Statements)

```rust
let x = if cond { 1 } else { 2 };   // if is an expression

match value {
    0 => println!("zero"),
    1 | 2 => println!("one or two"),
    3..=9 => println!("three to nine"),
    n if n < 0 => println!("negative"),
    _ => println!("other"),         // _ required -- match is exhaustive
}

loop { break; }                       // infinite, use break value; to return a value
while x < 10 { }
for item in &collection { }
```

## Functions and Ownership-Aware Parameters

```rust
fn takes_ownership(s: String) { }     // caller's value is moved/consumed
fn borrows(s: &String) { }            // caller keeps ownership
fn borrows_mut(s: &mut String) { }    // caller keeps ownership, allows mutation

fn last_expr_is_return(x: i32) -> i32 { x * 2 }  // no semicolon = implicit return
```

## Collections

```rust
let mut v: Vec<i32> = vec![1, 2, 3];
v.push(4);
v.get(0);        // Option<&T> -- safe
v[0];             // panics if out of bounds

use std::collections::HashMap;
let mut m: HashMap<&str, i32> = HashMap::new();
m.insert("a", 1);
*m.entry("a").or_insert(0) += 1;   // idiomatic upsert, single lookup

v.iter().map(|x| x * 2).filter(|x| *x > 2).sum::<i32>();
```

## Strings (`String` vs `&str`)

```rust
let owned: String = String::from("hello");
let borrowed: &str = &owned;         // deref coercion
owned.len();                          // BYTE length, not char count
owned.chars().count();                // character count (UTF-8 aware)
// owned[0]                            // ERROR -- Strings can't be indexed by integer
```

## Error Handling (No Exceptions)

```rust
fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 { return Err("div by zero".to_string()); }
    Ok(a / b)
}
let result = divide(10.0, 2.0)?;   // ? propagates Err upward automatically

let maybe: Option<i32> = None;
match maybe {
    Some(v) => println!("{}", v),
    None => println!("nothing"),
}

panic!("unrecoverable");   // no general-purpose recover, unlike Go
```

## OOP (No Classes/Inheritance)

```rust
struct Animal { name: String }

impl Animal {
    fn new(name: &str) -> Self { Animal { name: name.to_string() } }
    fn speak(&self) -> String { format!("{} makes a sound", self.name) }
}

trait Speaker { fn speak(&self) -> String; }
impl Speaker for Animal { fn speak(&self) -> String { self.name.clone() } }
// composition only -- no struct embedding/field promotion like Go
```

## Generics and Traits

```rust
fn largest<T: PartialOrd>(items: &[T]) -> &T { /* ... */ &items[0] }

struct Stack<T> { items: Vec<T> }
impl<T> Stack<T> {
    fn push(&mut self, item: T) { self.items.push(item); }
}
// monomorphization -- a separate copy compiled per concrete T, unlike Java's erasure
```

## Concurrency (Compile-Time-Enforced)

```rust
use std::thread;
use std::sync::{Arc, Mutex};

let counter = Arc::new(Mutex::new(0));
let mut handles = vec![];
for _ in 0..5 {
    let counter = Arc::clone(&counter);
    handles.push(thread::spawn(move || {
        *counter.lock().unwrap() += 1;
    }));
}
for h in handles { h.join().unwrap(); }
// data races are a COMPILE error in safe Rust, not just a runtime risk
```

## Modules and Crates

```rust
mod utils {
    pub fn helper() -> i32 { 42 }
}
use utils::helper;
```

```toml
# Cargo.toml
[dependencies]
serde = { version = "1", features = ["derive"] }
```

## Testing (Built In)

```rust
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn it_works() { assert_eq!(2 + 2, 4); }

    #[test]
    #[should_panic]
    fn it_panics() { panic!(); }
}
```

## Running Code

```bash
rustc main.rs -o main && ./main   # single file, no cargo needed
cargo new project_name              # scaffold a Cargo project
cargo run                            # build + run
cargo build --release               # optimized binary
cargo test                           # run all tests
```
