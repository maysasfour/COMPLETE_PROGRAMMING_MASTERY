# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Beginner: Strings Are Immutable

A Python `str` cannot be changed in place. Every operation that looks like it "modifies" a string actually builds and returns a **new** string object.

```python
name = "python"
name[0] = "P"        # TypeError: 'str' object does not support item assignment

name = "P" + name[1:]  # this works - it builds a brand new string
```

This matters for performance and for reasoning about code: if you pass a string into a function, the function can never mutate your variable's contents — it can only return a new string, which you must capture (`name = name.upper()`, not just `name.upper()`).

## Beginner: Indexing and Slicing

Strings are ordered sequences of characters, indexed from `0`, with negative indices counting from the end.

```python
s = "Python"
s[0]      # 'P' - first character
s[-1]     # 'n' - last character
s[2:4]    # 'th' - slice: start inclusive, stop exclusive
s[:3]     # 'Pyt' - omit start, defaults to 0
s[3:]     # 'hon' - omit stop, defaults to end
s[::2]    # 'Pto' - step of 2, every other character
s[::-1]   # 'nohtyP' - negative step walks backward, a common reverse idiom
```

Slicing never raises an `IndexError` even if the range overshoots (`s[2:100]` just returns to the end) — only direct indexing (`s[100]`) can raise one.

## Intermediate: f-Strings and Format Specs

f-strings (formatted string literals, `f"..."`) embed expressions directly in the string and evaluate them at runtime. They also support a **format spec** after a colon for controlling precision, width, and alignment.

```python
pi = 3.14159265
name = "Ada"

f"{pi:.2f}"        # '3.14' - fixed to 2 decimal places
f"{name:>10}"      # '       Ada' - right-align in a 10-char field
f"{name:<10}|"     # 'Ada       |' - left-align in a 10-char field
f"{name:^10}|"     # '   Ada    |' - center-align in a 10-char field
f"{name!r}"        # "'Ada'" - !r calls repr() instead of str()
```

`!r` is especially useful in debugging output: `repr()` shows quotes around strings and disambiguates `None` from the string `"None"`, which plain `str()` (the default in an f-string) does not.

## Intermediate: Common String Methods

These return new strings (or new lists) — none of them mutate the original.

```python
"  hi  ".strip()             # 'hi' - removes leading/trailing whitespace
"a,b,c".split(",")           # ['a', 'b', 'c'] - splits into a list
",".join(["a", "b", "c"])    # 'a,b,c' - the inverse of split, joins a list into one string
"cat".replace("c", "b")      # 'bat' - substring replacement
"Cat".upper()                # 'CAT'
"Cat".lower()                # 'cat'
"file.txt".startswith("file")  # True
"file.txt".endswith(".txt")    # True
"file.txt".find("txt")         # 5 - index of first match, or -1 if not found
```

`.find()` returns `-1` on failure instead of raising, which makes it suitable for `if s.find(x) != -1:` checks; the related `.index()` method behaves the same but *raises* `ValueError` if the substring isn't found — pick whichever failure mode your logic wants.

## Advanced: Encoding — `str` vs `bytes`

A Python `str` is a sequence of Unicode *characters* — an abstract representation with no fixed size in memory. A `bytes` object is a sequence of raw *bytes* — what actually gets written to a file, sent over a network socket, or stored on disk. Converting between them requires picking a text **encoding**, a rulebook for mapping characters to byte sequences.

```python
text = "café"
encoded = text.encode("utf-8")     # b'caf\xc3\xa9' - bytes object
decoded = encoded.decode("utf-8")  # 'café' - back to str

len(text)      # 4 - four characters
len(encoded)   # 5 - 'é' takes 2 bytes in UTF-8
```

**UTF-8 is Python 3's default** for `.encode()`/`.decode()`, for `open()` in text mode, and for source file encoding. It is also the dominant encoding on the modern web and in most APIs, so unless you have a specific reason (a legacy system that emits `latin-1` or `utf-16`, for instance), UTF-8 is the safe default assumption. Decoding bytes with the wrong encoding either raises `UnicodeDecodeError` or silently produces garbled ("mojibake") text — always know which encoding produced the bytes you're decoding.

## Real-World Usage

