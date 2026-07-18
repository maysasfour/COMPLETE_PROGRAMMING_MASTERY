// solution-06.rs - Generic, Trait-Bounded Inventory
// See: ../20-Exercises/README.md#exercise-06--generic-trait-bounded-inventory-advanced
//
// Run with:
//     rustc solution-06.rs -o solution-06 && ./solution-06

trait Priced {
    fn price(&self) -> f64;
}

#[derive(Clone, Debug)]
struct Item {
    name: String,
    price: f64,
}

impl Priced for Item {
    fn price(&self) -> f64 {
        self.price
    }
}

// A trait-bounded generic function: works for ANY type implementing Priced,
// not just Item -- a second, differently-shaped type could implement Priced
// and reuse this exact function with zero changes, unlike a function
// hardcoded to `&[Item]`.
fn total_value<T: Priced>(items: &[T]) -> f64 {
    items.iter().map(|i| i.price()).sum()
}

// `impl Fn(&T) -> bool` accepts any caller-supplied closure as the filter
// condition, so filter_items itself doesn't need to know in advance what
// "matches" means -- that's Lesson 12's closures composing directly with
// Lesson 13's generics.
fn filter_items<T: Priced + Clone>(items: &[T], predicate: impl Fn(&T) -> bool) -> Vec<T> {
    items.iter().filter(|i| predicate(i)).cloned().collect()
}

fn main() {
    let items = vec![
        Item { name: "Keyboard".to_string(), price: 45.0 },
        Item { name: "Monitor".to_string(), price: 220.0 },
        Item { name: "Mouse".to_string(), price: 25.0 },
        Item { name: "Webcam".to_string(), price: 60.0 },
        Item { name: "Standing Desk".to_string(), price: 350.0 },
    ];

    println!("Total value of {} items: {:.2}", items.len(), total_value(&items));

    let expensive = filter_items(&items, |i| i.price > 50.0);
    println!("Items over $50.00:");
    for item in &expensive {
        println!("  {} (${:.2})", item.name, item.price);
    }

    let desk_like = filter_items(&items, |i| i.name.contains("Desk"));
    println!("Items with 'Desk' in the name:");
    for item in &desk_like {
        println!("  {} (${:.2})", item.name, item.price);
    }
}
