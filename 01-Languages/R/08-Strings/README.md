# 08 — Strings

[Back to course overview](../README.md) | [Previous: Vectors, Lists, and Data Frames](../07-Vectors-Lists-and-Data-Frames/README.md)

## Beginner: `paste` and `paste0`

```r
paste("Hello", "World")     # "Hello World" - joins with a space by default
paste("Hello", "World", sep = "-")  # "Hello-World"
paste0("Hello", "World")    # "HelloWorld" - shorthand for paste(..., sep = "")
```

`paste`/`paste0` are also vectorized: given vectors, they combine element-wise (with recycling, Lesson 04, if lengths differ):

```r
paste0("item_", 1:3)   # "item_1" "item_2" "item_3"
```

`paste(v, collapse = ", ")` instead joins *all elements of one vector* into a single string:

```r
paste(c("a", "b", "c"), collapse = ", ")   # "a, b, c"
```

## Beginner: `sprintf` — Format Strings

```r
sprintf("Name: %s, Age: %d", "Ada", 36)   # "Name: Ada, Age: 36"
sprintf("Pi is %.2f", pi)                  # "Pi is 3.14"
```

`sprintf` follows C-style format specifiers (`%s` string, `%d` integer, `%f` float with optional precision) and is vectorized like `paste`.

## Beginner: `nchar`, `toupper`/`tolower`, `substr`

```r
nchar("hello")             # 5
toupper("hello")           # "HELLO"
tolower("HELLO")           # "hello"
substr("hello world", 1, 5)  # "hello" - 1-based, inclusive on both ends
```

## Intermediate: Splitting and Trimming

```r
strsplit("a,b,c", ",")      # list("a", "b", "c") - note: returns a LIST, one element per input string
trimws("  padded  ")        # "padded"
gsub(" ", "_", "hello world")  # "hello_world" - replace ALL matches
sub(" ", "_", "hello world")   # "hello_world" - replace only the FIRST match (same here, one space)
```

`strsplit` returning a list (rather than a plain vector) surprises newcomers — it's designed to handle a vector of *multiple* input strings at once, each producing its own vector of pieces, hence the outer list.

## Advanced: Regex in Base R

`grepl`, `grep`, `gsub`, and `sub` all accept regular expressions:

```r
grepl("^[A-Z]", c("Apple", "banana", "Cherry"))  # TRUE FALSE TRUE - starts with uppercase?
gsub("[aeiou]", "*", "hello world")                # "h*ll* w*rld" - replace all vowels
```

## Real-World Usage

- `sprintf`/`paste0` are the standard way to build dynamic messages, file paths, and labels in reports and plots.
- `gsub`/`grepl` regex operations are common in data-cleaning scripts — normalizing inconsistent text data (extra whitespace, mixed case, unwanted punctuation) before analysis.

## Summary

- `paste`/`paste0` join strings (vectorized, with `sep`/`collapse` controlling how); `sprintf` formats with C-style specifiers.
- `nchar`, `toupper`/`tolower`, `substr` cover length, casing, and substring extraction (1-based, inclusive).
- `strsplit` returns a **list**, one element per input string, because it's designed for vectors of multiple strings at once.
- `gsub`/`sub`/`grepl`/`grep` support regular expressions for pattern-based replace/match; `gsub` replaces all matches, `sub` only the first.

## Key Terms

- **`paste0`** — `paste` with `sep = ""`, concatenating with no separator.
- **`sprintf`** — C-style format-string function.
- **`strsplit`** — splits string(s) on a delimiter/pattern, returning a list (one vector of pieces per input string).
- **`gsub` / `sub`** — global vs. first-match-only pattern replacement.

## Common Mistakes

- Expecting `strsplit()` to return a plain character vector directly — it returns a list; you typically need `strsplit(x, ",")[[1]]` to get the vector for a single input string.
- Confusing `gsub` (replace all) with `sub` (replace only the first match).
- Forgetting `substr` is 1-based and inclusive on both endpoints, unlike 0-based half-open slicing in other languages.

## Best Practices

- Use `sprintf` for anything with multiple interpolated values and specific formatting (decimal places, padding); use `paste0` for simple concatenation.
- Always check whether you need `strsplit(x, sep)[[1]]` (single string) vs. the full list (multiple strings).
- Prefer `gsub` over manually looping `sub` repeatedly when you want every match replaced.

## Interview Questions

1. **What's the difference between `paste` and `paste0`?**
   `paste0(...)` is shorthand for `paste(..., sep = "")` — no separator between concatenated pieces; `paste` defaults to a single space separator (customizable via `sep`).

2. **Why does `strsplit()` return a list instead of a vector?**
   Because it's designed to accept a vector of multiple input strings at once — each input string produces its own vector of split pieces, and those per-string vectors are collected into an outer list (since they may have different lengths).

3. **What's the difference between `gsub` and `sub`?**
   `gsub` replaces every match of the pattern; `sub` replaces only the first match found in each string.

## Suggested Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
