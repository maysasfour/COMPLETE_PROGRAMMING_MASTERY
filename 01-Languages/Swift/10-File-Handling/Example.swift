// Example.swift - file I/O via Foundation's FileManager/String(contentsOfFile:), and a
// genuinely important, positive contrast with several other languages in this repository:
// Swift has BUILT-IN JSON support via Codable/JSONEncoder/JSONDecoder -- no external
// library needed, unlike Java, Kotlin, C++, PHP, and Rust, ALL of which required an
// external JSON library (Gson, nlohmann/json, serde_json, etc.) in their own lessons.
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

import Foundation

let fileManager = FileManager.default
let tempDir = fileManager.temporaryDirectory.appendingPathComponent("swift_course_scratch")
try? fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
let fileURL = tempDir.appendingPathComponent("notes.txt")

print("--- Writing and reading a file ---")
try! "line one\nline two\n".write(to: fileURL, atomically: true, encoding: .utf8)
let contents = try! String(contentsOf: fileURL, encoding: .utf8)
print(contents)

print("\n--- Appending (Foundation has no built-in append -- read, concatenate, rewrite) ---")
let appended = contents + "line three\n"
try! appended.write(to: fileURL, atomically: true, encoding: .utf8)
print(try! String(contentsOf: fileURL, encoding: .utf8))

print("\n--- Missing file: throws, like Kotlin/Java (exception-based, not PHP's false-returning) ---")
let missingURL = tempDir.appendingPathComponent("does-not-exist.txt")
do {
    _ = try String(contentsOf: missingURL, encoding: .utf8)
} catch {
    print("caught: \(error.localizedDescription)")
}

print("\n--- Codable/JSONEncoder/JSONDecoder: BUILT-IN JSON support, no library needed ---")
struct Person: Codable {
    let name: String
    let age: Int
    let active: Bool
}
let person = Person(name: "Ada", age: 30, active: true)
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let jsonData = try! encoder.encode(person)
let jsonString = String(data: jsonData, encoding: .utf8)!
print(jsonString)

let decoder = JSONDecoder()
let decoded = try! decoder.decode(Person.self, from: jsonData)
print("decoded name: \(decoded.name)")

// clean up -- this course never leaves scratch artifacts behind (in spirit -- not actually run)
try? fileManager.removeItem(at: tempDir)
