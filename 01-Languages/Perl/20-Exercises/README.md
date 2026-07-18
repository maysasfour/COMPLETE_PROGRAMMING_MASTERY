# 20 — Exercises

Seven standalone problems spanning the whole course. Solutions in [21-Solutions](../21-Solutions/README.md).

1. **Word frequency counter.** Given a paragraph of text, split it into words (case-insensitive) and print each word's count, sorted by count descending.
2. **`Version` string comparator.** Write a sub `compare_versions($a, $b)` that correctly orders `"1.9.0"` before `"1.10.0"` (a real semantic-vs-lexical trap — plain `cmp` gets this wrong).
3. **Retry-with-backoff.** Write a sub `retry_with_backoff($fn, $max_attempts)` that calls `$fn->()`, retrying on `die`, doubling a sleep delay each attempt, and re-raising after the final failed attempt.
4. **Custom exception hierarchy.** Build `AppError` (base, bless-based), `NotFoundError`/`ValidationError` (both `@ISA = ('AppError')`), and demonstrate catching by type with `try`/`catch` and `->isa()`.
5. **Enumerable-style pipeline.** Given an array of hashrefs representing people (`{name, age}`), use `grep`/`map`/`sort` to find the names of everyone 18+, sorted alphabetically.
6. **Config validator via hash slice.** Given `%config` and a list of required keys, use a hash slice to check all required keys are present and defined, reporting which (if any) are missing.
7. **Mini file-based key/value store.** Using `JSON::PP` + file I/O (Lesson 10's technique), write `kv_set($key, $value)` and `kv_get($key)` subs backed by a JSON file, and prove a value round-trips.