- f-strings with format specs are the standard way to render tables, currency, and percentages in CLI output and logs (`f"{price:.2f}"`, `f"{name:<20}{score:>5}"`).
- `.strip()` + `.split()` is the bread-and-butter combo for parsing lines from a config file or CSV-like text input.
- `.encode("utf-8")` / `.decode("utf-8")` show up constantly at I/O boundaries — reading a file opened in binary mode, sending data over a socket, or calling an HTTP API that returns raw bytes.
- `!r` in f-strings is a debugging habit worth building — `print(f"got {value!r}")` disambiguates `''`, `None`, and `'None'` at a glance in logs.

## Summary

- Strings are immutable; every "modifying" method returns a new string.
- Slicing (`s[start:stop:step]`) supports negative indices and steps, and never raises `IndexError` for out-of-range slices.
- f-strings evaluate expressions inline and support format specs (`.2f`, alignment with `<`/`>`/`^`, `!r` for `repr()`).
- Common methods (`strip`, `split`, `join`, `replace`, `upper`/`lower`, `startswith`/`endswith`, `find`) cover the vast majority of everyday text processing.
- `str` is Unicode text; `bytes` is raw binary data. `.encode()` turns `str` into `bytes`; `.decode()` turns `bytes` back into `str`. UTF-8 is the default and safest assumption.

## Key Terms

- **Immutability** — once created, a string's contents can never be changed in place; operations produce new string objects.
- **Slice** — a `start:stop:step` sub-sequence extraction, with `stop` exclusive.
- **Format spec** — the part after `:` inside an f-string's `{}`, controlling precision, width, and alignment.
- **Encoding** — a rulebook mapping Unicode characters to byte sequences (e.g., UTF-8, UTF-16, ASCII).
- **`bytes`** — an immutable sequence of raw byte values, distinct from `str`'s sequence of characters.

## Common Mistakes

- Forgetting that string methods don't mutate: writing `name.upper()` alone and expecting `name` itself to change, instead of `name = name.upper()`.
- Confusing `.find()` (`-1` on failure) with `.index()` (raises `ValueError` on failure) and letting an unhandled exception crash the program.
- Assuming `len(a_string)` equals the number of bytes it occupies once encoded — multi-byte UTF-8 characters make these differ.
- Decoding bytes with the wrong encoding and getting garbled text (or a `UnicodeDecodeError`) instead of checking what encoding actually produced the bytes.
- Using `str()` instead of `!r`/`repr()` when debugging, which hides whether a value is `None`, an empty string, or has stray whitespace.

## Best Practices

- Always specify the encoding explicitly when calling `.encode()`/`.decode()` or opening a file in text mode (`encoding="utf-8"`) rather than relying on a platform default that can vary between systems.
- Prefer f-strings over `%`-formatting or `.format()` for new code — they're more readable and typically faster.
- Use `.strip()` defensively on any text read from user input or external files before comparing or parsing it.
- Reach for `"".join(list_of_strings)` instead of building a string with `+=` in a loop — repeated concatenation is O(n²) while `join` is O(n).

## Interview Questions

1. **Why is Python's `str` immutable, and what's the practical consequence?**
   Immutability lets strings be safely shared, hashed (usable as dict keys), and reasoned about without defensive copying. The practical consequence is that every string "modification" — `.upper()`, `.replace()`, slicing — returns a brand-new string object; you must reassign the result to see the change (`s = s.upper()`), not just call the method.

2. **What's the difference between `.find()` and `.index()` for substring search?**
   Both return the index of the first match, but `.find()` returns `-1` if the substring isn't found while `.index()` raises `ValueError`. Use `.find()` when "not found" is an expected, normal outcome you'll branch on; use `.index()` when not finding it should be treated as an exceptional error.

3. **What does the format spec `.2f` do inside an f-string, and how is it different from `!r`?**
   `.2f` is inside the format spec (after `:`) and formats a float to a fixed 2 decimal places. `!r` is a conversion flag (before any `:`) that calls `repr()` on the value instead of the default `str()` — it's for representation/debugging, not numeric formatting, and the two can be combined in principle but serve very different purposes.

4. **Why does `len("café")` not equal `len("café".encode("utf-8"))`?**
   `len()` on a `str` counts Unicode *characters*; `len()` on `bytes` counts raw *bytes*. In UTF-8, ASCII characters take 1 byte but characters like `é` take 2 (or more, for other scripts), so a 4-character string can encode to more than 4 bytes.

5. **Why should you avoid building a large string with repeated `+=` in a loop?**
   Because strings are immutable, each `+=` creates an entirely new string and copies all the previous content into it, making the total cost of `n` concatenations O(n²). `"".join(parts)` (or a list you extend and join once at the end) builds the result in O(n) because it only allocates the final string once.

## Suggested Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
