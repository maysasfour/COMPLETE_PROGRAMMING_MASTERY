# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Read and write files with `File`/`IO` (`File.read`, `File.write`, `File.open`, `File.foreach`).
- Use Ruby's genuinely built-in JSON support (`require "json"`, no gem install needed) to serialize and parse structured data.
- Understand `JSON.parse`'s default string-keyed `Hash` result vs. `symbolize_names: true`.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md)

## Concept

`File`/`IO` cover the usual file operations: `File.write`/`File.read` for whole-file text, `File.open(path, "a") { |f| ... }` for append mode with automatic closing via the block form, and `File.foreach` for line-by-line iteration without loading the whole file into memory.

The positive point genuinely worth documenting the same way this repository calls out other languages' JSON situations: **JSON support ships in Ruby's standard library** (`require "json"`), needing zero `gem install` — `JSON.pretty_generate`/`JSON.parse` are simply always available. `JSON.parse` returns a `Hash` with **string** keys by default (`{"name" => "Ada"}`), not symbol keys — `symbolize_names: true` must be passed explicitly to get `{name: "Ada"}` back, a small but real gotcha given how idiomatic symbol keys are elsewhere in Ruby (Lesson 03).

## Detailed Example

See [example.rb](example.rb) — writing/reading/appending a text file, `File.foreach` line iteration, `File.exist?`/`File.size`, then `JSON.pretty_generate` writing a nested Hash to disk, `JSON.parse` reading it back with default string keys, and the same parse repeated with `symbolize_names: true` to get symbol keys instead. Cleans up its own temp directory (`tmp_data/`) at the end via `FileUtils.rm_rf`.

## Run It

```bash
cd 01-Languages/Ruby/10-File-Handling
ruby example.rb
```

## Expected Output (real, captured)

```
line one
line two
line three
> line one
> line two
> line three
> appended line
exists? true
size: 47 bytes
{
  "name": "Ada",
  "langs": [
    "Ruby",
    "Python"
  ],
  "active": true,
  "meta": {
    "age": 36
  }
}
Hash
Ada
{"name" => "Ada", "langs" => ["Ruby", "Python"], "active" => true, "meta" => {"age" => 36}}
Ada
cleaned up: true
```

## Common Mistakes

- Assuming `JSON.parse` returns symbol keys by default — it doesn't; `parsed[:name]` would return `nil` unless `symbolize_names: true` was passed, verified directly above (the default-parse Hash uses `"name"`, not `:name`).
- Forgetting `File.open` without a block leaves the file handle open — always prefer the block form (`File.open(path) { |f| ... }`), which closes the file automatically even if an exception is raised inside the block.
- Not creating the parent directory before writing a file into it — `File.write` raises `Errno::ENOENT` if the directory doesn't exist yet; `FileUtils.mkdir_p` (used in this lesson) creates it (and any missing parents) first.

## Best Practices

- Always use the block form of `File.open` so the file is closed automatically, even on an exception.
- Pass `symbolize_names: true` to `JSON.parse` when the resulting Hash's keys will be used as symbols elsewhere in the code (matching Lesson 03's idiomatic symbol-key convention).
- Clean up any temp files/directories a script creates, exactly as this lesson's example does with `FileUtils.rm_rf` at the end.

## Real-World Usage

Rails' `config/*.json`/API response bodies are read via exactly this `File.read` + `JSON.parse` pattern; Ruby CLI tools (Bundler's own `Gemfile.lock` internals, RSpec's cached example status) rely on the standard library's built-in JSON support with no external dependency.

## Summary

- `File`/`IO` provide standard read/write/append/line-iteration operations, with the block form of `File.open` auto-closing.
- JSON is genuinely part of Ruby's standard library (`require "json"`) — no gem install needed, unlike some ecosystems.
- `JSON.parse` defaults to string-keyed Hashes; `symbolize_names: true` is needed for symbol keys.

## Key Terms

- **`symbolize_names`** — a `JSON.parse` option converting resulting Hash keys to symbols instead of the default strings.

## Interview Questions

1. **Does Ruby need a third-party library for JSON, the way some languages do?**
   No — `require "json"` loads JSON support directly from Ruby's standard library, with zero `gem install` needed for `JSON.parse`/`JSON.generate`/`JSON.pretty_generate`. This is a genuine, positive point worth contrasting with ecosystems where JSON support requires an external dependency.

2. **Why might `parsed[:name]` return `nil` right after a successful `JSON.parse`?**
   `JSON.parse` returns a Hash with **string** keys by default (`{"name" => "Ada"}`), not symbols — looking it up with the symbol `:name` misses entirely. Passing `symbolize_names: true` to `JSON.parse` converts every key to a symbol during parsing, verified directly in this lesson by parsing the identical JSON string both ways and comparing the results.

## Recommended Next Lesson

[11 — OOP](../11-OOP/README.md)
