// main.rs - Result<T,E> with match, the ? operator, custom error types, panic! as last resort.

use std::fmt;

fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        return Err(String::from("cannot divide by zero"));
    }
    Ok(a / b)
}

fn calculate(a: f64, b: f64, c: f64) -> Result<f64, String> {
    let step1 = divide(a, b)?;
    let step2 = divide(step1, c)?;
    Ok(step2)
}

#[derive(Debug)]
struct ValidationError {
    field: String,
    message: String,
}

impl fmt::Display for ValidationError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}: {}", self.field, self.message)
    }
}

impl std::error::Error for ValidationError {}

fn validate_age(age: i32) -> Result<i32, ValidationError> {
    if age < 0 {
        return Err(ValidationError {
            field: String::from("age"),
            message: String::from("cannot be negative"),
        });
    }
    Ok(age)
}

fn main() {
    println!("--- Result handled via match ---");
    match divide(10.0, 0.0) {
        Ok(result) => println!("Result: {}", result),
        Err(e) => println!("Error: {}", e),
    }

    println!("\n--- ? operator propagating through a multi-step calculation ---");
    match calculate(100.0, 5.0, 0.0) {
        Ok(result) => println!("calculate succeeded: {}", result),
        Err(e) => println!("calculate failed: {}", e),
    }
    match calculate(100.0, 5.0, 2.0) {
        Ok(result) => println!("calculate succeeded: {}", result),
        Err(e) => println!("calculate failed: {}", e),
    }

    println!("\n--- custom error type implementing Display ---");
    match validate_age(-5) {
        Ok(age) => println!("Valid age: {}", age),
        Err(e) => println!("Validation failed: {}", e),
    }
}
