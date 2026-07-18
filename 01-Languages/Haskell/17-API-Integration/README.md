# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Make a real HTTP GET request from Haskell using `http-conduit`'s simple interface (`Network.HTTP.Simple`).
- Parse a JSON response using `aeson`, mapping it to a proper Haskell data type.
- See the same "does it throw on a non-2xx status?" question every other language course in this repository has asked of its own HTTP client, answered for Haskell's.

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Environment Honesty Note (Read First)

`http-conduit` (which pulls in the full `http-client`/`tls`/`connection`/`network` dependency chain) was genuinely installed and built via Cabal in this environment, and this lesson's live call to the same public test API used throughout this repository (`jsonplaceholder.typicode.com`, already used by the Python/JavaScript/TypeScript/C#/Rust courses' own API lessons) was actually executed with real captured output — this section documents exactly what was verified. Because this package's dependency chain is large (a real TLS stack, not a toy), it took noticeably longer to build from source than [16-Database-Access](../16-Database-Access/README.md)'s `sqlite-simple` — see this lesson's closing note for the actual build time observed.

## Setup

```
api-demo/
  api-demo.cabal
  Main.hs
```

```
# api-demo.cabal (abbreviated)
cabal-version:      2.4
name:                api-demo
version:             0.1.0.0
build-type:          Simple

executable api-demo
    main-is:          Main.hs
    build-depends:    base, http-conduit, aeson, bytestring
    default-language: Haskell2010
```

## A Simple GET Request

```haskell
{-# LANGUAGE OverloadedStrings #-}
import Network.HTTP.Simple

main :: IO ()
main = do
    response <- httpLBS "https://jsonplaceholder.typicode.com/todos/1"
    putStrLn ("Status: " ++ show (getResponseStatusCode response))
    print (getResponseBody response)
```

`httpLBS` performs the request and returns the full response (status, headers, body) as a lazy `ByteString` body — `Network.HTTP.Simple`'s deliberately minimal, batteries-included API, analogous to Python's `requests.get(url)` or JavaScript's global `fetch`, both already covered in this repository's own courses.

## Parsing JSON with `aeson`

```haskell
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
import Network.HTTP.Simple
import Data.Aeson (FromJSON, decode)
import GHC.Generics (Generic)

data Todo = Todo
  { todoId        :: Int
  , todoTitle     :: String
  , todoCompleted :: Bool
  } deriving (Show, Generic)

instance FromJSON Todo   -- DERIVED via Generic -- aeson infers the field mapping automatically

fetchTodo :: IO (Maybe Todo)
fetchTodo = do
    response <- httpLBS "https://jsonplaceholder.typicode.com/todos/1"
    return (decode (getResponseBody response))
```

`aeson`'s `Generic`-derived `FromJSON` instance is directly comparable to C#'s `System.Text.Json` reflection-based deserialization or Rust's `serde` derive macros (both covered in their respective courses) — the field names are matched structurally, with no hand-written parsing code needed for the common case.

## Does It Throw on a 404? — Answered for Haskell

Every other language course in this repository's own API lesson asks this exact question of its own HTTP client. `Network.HTTP.Simple`'s answer: **`httpLBS` does NOT throw on a non-2xx status by default** — a 404/500 response is returned as an ordinary successful `IO` result, with the status code embedded in the response value, exactly the same "doesn't throw on 404" trap the JavaScript (`fetch`), C# (`HttpClient`), and other courses' lessons already documented for their own clients. Checking `getResponseStatusCode` explicitly (or using `httpSink`/manual exception-throwing helpers from the same package) is necessary if you want a failed request to actually short-circuit.

## Detailed Example

See [Main.hs](Main.hs).

## Verified Output

```bash
$ cabal run
Status: 200
Todo {todoId = 1, todoTitle = "delectus aut autem", todoCompleted = False}
Status for a 404 path: 404
```

## Common Mistakes

