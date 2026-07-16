// main.rs - std::fs text file I/O with Result, and the ErrorKind::NotFound pattern.

use std::env;
use std::fs;
use std::io::ErrorKind;
use std::path::PathBuf;

fn main() {
    let mut path = env::temp_dir();
    path.push("example-notes.txt");

    println!("--- text file round-trip ---");
    fs::write(&path, "Hello, file system!\n").expect("failed to write file");
    let contents = fs::read_to_string(&path).expect("failed to read file");
    print!("Read back: {}", contents);

    println!("\n--- missing file handled via ErrorKind::NotFound ---");
    let mut missing_path = PathBuf::from(env::temp_dir());
    missing_path.push("does-not-exist-example.txt");
    match fs::read_to_string(&missing_path) {
        Ok(c) => println!("{}", c),
        Err(e) if e.kind() == ErrorKind::NotFound => {
            println!("File doesn't exist -- using defaults, handled gracefully");
        }
        Err(e) => println!("Unexpected error: {}", e),
    }

    fs::remove_file(&path).expect("failed to clean up");
    println!("\nCleaned up temporary file.");
}
