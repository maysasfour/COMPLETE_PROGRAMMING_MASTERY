// solution-07.swift -- Exercise 07: Codable JSON Roundtrip with Validation

import Foundation

struct Book: Codable, Equatable {
    let title: String
    let author: String
    let year: Int
    let rating: Double
}

enum BookValidationError: Error {
    case ratingOutOfRange(Double)
}

func validate(_ book: Book) throws -> Book {
    guard (0.0...5.0).contains(book.rating) else {
        throw BookValidationError.ratingOutOfRange(book.rating)
    }
    return book
}

let candidates = [
    Book(title: "Clean Code", author: "Robert C. Martin", year: 2008, rating: 4.5),
    Book(title: "The Pragmatic Programmer", author: "Hunt & Thomas", year: 1999, rating: 4.8),
    Book(title: "Impossible Ratings", author: "Nobody", year: 2020, rating: 7.5), // invalid
    Book(title: "Refactoring", author: "Martin Fowler", year: 1999, rating: 4.6),
]

var validBooks: [Book] = []

print("--- Validation ---")
for book in candidates {
    do {
        let validated = try validate(book)
        validBooks.append(validated)
        print("OK: \(book.title)")
    } catch BookValidationError.ratingOutOfRange(let rating) {
        // Invalid data is caught HERE and never reaches the encoding step below --
        // `validBooks` only ever accumulates books that passed `validate(_:)`.
        print("REJECTED: \(book.title) has an out-of-range rating (\(rating)); not encoded.")
    } catch {
        print("Unexpected error for \(book.title): \(error)")
    }
}

print("\n--- Encode valid books to JSON ---")
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let jsonData = try! encoder.encode(validBooks)
let jsonString = String(data: jsonData, encoding: .utf8)!
print(jsonString)

print("\n--- Decode back and confirm roundtrip equality ---")
let decoder = JSONDecoder()
let roundtripped = try! decoder.decode([Book].self, from: jsonData)
print("roundtripped == validBooks: \(roundtripped == validBooks)")
