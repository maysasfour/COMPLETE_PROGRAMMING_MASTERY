// Example.swift - Error handling via the Error protocol, throws/try/catch, and Swift's
// three distinct "try" flavors (try, try?, try!) -- a genuinely different design from
// exceptions in Kotlin/Java/C#/Python, closer in spirit to Rust's Result<T,E> but with
// its own propagation syntax (throws/try) rather than an explicit return type wrapper.
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

enum ValidationError: Error {
    case tooShort(minLength: Int)
    case empty
}

func validate(_ input: String) throws -> String {
    if input.isEmpty {
        throw ValidationError.empty
    }
    if input.count < 3 {
        throw ValidationError.tooShort(minLength: 3)
    }
    return input
}

// --- do/catch: the standard way to handle a throwing function's error ---
do {
    let result = try validate("ok")
    print("validated: \(result)")
} catch ValidationError.empty {
    print("caught: input was empty")
} catch ValidationError.tooShort(let minLength) {
    print("caught: input too short, needs at least \(minLength) characters")
} catch {
    print("caught: unexpected error: \(error)")
}

do {
    let result = try validate("hello world")
    print("validated: \(result)")
} catch {
    print("caught: \(error)")
}

// --- try?: converts a throwing call into an Optional -- nil on failure, no do/catch needed ---
let maybeValid = try? validate("hi") // "hi" is too short -- maybeValid becomes nil
print("try? result: \(maybeValid ?? "validation failed, nil returned")")

// --- try!: force-try, like force-unwrap -- CRASHES if the call actually throws ---
let definitelyValid = try! validate("this will not throw")
print("try! result: \(definitelyValid)")

// --- Custom error types can carry associated data (enum case payloads, Lesson 11 preview) ---
func describe(_ error: ValidationError) -> String {
    switch error {
    case .empty:
        return "empty input"
    case .tooShort(let minLength):
        return "too short, needs \(minLength) characters"
    }
}
print(describe(.tooShort(minLength: 5)))
