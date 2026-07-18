# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Use string interpolation (`"#{expr}"`) and heredocs for multi-line text.
- Understand that Ruby strings are **mutable** — a genuine, direct contrast with Python's immutable `str` — and see the difference between a mutating (`<<`, bang methods) and a non-mutating (`+`) operation, proven with `object_id`.
- Use common string methods (`strip`, `split`, `gsub`, `center`).

## Prerequisites

[07-Collections](../07-Collections/README.md)

## Concept

Ruby strings interpolate with `"#{expression}"` inside double-quoted strings (single-quoted strings do not interpolate). The genuinely distinctive point, worth contrasting directly with Python (where every `str` operation always returns a brand-new immutable object): **Ruby strings are mutable**. `<<` (append) and "bang" methods (`upcase!`, `gsub!`) mutate the *same* string object in place, while `+` allocates and returns a *new* string, leaving the original untouched. This lesson proves the difference directly with `object_id`, not just by describing it.

Heredocs (`<<~TEXT ... TEXT`) provide clean multi-line string literals; the squiggly variant (`<<~`) strips each line's common leading indentation, letting the heredoc body be indented to match surrounding code without that indentation leaking into the string's actual content.

## Detailed Example

See [example.rb](example.rb) — interpolation, `<<` mutating in place (same `object_id`) vs. `+` allocating a new string (different `object_id`), a bang method (`upcase!`) mutating in place, a squiggly heredoc vs. a plain heredoc that keeps its indentation, and common string methods (`strip`, `center`, `split`, `gsub`, `reverse`, `*`).

## Run It

```bash
cd 01-Languages/Ruby/08-Strings
ruby example.rb
```

## Expected Output (real, captured)

```
Hello, Ada!
hello world
same object? true
same object after +? false
HELLO
Dear Ada,

Thank you for using Ruby.
Line three, still interpolated.
    This line keeps its leading indentation.
padded
***ruby***
["a", "b", "", "c"]
a_b_c
olleH
HelloHelloHello
5
```

## Common Mistakes

- Assuming `str + other` mutates `str` in place — it doesn't; only `<<`/`concat`/bang methods do. Verified directly above: the `object_id` differs after `+`, but stays identical after `<<`.
- Mutating a string that's shared (e.g., a Hash default, or a string passed into a method and mutated there) and being surprised the caller's copy changed too — this is a real, common Ruby gotcha precisely because strings are mutable and Ruby passes references, not copies.
- Forgetting `<<~` vs `<<-`/`<<` — only the squiggly (`<<~`) form strips common leading indentation; the others preserve it exactly as written.

## Best Practices

- Add `# frozen_string_literal: true` at the top of source files in real projects to make string literals immutable by default, catching accidental in-place mutation early (Ruby 3.0+ discussed making this the default; as of 3.4 it remains opt-in).
- Use `<<~` heredocs for any multi-line string embedded inside indented code.
- Prefer non-mutating methods (`.upcase`, `.gsub`) unless in-place mutation is specifically intended and the object isn't shared elsewhere.

## Real-World Usage

Rails view templates and CLI tools (including this course's own Lesson 22 mini-project) use heredocs constantly for multi-line output; string mutability is exploited deliberately in performance-sensitive code (building up a large string with `<<` in a loop is meaningfully faster than repeated `+=`, since `+=` reallocates a new string every iteration).

## Summary

- Ruby strings are mutable; `<<`/bang methods mutate in place, `+` allocates a new object — verified via `object_id`.
- `<<~` heredocs give clean, indentation-stripped multi-line literals; interpolation works the same as in single-line double-quoted strings.
- This is a genuine, direct contrast with Python's immutable strings covered elsewhere in this repository.

## Key Terms

- **Bang method** — a method ending in `!` (e.g., `upcase!`) that mutates its receiver in place, by Ruby convention (not a language-enforced rule).
- **Heredoc** — a multi-line string literal introduced with `<<~`/`<<-`/`<<`.

## Interview Questions

1. **Are Ruby strings mutable or immutable, and how does that differ from Python?**
   Ruby strings are mutable — `<<`, `concat`, and bang methods (`upcase!`) modify the same string object in place, verified directly via unchanged `object_id`. Python's `str` is immutable; every operation (even `s += "x"`) always produces a brand-new string object. This affects both correctness (a shared, mutated Ruby string affects every reference to it) and performance (building a large string with `<<` in a loop avoids the repeated reallocation that `+=` would cause).

2. **What does the squiggly heredoc (`<<~`) do differently from a plain heredoc (`<<`)?**
   `<<~` strips the common leading whitespace shared by every line of the heredoc body, so the literal can be indented to match the surrounding code without that indentation becoming part of the string's actual content. A plain `<<`/`<<-` heredoc preserves every line's whitespace exactly as written, verified directly in this lesson by contrasting the two.

## Recommended Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
