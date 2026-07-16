# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Read and write text files using Node's `fs` module, both synchronously and asynchronously.
- Choose correctly between the sync, callback, and Promise-based `fs` APIs.
- Read and write JSON files.
- Build file paths safely with `path.join`, independent of operating system.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md)

## Concept

Browsers deliberately have no general file-system access (a security boundary — see [16-Security](../../../16-Security/)); file I/O is a Node-specific capability via the built-in `node:fs` module. `fs` ships **three** parallel APIs for the same operations: synchronous (`fs.readFileSync`, blocks the event loop until done), callback-based (`fs.readFile(path, cb)`, the original Node style), and Promise-based (`fs.promises.readFile` / `require("node:fs/promises")`, the modern style used with `async`/`await`). This course uses the Promise-based API almost exclusively, since it composes cleanly with `async`/`await` (Lesson 14).

## Syntax

```js
const { readFile, writeFile } = require("node:fs/promises");
const path = require("node:path");

const filePath = path.join(__dirname, "notes.txt");

async function main() {
  await writeFile(filePath, "Hello, file system!\n", "utf8");
  const contents = await readFile(filePath, "utf8");
  console.log(contents);
}
main();
```

(This lesson's code uses `require()` — CommonJS, Node's original module system — since these lesson files have no `package.json` declaring `"type": "module"`. The modern `import`/`export` syntax works identically for these APIs once a project opts into ES modules; Lesson 15 covers the difference.)

`path.join(...)` builds a path using the correct separator for the current OS (`\` on Windows, `/` on macOS/Linux) — hardcoding `"folder/file.txt"` works by accident on Unix-likes but is not portable.

## Reading and Writing JSON

```js
const { readFile, writeFile } = require("node:fs/promises");

async function saveConfig(config) {
  await writeFile("config.json", JSON.stringify(config, null, 2), "utf8");
}

async function loadConfig() {
  const raw = await readFile("config.json", "utf8");
  return JSON.parse(raw);
}
```

`JSON.stringify(value, null, 2)` — the third argument (`2`) pretty-prints with 2-space indentation, making the file human-readable; omit it for compact single-line output. There is no built-in equivalent of Python's `pathlib`-style object-oriented paths in the standard `fs`/`path` modules — paths are handled as plain strings passed through `path.join`/`path.resolve`.

## Handling Missing Files

```js
const { readFile } = require("node:fs/promises");

async function loadOrDefault(filePath, defaultValue) {
  try {
    const raw = await readFile(filePath, "utf8");
    return JSON.parse(raw);
  } catch (err) {
    if (err.code === "ENOENT") {
      return defaultValue; // file doesn't exist yet -- not necessarily an error
    }
    throw err; // any other failure (permissions, invalid JSON) should propagate
  }
}
```

`err.code === "ENOENT"` ("Error NO ENTry") is the standard Node way to detect "file not found" specifically, distinguishing it from other failure reasons (permission denied, disk error, invalid JSON) that shouldn't be silently treated the same way.

## Detailed Example

See [example.js](example.js) — writes a text file, reads it back, writes/reads a JSON config file, and demonstrates the `ENOENT` pattern for a missing file. Uses a temp file inside the lesson folder, cleaned up at the end of the script.

## Expected Output

Running `node example.js` prints the written-then-read-back text content, the round-tripped JSON config object, and confirms that reading a genuinely missing file returns a supplied default instead of crashing, while re-throwing for the specific "file exists but contains invalid JSON" case.

## Common Mistakes

- Using the synchronous `fs` API (`readFileSync`) inside a server request handler — it blocks the entire event loop, meaning **every other simultaneous request** waits, unlike Python where blocking I/O in one thread doesn't necessarily stall unrelated request-handling threads.
- Concatenating path segments with a hardcoded `/` or `\`, breaking on the other OS.
- Not distinguishing `ENOENT` (file missing) from other read failures, treating every error identically.
- Forgetting the `"utf8"` encoding argument, which causes `readFile` to return a raw `Buffer` instead of a string.

## Best Practices

- Default to the Promise-based `fs/promises` API with `async`/`await` for anything running inside a server or long-lived process; reserve `readFileSync`/`writeFileSync` for one-off CLI scripts and startup-time config loading, where blocking briefly is harmless.
- Always build paths with `path.join`/`path.resolve`, never manual string concatenation.
- Catch and branch on `err.code` (`"ENOENT"`, `"EACCES"`, etc.) rather than treating every file-system error identically.
- Pretty-print JSON files meant for humans to read/edit (`JSON.stringify(data, null, 2)`); compact JSON is fine for machine-only files.

## Real-World Usage

Config files, log files, and local caches in Node CLI tools and backend services are read/written through exactly these patterns; this same `ENOENT`-checking idiom is standard in build tools checking for optional config files (`.eslintrc`, `tsconfig.json`) before falling back to defaults.

## Security Considerations

Never build a file path by directly concatenating user-supplied input (`readFile("/uploads/" + userInput)`) — this is a **path traversal** vulnerability if `userInput` contains `../../etc/passwd`-style sequences. Validate/sanitize any user-controlled path segment, or restrict it to a known safe set of filenames (see [16-Security](../../../16-Security/)).

## Summary

- `node:fs/promises` is the modern, `async`/`await`-friendly file API; avoid the synchronous API in servers.
- `path.join`/`path.resolve` build OS-portable paths; never hardcode separators.
- `JSON.stringify`/`JSON.parse` handle JSON files; the pretty-print third argument (`null, 2`) is worth using for human-edited files.
- Check `err.code === "ENOENT"` to distinguish "file doesn't exist" from other failures.

## Key Terms

- **`fs` (File System module)** — Node's built-in module for reading/writing files and directories.
- **`ENOENT`** — the Node error code meaning "no such file or directory."
- **Path traversal** — a vulnerability where unsanitized user input in a file path escapes the intended directory (e.g., via `../`).

## Interview Questions

1. **Why does Node offer three different APIs (`sync`, callback, Promise-based) for the same file operations?**
   Historically, callbacks were Node's original async pattern before Promises existed; the synchronous API exists for startup-time/CLI-script convenience where blocking briefly is harmless; the Promise-based API (`fs/promises`) was added later to compose cleanly with `async`/`await`, and is the recommended default for anything running inside a long-lived process like a server.

2. **Why is `readFileSync` dangerous inside a server request handler?**
   Node runs on a single thread with an event loop; a synchronous file read blocks that entire thread until the disk I/O completes, meaning every other in-flight request — not just the one that triggered the read — stalls for the same duration. The async/Promise-based API instead yields control back to the event loop while I/O is in progress.

3. **How do you distinguish "file not found" from other file-read errors in Node?**
   Catch the error and check `err.code === "ENOENT"` — Node's file-system errors carry a standardized `.code` string identifying the specific OS-level errno, letting you handle "missing file" differently from "permission denied" (`EACCES`) or other failures.

## Recommended Next Lesson

[11 — OOP](../11-OOP/README.md)