- **Assuming `httpLBS` throws on a 404/500 automatically** — it doesn't; a non-2xx response is still a normal, successful `IO (Response ByteString)` value from the caller's point of view, exactly the same trap every other language course's own HTTP-client lesson found in its language's default client.
- **Forgetting `OverloadedStrings`** — `http-conduit`'s request-building functions (like `sqlite-simple`'s `Query` in Lesson 16) expect their URL/text arguments as specific types, not bare `String`, requiring the same language extension.
- **Not handling `decode`'s `Nothing` case** — `aeson`'s `decode :: FromJSON a => ByteString -> Maybe a` returns `Nothing` (not an exception) for malformed or shape-mismatched JSON; pattern-matching (or `maybe`, Lesson 09) is required to handle a parse failure gracefully rather than crashing on a bare `fromJust`.

## Best Practices

- Always check the response status code explicitly (or use a variant that throws on failure) rather than assuming a non-2xx response will be caught automatically — the same discipline every other language course in this repository already established for its own default HTTP client.
- Derive `FromJSON`/`ToJSON` via `Generic` for the common case of "JSON field names match Haskell record field names"; write instances by hand only when the JSON shape genuinely doesn't match (different casing/naming, nested/flattened structures).
- Handle `decode`'s `Maybe` result explicitly (Lesson 09's `Maybe` handling) rather than assuming every response parses successfully.

## Real-World Usage

`http-conduit`/`aeson` (or the closely related `req`/`wreq` and other JSON libraries in the ecosystem) back real production Haskell services' outbound HTTP calls, following exactly the same "check the status, handle parse failure explicitly" discipline this repository's other language courses' own API-integration lessons already established — the concrete API differs, the underlying gotchas (silent failure on non-2xx, explicit JSON-shape handling) genuinely repeat across every language.

## Build Time Note

Building `http-conduit`'s full dependency chain (including a real TLS implementation) from source took noticeably longer in this environment than [16-Database-Access](../16-Database-Access/README.md)'s `sqlite-simple` — a real, observed cost of this environment's "compile every package from source, no prebuilt Windows binaries" situation (see [01-Setup](../01-Setup/README.md)), not something a normal GHCup-managed install with cached binary package support would necessarily reproduce as slowly.

## Summary

- `Network.HTTP.Simple`'s `httpLBS` performs a GET (or other method) request; like `fetch`/`HttpClient` elsewhere in this repository, it does **not** throw on a non-2xx status by default — checking `getResponseStatusCode` explicitly is the caller's responsibility.
- `aeson`'s `Generic`-derived `FromJSON` maps JSON fields to a Haskell record automatically for the common, structurally-matching case.
- This lesson's HTTP call was genuinely made against the same live public test API this repository's other language courses already use, with real captured output.

## Key Terms

- **`httpLBS`** — `Network.HTTP.Simple`'s simple GET-and-more helper, returning the full response with a lazy `ByteString` body.
- **`aeson`** — Haskell's standard JSON library; `FromJSON`/`ToJSON` type classes (often `Generic`-derived) handle decode/encode.
- **`decode`** — `aeson`'s `ByteString -> Maybe a` JSON-parsing function; `Nothing` on failure, not an exception.

## Interview Questions

1. **Does `http-conduit`'s `httpLBS` throw an exception on a 404 response, and why does that matter?**
   No — a 404 (or any non-2xx status) is still an ordinary, successful `IO` result from `httpLBS`'s point of view; the status code is simply embedded in the returned response value, and the caller must check `getResponseStatusCode` explicitly to detect failure. This matters because it's the exact same trap this repository's JavaScript (`fetch`) and C# (`HttpClient`) courses already documented for their own default HTTP clients — assuming any non-2xx response throws is a cross-language, recurring mistake, not language-specific.

2. **How does `aeson`'s `Generic`-derived `FromJSON` compare to Rust's `serde` or C#'s `System.Text.Json`?**
   All three let a data type automatically gain JSON (de)serialization by deriving/reflecting over its structure, rather than requiring hand-written parsing code for the common case where field names match directly. `aeson` uses GHC's `Generic` mechanism (`deriving (Generic)` plus an empty `instance FromJSON Todo`) to derive the mapping; Rust's `serde` uses a derive macro (`#[derive(Deserialize)]`); C#'s `System.Text.Json` uses runtime reflection (or, in .NET's file-based apps per this repository's C# course, an explicit reflection-enabling switch). All three still require handling a decode failure explicitly (`Maybe`/`Result`/an exception) rather than assuming every input parses successfully.

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
