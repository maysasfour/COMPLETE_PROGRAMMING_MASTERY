# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Make GET/POST requests with the `ureq` crate (synchronous, no async runtime dependency needed) — Rust, like C++, has no built-in HTTP client at all.
- Discover a genuine exception to this course's repeated "HTTP clients don't error on 4xx/5xx" pattern: `ureq` **does**.
- Decode a JSON response into a struct with `serde`/`serde_json` (Lesson 10).

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Concept

Like C++, Rust's standard library has zero HTTP/networking support built in. This lesson uses `ureq` — a simple, synchronous HTTP client crate requiring no async runtime (unlike `reqwest`, the more commonly recommended crate, which typically pulls in `tokio`) — specifically to avoid the async-runtime dependency this course's Lesson 14 flagged as a real cost.

## A Genuine Exception to This Course's Repeated Pattern

Every other language course in this repository (Python, JavaScript, TypeScript, C#, Java, C++, Go) makes the same point about its HTTP client: **a 404/500 response resolves normally; only a network-level failure is an error.** Verifying `ureq`'s actual behavior surfaced a real exception to that pattern:

```rust
match ureq::get("https://api.example.com/todos/99999999").call() {
    Ok(resp) => println!("status: {}", resp.status()),
    Err(ureq::Error::Status(code, _)) => {
        // ureq's DEFAULT behavior: a non-2xx response is an Err, not a normal Ok response!
        println!("status: {} (an Err, not an Ok)", code);
    }
    Err(e) => println!("other error: {}", e),
}
```

`ureq` treats any non-2xx status as an `Err(ureq::Error::Status(code, response))` **by default** — genuinely different from every other HTTP client covered in this repository, and confirmed by actually running this exact code against a real 404 response, not assumed from documentation. This matters practically: code migrating from `fetch`/`HttpClient`/`net/http` habits (checking `.status`/`resp.StatusCode` on a normally-returned response) needs to instead match on the `Err` variant to distinguish an HTTP-level failure from a genuine network failure with `ureq` specifically. (Other Rust HTTP crates, like `reqwest`, follow the more common "non-2xx is still `Ok`" convention — this behavior is specific to `ureq`'s design, not a Rust-wide convention.)

## GET and JSON Decoding

```rust
use serde::Deserialize;

#[derive(Deserialize)]
struct Todo {
    #[serde(rename = "userId")] // maps JSON's camelCase key to Rust's snake_case field
    user_id: i32,
    title: String,
    completed: bool,
}

let resp = ureq::get("https://api.example.com/todos/1").call()?;
let todo: Todo = resp.into_json()?;
```

## POST with a JSON Body

```rust
#[derive(serde::Serialize)]
struct NewTodo { title: String, completed: bool }

let new_todo = NewTodo { title: "test".to_string(), completed: false };
let resp = ureq::post("https://api.example.com/todos").send_json(&new_todo)?;
```

## Detailed Example

See [Cargo.toml](Cargo.toml) and [src/main.rs](src/main.rs) — makes real network calls to the public `jsonplaceholder.typicode.com` test API (the same service used throughout this repository's other language courses), including the genuinely-verified 404-as-Err behavior above.

## Run It

```bash
cd 01-Languages/Rust/17-API-Integration
cargo run
```

## Expected Output

Running `cargo run` (requires internet access) prints a real, decoded `Todo` struct, confirms a 404 route is returned as an `Err(ureq::Error::Status(404, _))` (not a normal `Ok` response, the opposite of every other language course's HTTP client), and shows a POST's echoed-back response body.

## Common Mistakes

- Assuming `ureq` follows the same "normal response even for 404/500" convention as `fetch`/`HttpClient`/`net/http` — it doesn't, by default; matching only on `Ok(resp)` and checking `.status()` would miss every HTTP-level error entirely, since they arrive as `Err`, not `Ok`.
- Forgetting `#[serde(rename = "...")]` when the JSON's key casing (typically `camelCase`) doesn't match Rust's `snake_case` field naming convention.

## Best Practices

- When using `ureq` specifically, match on `Err(ureq::Error::Status(code, response))` to handle HTTP-level errors, not just check `.status()` on an `Ok` response.
- Use `#[serde(rename = "...")]` to bridge naming-convention mismatches explicitly, rather than renaming your Rust fields to match external JSON casing.
- Consider `reqwest` (the more commonly recommended crate, if an async runtime is already part of your project) if you want the "non-2xx is still `Ok`" convention consistent with this repository's other language courses.

## Real-World Usage

`reqwest` (async, `tokio`-based) is the most widely used Rust HTTP client for applications already using an async runtime; `ureq` (synchronous, no async runtime needed) is a popular lighter-weight alternative for CLI tools and simpler synchronous programs — this lesson deliberately chose `ureq` to avoid pulling in `tokio` just for one lesson, consistent with this course's dependency-minimal style.

## Summary

- Rust's standard library has zero HTTP support, like C++; `ureq` (synchronous, no async runtime) or `reqwest` (async, `tokio`-based) are the two most common crates.
- `ureq` specifically treats non-2xx responses as `Err`, by design — a genuine, verified exception to the "non-2xx is a normal response" pattern established by every other language course in this repository.
- `serde`/`serde_json` (Lesson 10) decode JSON responses into structs, with `#[serde(rename = "...")]` bridging naming-convention mismatches.

## Key Terms

- **`ureq`** — a synchronous Rust HTTP client crate requiring no async runtime.
- **`ureq::Error::Status`** — the error variant `ureq` returns for a non-2xx HTTP response, by default.

## Interview Questions

1. **Does `ureq` return a normal response for a 404, like most other HTTP clients?**
   No — this was specifically verified, not assumed: `ureq` returns `Err(ureq::Error::Status(code, response))` by default for any non-2xx status, unlike `fetch`/`HttpClient`/`net/http`/every other HTTP client covered in this repository, all of which return a normal, non-error response object for HTTP-level failures and require a manual status check. This is a genuine, crate-specific design choice, not a Rust-language-wide convention — other Rust HTTP crates like `reqwest` follow the more common pattern instead.

2. **Why might you choose `ureq` over `reqwest` for a Rust project's HTTP needs?**
   `ureq` is synchronous and requires no async runtime dependency at all, making it a lighter-weight choice for CLI tools or simple programs that don't otherwise need `async`/`await` (Lesson 14) or `tokio`. `reqwest` is async (built on `tokio`) and is the more commonly recommended default for applications that are already async, or that want the more conventional "non-2xx is still `Ok`" response handling.

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
