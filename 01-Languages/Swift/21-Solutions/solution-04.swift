// solution-04.swift -- Exercise 04: Enum with Associated Values (NetworkResult)

enum NetworkResult<T> {
    case success(T)
    case failure(code: Int, message: String)
    case loading
}

func describe<T>(_ result: NetworkResult<T>) -> String {
    // Exhaustive `switch`, no `default:` -- the compiler itself checks every case of
    // `NetworkResult` is handled. If a case were added (see the `cancelled` note below)
    // and NOT handled here, this function would fail to COMPILE, not merely misbehave
    // at runtime -- the same guarantee Rust's `match` provides.
    switch result {
    case .success(let value):
        return "Success: \(value)"
    case .failure(let code, let message):
        return "Failure \(code): \(message)"
    case .loading:
        return "Loading..."
    }
}

print(describe(NetworkResult<[String]>.success(["a", "b"])))
print(describe(NetworkResult<[String]>.failure(code: 404, message: "Not Found")))
print(describe(NetworkResult<[String]>.loading))

// --- Exhaustiveness proof (documented, not left in as live code) ---
// Adding a fourth case to the enum --
//
//     enum NetworkResult<T> {
//         case success(T)
//         case failure(code: Int, message: String)
//         case loading
//         case cancelled
//     }
//
// -- was tried against a scratch copy of this file. The result: `describe`'s `switch`
// immediately failed to compile with
//     error: switch must be exhaustive
//     note: add missing case: '.cancelled'
// with NO code path in `describe` ever executed, unlike a plain class hierarchy where a
// missed `case`/subclass would simply be silently skipped at runtime and only show up as
// a bug report later. Reverted back to three cases for this file so the rest of the
// course's examples (and this solution's own printed output) stay consistent.
