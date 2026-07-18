// solution-01.swift -- Exercise 01: Safe Contact Lookup
//
// The dictionary's declared value type is `String?` (an optional email), so subscripting
// `[String: String?]` returns `String??` -- one layer of optionality from "is the key present
// at all" (Dictionary subscript always returns an Optional) and a second layer from the
// dictionary's own value type already being optional. Two `guard let`s peel one layer each.

func lookup(_ name: String, in contacts: [String: String?]) -> String {
    // First guard: unwraps the OUTER optional -- "is `name` a key in the dictionary at all?"
    // If `name` isn't present, `contacts[name]` is `nil` (not `.some(nil)`), so this guard
    // fails and we take the `else` branch -- this is the "not a contact" case.
    guard let emailIfPresent = contacts[name] else {
        return "\(name) is not a contact"
    }
    // Second guard: unwraps the INNER optional -- the key exists, but its associated
    // value (`String?`) might itself be `nil` (Bob has no email on file). `emailIfPresent`
    // here has type `String?`, so this second `guard let` is unwrapping a genuinely
    // different, inner layer of optionality than the first one did.
    guard let email = emailIfPresent else {
        return "\(name) has no email on file"
    }
    return "\(name): \(email)"
}

let contacts: [String: String?] = [
    "Alice": "alice@example.com",
    "Bob": nil,
    "Carol": "carol@example.com",
]

print(lookup("Alice", in: contacts))
print(lookup("Bob", in: contacts))
print(lookup("Dave", in: contacts))
