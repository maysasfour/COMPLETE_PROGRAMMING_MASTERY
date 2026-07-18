// solution-02.rs - Custom Error Enum and the ? Operator
// See: ../20-Exercises/README.md#exercise-02--custom-error-enum-and-the--operator-beginnerintermediate
//
// Run with:
//     rustc solution-02.rs -o solution-02 && ./solution-02

use std::fmt;

#[derive(Debug)]
struct Config {
    name: String,
    retries: u32,
    timeout_ms: u64,
}

#[derive(Debug)]
enum ConfigError {
    MissingField(String),
    InvalidNumber {
        field: String,
        source: std::num::ParseIntError,
    },
}

// Display is the human-readable message; Debug (derived above) stays
// available separately for {:?} -- the two serve different audiences.
impl fmt::Display for ConfigError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            ConfigError::MissingField(field) => write!(f, "missing required field: {field}"),
            ConfigError::InvalidNumber { field, source } => {
                write!(f, "field '{field}' is not a valid number: {source}")
            }
        }
    }
}

// Implementing std::error::Error (not just Display) is what makes this a
// genuine, composable error type -- e.g. usable with Box<dyn Error> call
// sites, and it wires `source` into the standard error-chain convention.
impl std::error::Error for ConfigError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            ConfigError::InvalidNumber { source, .. } => Some(source),
            ConfigError::MissingField(_) => None,
        }
    }
}

// Small helper so `parse_config` can use `?` uniformly instead of writing
// the same "find this key, or return MissingField" match three times.
fn get_field<'a>(fields: &'a [(&str, &str)], key: &str) -> Result<&'a str, ConfigError> {
    fields
        .iter()
        .find(|(k, _)| *k == key)
        .map(|(_, v)| *v)
        .ok_or_else(|| ConfigError::MissingField(key.to_string()))
}

fn parse_config(text: &str) -> Result<Config, ConfigError> {
    let fields: Vec<(&str, &str)> = text
        .lines()
        .filter_map(|line| line.split_once('='))
        .collect();

    let name = get_field(&fields, "name")?.to_string();

    let retries_str = get_field(&fields, "retries")?;
    // `?` on a Result<u32, ParseIntError> would need a From<ParseIntError>
    // for ConfigError; mapping explicitly here keeps the field name attached
    // to the error, which a bare `?`-via-From conversion would lose.
    let retries: u32 = retries_str
        .parse()
        .map_err(|source| ConfigError::InvalidNumber {
            field: "retries".to_string(),
            source,
        })?;

    let timeout_str = get_field(&fields, "timeout_ms")?;
    let timeout_ms: u64 = timeout_str
        .parse()
        .map_err(|source| ConfigError::InvalidNumber {
            field: "timeout_ms".to_string(),
            source,
        })?;

    Ok(Config {
        name,
        retries,
        timeout_ms,
    })
}

fn main() {
    let good = "name=worker-1\nretries=3\ntimeout_ms=5000";
    match parse_config(good) {
        Ok(cfg) => println!(
            "Parsed OK: name={}, retries={}, timeout_ms={}",
            cfg.name, cfg.retries, cfg.timeout_ms
        ),
        Err(e) => println!("Unexpected error: {e}"),
    }

    let missing = "name=worker-2\ntimeout_ms=5000";
    match parse_config(missing) {
        Ok(cfg) => println!("Unexpected success: {cfg:?}"),
        Err(e) => println!("Expected error (missing field): {e}"),
    }

    let bad_number = "name=worker-3\nretries=not-a-number\ntimeout_ms=5000";
    match parse_config(bad_number) {
        Ok(cfg) => println!("Unexpected success: {cfg:?}"),
        Err(e) => println!("Expected error (invalid number): {e}"),
    }
}
