// main.rs - the crate root, declaring the mathutils module and using its public items.

mod mathutils; // brings src/mathutils.rs into the crate tree as the `mathutils` module

fn main() {
    println!("mathutils::add(2, 3): {}", mathutils::add(2, 3));
    println!("mathutils::multiply(4, 5): {}", mathutils::multiply(4, 5));
    println!("mathutils::uses_internal_helper(): {}", mathutils::uses_internal_helper());
    // mathutils::internal_helper(); // would fail to COMPILE -- private to the mathutils module
}
