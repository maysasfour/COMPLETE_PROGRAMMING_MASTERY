// mathutils.rs - a module file, brought into the crate tree via `mod mathutils;` in main.rs.

pub fn add(a: i32, b: i32) -> i32 { // pub -- visible outside this module
    a + b
}

pub fn multiply(a: i32, b: i32) -> i32 {
    a * b
}

fn internal_helper() -> i32 { // no `pub` -- private to this module
    42
}

pub fn uses_internal_helper() -> i32 {
    internal_helper()
}
