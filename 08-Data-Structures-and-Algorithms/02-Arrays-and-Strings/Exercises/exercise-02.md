# Exercise 02 — Implement First-Unique-Character

[Back to lesson](../README.md)

## Task

Write a function `first_unique_char(text)` that returns the **index** of the first character in `text` that does not repeat anywhere else in the string. If no such character exists, return `-1`.

```python
first_unique_char("swiss")      # -> 1  ('w' is the first character that never repeats)
first_unique_char("aabbcc")     # -> -1 (every character repeats)
first_unique_char("x")          # -> 0
first_unique_char("")           # -> -1
```

## Requirements

- Your solution should be O(n) time — building a frequency count (like `is_anagram` in `implementation.py`) and then a second pass to find the first count-of-1 character is the intended approach. An O(n^2) solution (checking each character against every other character) will work correctly but does not meet the complexity requirement — implement it, but also state its complexity honestly in a comment.
- Handle the empty string and single-character cases without a special-case `if` at the top (they should fall out naturally from the general algorithm).

## Deliverable

A working `first_unique_char` function (test it against the four examples above), plus a one-sentence complexity justification.
