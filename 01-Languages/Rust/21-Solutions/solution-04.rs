// solution-04.rs - Generics and Monomorphization
// See: ../20-Exercises/README.md#exercise-04--generics-and-monomorphization-intermediate
//
// Run with:
//     rustc solution-04.rs -o solution-04 && ./solution-04

// `T: PartialOrd + Copy` is a trait-bound generic, not a template in the C++
// sense of "duck-typed until instantiated" nor Java's fully-erased
// `<T extends Comparable>` -- the compiler checks these bounds once, against
// the generic definition itself, before any call site exists.
fn find_max<T: PartialOrd + Copy>(items: &[T]) -> Option<T> {
    let mut iter = items.iter();
    let first = *iter.next()?;
    Some(iter.fold(first, |max, &x| if x > max { x } else { max }))
}

struct Pair<T> {
    first: T,
    second: T,
}

impl<T: PartialOrd + Copy> Pair<T> {
    fn larger(&self) -> T {
        if self.first > self.second {
            self.first
        } else {
            self.second
        }
    }
}

fn main() {
    // Each call below causes rustc to generate a SEPARATE, fully concrete
    // compiled copy of find_max<T> -- find_max::<i32>, find_max::<f64>,
    // find_max::<char> are three distinct functions in the final binary,
    // each with its own inlined comparison logic for that exact type. This
    // is monomorphization: there is no single shared "generic" function left
    // at runtime, unlike Java (one erased bytecode method reused for every
    // reference type, with runtime casts) or a C++ vtable-based approach
    // (one function, indirect calls through a table). The upside is zero
    // runtime dispatch overhead per call; the tradeoff is larger binaries
    // and longer compile times as more concrete types are instantiated.
    let ints = [3, 7, 2, 9, 4];
    let floats = [1.5, 2.75, 0.5, 9.25];
    let chars = ['m', 'a', 'z', 'b'];

    println!("max(ints)   = {:?}", find_max(&ints));
    println!("max(floats) = {:?}", find_max(&floats));
    println!("max(chars)  = {:?}", find_max(&chars));

    let empty: [i32; 0] = [];
    println!("max(empty)  = {:?}", find_max(&empty));

    let p_ints = Pair { first: 10, second: 42 };
    let p_floats = Pair { first: 3.14, second: 2.71 };
    println!("Pair<i32>::larger()  = {}", p_ints.larger());
    println!("Pair<f64>::larger()  = {}", p_floats.larger());
}
