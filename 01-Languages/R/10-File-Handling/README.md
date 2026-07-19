# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Beginner: `write.csv` / `read.csv` — Genuinely Central to R

CSV round-tripping is one of the most-used operations in real R work, since data frames (Lesson 07) are R's core structure and CSV is the most common plain-text tabular format:

```r
df <- data.frame(name = c("Ann", "Bob"), score = c(91, 78))

write.csv(df, "scores.csv", row.names = FALSE)   # row.names = FALSE avoids an extra unnamed index column
df2 <- read.csv("scores.csv")

identical(df, df2)   # FALSE! - a genuine round-trip gotcha, see below
```

`row.names = FALSE` matters: without it, `write.csv` writes an extra leading column of row numbers (`"1"`, `"2"`, ...) that gets read back in as a column named `X`, silently changing your data frame's shape on the round trip.

**A second, easy-to-miss gotcha found while actually running this**: even with `row.names = FALSE` set correctly, `identical(df, df2)` returns `FALSE`. CSV is plain text with no type metadata, so `read.csv` re-infers every column's type from scratch — a numeric column that happened to hold only whole numbers (`c(91, 78)`, stored internally as `double`) gets read back as `integer`, because `91` and `78` look like whole numbers on disk. `str()` confirms it: the original column is `num`, the round-tripped one is `int`. The *values* are equal (`91 == 91`), but the *storage type* changed, so `identical()` (which checks type too) reports `FALSE`. Use `all.equal()` or compare column-by-column with values only if this distinction doesn't matter to you. This is verified live in `example.R`, including the `str()` output proving exactly where the type changed.

## Intermediate: `read.csv` Type Inference

`read.csv` inspects each column and guesses its type (numeric, character, logical) — usually correct, but a genuine source of subtle bugs with columns like ZIP codes or IDs that look numeric but should stay text (leading zeros get silently dropped). Use `colClasses` to force specific types when this matters:

```r
read.csv("data.csv", colClasses = c(zip = "character"))
```

## Intermediate: JSON with `jsonlite`

Base R has no built-in JSON support; the de-facto standard package is **`jsonlite`** (installed via `install.packages("jsonlite")` for this course, and confirmed working against live CRAN during the build):

```r
library(jsonlite)

data <- list(name = "Ada", age = 36, langs = c("R", "Python"))
json_text <- toJSON(data, auto_unbox = TRUE)   # auto_unbox: length-1 vectors become scalars, not [x] arrays
cat(json_text, "\n")

parsed <- fromJSON(json_text)
print(parsed)
```

`auto_unbox = TRUE` matters: without it, even a single string like `"Ada"` gets JSON-encoded as `["Ada"]` (a one-element array), because every R value is technically a vector (Lesson 03) — `jsonlite` needs to be told explicitly that length-1 vectors should become JSON scalars, not arrays.

## Advanced: Reading/Writing Plain Text

```r
writeLines(c("line one", "line two"), "notes.txt")
lines <- readLines("notes.txt")
print(lines)   # "line one" "line two"
```

## Real-World Usage

- CSV read/write is the backbone of countless real R scripts — pull raw data in, transform it, write results back out, often as the entire "pipeline" for a small analysis.
- `jsonlite` is the standard choice for talking to web APIs that return JSON (Lesson 17) and for config files, since base R alone can't parse JSON.

## Summary

- `write.csv(df, path, row.names = FALSE)` / `read.csv(path)` round-trip data frames to/from CSV; omitting `row.names = FALSE` adds a spurious index column on read-back.
- `read.csv` infers column types automatically; use `colClasses` to force a column (like a ZIP code) to stay character.
- Base R has no built-in JSON support; `jsonlite::toJSON()`/`fromJSON()` is the standard tool, and `auto_unbox = TRUE` avoids wrapping length-1 values in unwanted JSON arrays.
- `writeLines`/`readLines` handle plain text files line-by-line.

## Key Terms

- **`write.csv` / `read.csv`** — base R functions to serialize/deserialize a data frame to/from CSV.
- **`row.names`** — controls whether an extra row-index column is written; `FALSE` avoids it.
- **`jsonlite`** — the standard third-party package for JSON encode/decode in R.
- **`auto_unbox`** — a `jsonlite::toJSON()` option controlling whether length-1 vectors become JSON scalars instead of single-element arrays.

## Common Mistakes

- Forgetting `row.names = FALSE` in `write.csv`, producing an unwanted extra `X`/index column when the file is read back in.
- Assuming `identical(df, read.csv(write.csv(df)))` is `TRUE` — CSV has no type metadata, so a `numeric` (double) column of whole numbers commonly round-trips as `integer`, changing the storage type even though the values are unchanged (confirmed live in this lesson's `example.R`).
- Letting `read.csv` auto-infer a numeric type for an identifier column (like ZIP code) and silently losing leading zeros.
- Forgetting `auto_unbox = TRUE` in `jsonlite::toJSON()` and being surprised every scalar becomes a one-element JSON array.

## Best Practices

- Always pass `row.names = FALSE` to `write.csv` unless you specifically want row names preserved as a column.
- Explicitly set `colClasses` for any column where numeric auto-inference would lose information (IDs, ZIP/postal codes, phone numbers).
- Use `jsonlite::toJSON(..., auto_unbox = TRUE)` for round-trippable, non-surprising JSON output.

## Interview Questions

1. **Why is `row.names = FALSE` important when calling `write.csv`?**
   Without it, `write.csv` writes an extra leading column of row numbers into the CSV, which then gets read back in as an unwanted `X` column, silently changing the round-tripped data frame's shape.

2. **Does base R have built-in JSON support?**
   No — `jsonlite` (a third-party CRAN package) is the de-facto standard for JSON encoding/decoding; there's nothing equivalent in base R itself.

3. **What does `auto_unbox = TRUE` do in `jsonlite::toJSON()`?**
   It tells `jsonlite` to encode length-1 R vectors as JSON scalars (`"Ada"`) instead of the default behavior of encoding every vector as a JSON array (`["Ada"]`), since R has no separate scalar type (Lesson 03).

## Suggested Next Lesson

[11 — OOP Systems](../11-OOP-Systems/README.md)
