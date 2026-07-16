# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Beginner: `open()` and `with`

`open(path, mode)` returns a file object. The file must eventually be closed to flush buffered writes and release the OS file handle — the `with` statement guarantees that happens automatically, even if an exception is raised inside the block.

```python
with open("notes.txt", "w") as f:
    f.write("first line\n")
    f.write("second line\n")
# f.closed is True here - the file was closed automatically on exiting the `with` block

with open("notes.txt", "r") as f:
    contents = f.read()
print(contents)
```

Common modes: `"r"` (read, default, errors if the file doesn't exist), `"w"` (write, **overwrites** the entire file if it exists, creates it if not), `"a"` (append, adds to the end without erasing existing content), and adding `"b"` to any of them (`"rb"`, `"wb"`) switches to binary mode instead of text mode.

Never manage files with manual `open()`/`close()` calls — if an exception occurs between them, `close()` is skipped and the file handle leaks. `with` calls `close()` via the file object's context manager protocol no matter how the block exits.

## Beginner: Reading Line by Line

```python
with open("notes.txt", "r") as f:
    for line in f:              # iterates lazily, one line at a time
        print(line.strip())     # .strip() removes the trailing newline

with open("notes.txt", "r") as f:
    lines = f.readlines()       # eagerly loads ALL lines into a list
```

Iterating over a file object directly (`for line in f:`) reads one line at a time without loading the whole file into memory, which matters for large files. `.readlines()` (or `.read()`) loads everything at once — fine for small files, wasteful or impossible for huge ones.

## Intermediate: Reading and Writing JSON

The stdlib `json` module converts between Python objects (dict, list, str, int, float, bool, `None`) and JSON text.

```python
import json

data = {"name": "Ada", "age": 36, "roles": ["admin", "user"]}

with open("data.json", "w") as f:
    json.dump(data, f, indent=2)     # write directly to a file object

with open("data.json", "r") as f:
    loaded = json.load(f)            # read directly from a file object

print(loaded == data)   # True - round-tripped without loss
```

`json.dump`/`json.load` work with file objects; `json.dumps`/`json.loads` (with an `s`, for "string") work with in-memory strings instead — useful when you already have JSON text from somewhere other than a file, like an HTTP response body.

## Advanced: `pathlib`

`pathlib.Path` represents filesystem paths as objects instead of raw strings, and works consistently across Windows and POSIX path separators.

```python
from pathlib import Path

p = Path("data") / "reports" / "q1.json"   # / builds paths - no manual string concatenation
print(p)                    # data/reports/q1.json (or data\reports\q1.json on Windows, printed with the OS's separator)
print(p.name)               # q1.json
print(p.stem)               # q1 (no extension)
print(p.suffix)             # .json
print(p.parent)             # data/reports

current_dir = Path(".")
py_files = list(current_dir.glob("*.py"))    # non-recursive glob
all_py_files = list(current_dir.rglob("*.py"))  # recursive glob

p.parent.mkdir(parents=True, exist_ok=True)  # create directories as needed, don't error if they exist
```

`Path` objects also support `.exists()`, `.is_file()`, `.is_dir()`, `.read_text()`/`.write_text()` (open+read/write+close in one call), making a lot of common file operations shorter than the equivalent `os.path` string-based code.

## Real-World Usage

- Config files are commonly JSON (or YAML, via a third-party library) — `json.load` turns a config file straight into a dict your program can use.
- Log files are read/appended line-by-line (`"a"` mode) so each run adds to the same file without erasing history.
- `pathlib` is the modern standard for any path manipulation (finding files by pattern, building cross-platform paths, checking existence) — new code should prefer it over the older `os.path` string-based functions.
- Data pipelines read/write intermediate results as JSON or CSV files between processing stages.

## Summary

- `open()` with `with` guarantees the file is closed even if an exception occurs inside the block; never manage files with manual open/close.
- Modes: `"r"` read, `"w"` overwrite/create, `"a"` append; add `"b"` for binary.
- Iterating a file object directly reads lazily, line by line; `.read()`/`.readlines()` load everything into memory at once.
- `json.dump`/`json.load` work with file objects; `json.dumps`/`json.loads` work with in-memory strings.
- `pathlib.Path` represents paths as objects, supports `/` for joining, and provides properties (`.name`, `.stem`, `.suffix`, `.parent`) and methods (`.exists()`, `.glob()`, `.read_text()`) that are clearer than raw string manipulation.

## Key Terms

- **Context manager** — an object implementing `__enter__`/`__exit__`, used with `with` to guarantee setup/cleanup (a file object is one).
- **Mode** — the string passed to `open()` controlling read/write/append and text/binary behavior.
- **Lazy iteration** — reading a file one line at a time on demand, instead of loading the entire contents upfront.
- **Serialization** — converting an in-memory object (like a dict) into a storable/transmittable format (like JSON text), and back (deserialization).
- **`pathlib.Path`** — an object-oriented representation of a filesystem path, replacing string-based `os.path` operations.

## Common Mistakes

- Opening a file without `with` and forgetting to call `.close()`, leaking file handles (especially costly if it happens in a loop).
- Opening in `"w"` mode when you meant `"a"`, silently erasing an existing file's contents.
- Loading a huge file entirely into memory with `.read()`/`.readlines()` when lazy line-by-line iteration would have worked.
- Forgetting that `json.dump`/`json.load` want a **file object**, while `json.dumps`/`json.loads` want a **string** — mixing them up raises a `TypeError`.
- Building paths with manual string concatenation (`dir + "/" + filename`) instead of `pathlib`, which breaks on Windows where the separator is `\`.

## Best Practices

- Always use `with open(...) as f:` — never bare `open()`/`close()`.
- Use `pathlib.Path` for any nontrivial path construction or inspection instead of raw strings or `os.path`.
- Prefer iterating a file object directly over `.readlines()` unless you specifically need all lines as a list at once.
- Use `json.dump(..., indent=2)` for any JSON meant to be read by a human later (config, saved state); omit `indent` for compact machine-to-machine JSON.
- Call `.mkdir(parents=True, exist_ok=True)` before writing to a path whose parent directories might not exist yet, rather than assuming they do.

## Interview Questions

1. **Why is `with open(...) as f:` preferred over manual `open()`/`close()` calls?**
   `with` guarantees `f.close()` runs when the block exits, even if an exception is raised partway through — manual `close()` calls are skipped if an exception occurs before reaching them, leaking the file handle.

2. **What's the difference between `json.dump`/`json.load` and `json.dumps`/`json.loads`?**
   The versions without `s` (`dump`, `load`) read from or write to a file object directly. The versions with `s` (`dumps`, `loads`) convert to/from an in-memory Python string instead — useful when the JSON text comes from or goes to something other than a file, like a network response.

3. **What happens if you open an existing file in `"w"` mode?**
   Its entire existing content is immediately erased (truncated to zero length) the moment the file is opened, before you've even written anything new. If you wanted to keep existing content and add to it, you needed `"a"` (append) mode instead.

4. **Why might iterating over a file object with `for line in f:` be preferable to `f.readlines()`?**
   `for line in f:` reads and yields one line at a time (lazy iteration), keeping memory usage roughly constant regardless of file size. `.readlines()` reads the entire file into memory as a list of all lines upfront, which can be wasteful or even impossible for very large files.

5. **What advantages does `pathlib.Path` offer over building paths with string concatenation?**
   `Path` handles OS-specific path separators automatically (so the same code works on Windows and POSIX), supports the `/` operator for readable path-joining, and exposes convenient properties/methods (`.name`, `.stem`, `.suffix`, `.exists()`, `.glob()`) that would otherwise require separate `os.path` function calls with more verbose syntax.

## Suggested Next Lesson

[11 — OOP](../11-OOP/README.md)
