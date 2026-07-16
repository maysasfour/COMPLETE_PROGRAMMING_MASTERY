// lib.rs - functions under test, plus their unit tests in an inline `#[cfg(test)] mod tests`.
// `#[cfg(test)]` means this module is compiled ONLY when running `cargo test`, not `cargo build`
// or `cargo run` -- unlike Go, where _test.go files are excluded by filename convention instead.

pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

pub fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        return Err("division by zero".to_string());
    }
    Ok(a / b)
}

pub fn is_palindrome(s: &str) -> bool {
    let cleaned: String = s.chars().filter(|c| c.is_alphanumeric()).collect::<String>().to_lowercase();
    cleaned.chars().eq(cleaned.chars().rev())
}

#[derive(Debug, PartialEq)]
pub struct Fraction {
    pub numerator: i32,
    pub denominator: i32,
}

impl Fraction {
    pub fn simplify(&self) -> Fraction {
        fn gcd(a: i32, b: i32) -> i32 {
            if b == 0 { a.abs() } else { gcd(b, a % b) }
        }
        let g = gcd(self.numerator, self.denominator);
        Fraction { numerator: self.numerator / g, denominator: self.denominator / g }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn add_positive_numbers() {
        assert_eq!(add(2, 3), 5);
    }

    #[test]
    fn add_negative_numbers() {
        assert_eq!(add(-2, -3), -5);
    }

    // Table-driven style: iterate over a slice of (input, input, expected) tuples,
    // the same pattern used in this course's Go lesson 18, adapted to Rust's tuple/array style.
    #[test]
    fn divide_table_driven() {
        let cases: [(f64, f64, f64); 3] = [
            (10.0, 2.0, 5.0),
            (9.0, 3.0, 3.0),
            (-6.0, 2.0, -3.0),
        ];
        for (a, b, expected) in cases {
            let result = divide(a, b).expect("should not error for non-zero divisor");
            assert_eq!(result, expected, "divide({}, {}) failed", a, b);
        }
    }

    #[test]
    fn divide_by_zero_returns_err() {
        let result = divide(5.0, 0.0);
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), "division by zero");
    }

    #[test]
    fn palindrome_cases() {
        let cases = [
            ("racecar", true),
            ("A man a plan a canal Panama", true),
            ("hello", false),
            ("", true),
        ];
        for (input, expected) in cases {
            assert_eq!(is_palindrome(input), expected, "is_palindrome({:?}) failed", input);
        }
    }

    #[test]
    fn fraction_simplify() {
        let f = Fraction { numerator: 8, denominator: 12 };
        assert_eq!(f.simplify(), Fraction { numerator: 2, denominator: 3 });
    }

    // A test that is EXPECTED to panic -- `#[should_panic]` asserts the panic happens,
    // rather than treating any panic as an automatic test failure (Rust's default behavior).
    #[test]
    #[should_panic(expected = "index out of bounds")]
    fn indexing_past_the_end_panics() {
        let v = vec![1, 2, 3];
        let _ = v[10];
    }

    // Tests can return Result<(), E> instead of using assert! macros, letting `?` propagate
    // a failure directly -- this test is intentionally written this way to demonstrate it.
    #[test]
    fn divide_using_question_mark() -> Result<(), String> {
        let result = divide(10.0, 5.0)?;
        assert_eq!(result, 2.0);
        Ok(())
    }
}
