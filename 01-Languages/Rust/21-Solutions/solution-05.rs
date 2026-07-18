// solution-05.rs - Closures: Fn, FnMut, and FnOnce
// See: ../20-Exercises/README.md#exercise-05--closures-fn-fnmut-and-fnonce-intermediateadvanced
//
// Run with:
//     rustc solution-05.rs -o solution-05 && ./solution-05

// Fn: called through a shared reference, can be called any number of times,
// captures (if any) are only ever read, never mutated.
fn apply<F: Fn(i32) -> i32>(f: F, x: i32) -> i32 {
    f(x)
}

// FnMut: called through a mutable reference, can be called any number of
// times, and MAY mutate what it captures between calls -- exactly what a
// stateful counter closure needs.
fn run_n_times<F: FnMut() -> i32>(mut f: F, n: usize) -> Vec<i32> {
    (0..n).map(|_| f()).collect()
}

// FnOnce: every closure implements at least FnOnce, but a closure that
// consumes (moves out of) one of its captures can ONLY implement FnOnce,
// since calling it a second time would try to move an already-moved value.
fn consume<F: FnOnce() -> String>(f: F) -> String {
    f()
}

fn main() {
    // --- Fn: read-only capture (here, none at all -- a pure function of x) ---
    let square = |x: i32| x * x;
    println!("apply(square, 6) = {}", apply(square, 6));

    // --- FnMut: mutably captures `count` by reference across repeated calls ---
    let mut count = 0;
    let increment = || {
        count += 1;
        count
    };
    let results = run_n_times(increment, 5);
    println!("run_n_times(increment, 5) = {:?}", results);

    // --- FnOnce: `move` transfers ownership of `greeting` INTO the closure;
    // calling consume() calls the closure exactly once, which moves
    // `greeting` out of the closure's own captured state via the `+`
    // concatenation (String + &str consumes the left-hand String). A second
    // call is impossible: the closure itself is consumed (not just
    // borrowed) by the one call inside `consume`, and `greeting` no longer
    // exists in `main` after the closure was constructed with `move`. This
    // is exactly why the bound is FnOnce and not Fn/FnMut -- the compiler
    // would reject `consume(build_greeting); consume(build_greeting);` with
    // "use of moved value" if you tried it, since FnOnce closures are
    // consumed by their single permitted call.
    let greeting = String::from("Hello");
    let build_greeting = move || greeting + ", Rust!";
    println!("consume(build_greeting) = {}", consume(build_greeting));
}
