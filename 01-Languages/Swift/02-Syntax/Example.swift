// Example.swift - top-level code (no main function/class wrapper needed in a main.swift or
// single-file script), semicolons optional, string interpolation, let/var.
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

// Single-line comment.
/* Multi-line
   comment. */
/* Swift also supports /* nested */ block comments -- unlike C/Java/most C-family languages. */

let name = "World"      // let = constant, the idiomatic default (like Kotlin's val, Rust's default immutability)
var count = 0              // var = variable, reassignable

print("Hello, \(name)!")   // string interpolation: \(expr) embeds a value directly
print("count + 1 = \(count + 1)")

count = 1 // no semicolon needed -- Swift infers statement boundaries from line breaks
print("count is now \(count)")

// let name2 = "reassigned"  // fine to declare a NEW constant, but reassigning an EXISTING
// name = "reassigned"        // let would be a COMPILE ERROR: "cannot assign to value: 'name' is a 'let' constant"
