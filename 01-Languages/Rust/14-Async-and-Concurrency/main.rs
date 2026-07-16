// main.rs - std::thread::spawn (with real timing), Arc<Mutex<T>> for safe shared mutable state.

use std::sync::{Arc, Mutex};
use std::thread;
use std::time::{Duration, Instant};

fn slow_compute(ms: u64, value: i32) -> i32 {
    thread::sleep(Duration::from_millis(ms));
    value
}

fn main() {
    println!("--- basic spawned thread ---");
    let handle = thread::spawn(|| {
        println!("Hello from a thread");
    });
    handle.join().unwrap();

    println!("\n--- sequential vs concurrent threads (real timing) ---");
    let start1 = Instant::now();
    let a = slow_compute(80, 1);
    let b = slow_compute(80, 2);
    let c = slow_compute(80, 3);
    println!(
        "Sequential 3x80ms calls took ~{}ms (sum={})",
        start1.elapsed().as_millis(),
        a + b + c
    );

    let start2 = Instant::now();
    let h1 = thread::spawn(|| slow_compute(80, 1));
    let h2 = thread::spawn(|| slow_compute(80, 2));
    let h3 = thread::spawn(|| slow_compute(80, 3));
    let total = h1.join().unwrap() + h2.join().unwrap() + h3.join().unwrap();
    println!(
        "Concurrent threads of the same 3x80ms tasks took ~{}ms (sum={})",
        start2.elapsed().as_millis(),
        total
    );

    println!("\n--- Arc<Mutex<T>> for safe shared mutable state ---");
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result (reliably 10, compiler-enforced): {}", *counter.lock().unwrap());
}
