# Exercise 01 — Validate a Type Scale's Line-Height Ratios

[Back to lesson](../README.md)

## Task

Material Design's type scale conventionally keeps each text style's `line-height` at a consistent ratio relative to its `font-size` (roughly 1.3x–1.6x is typical for body/label text — enough to avoid visually cramped lines without wasting vertical space). Write a function `check_line_height_ratios(css_source, min_ratio, max_ratio)` that parses every `.md-*` type-scale rule in `styles.css` (each has both a `font-size` and `line-height` in pixels) and returns a list of any rules whose `line-height / font-size` ratio falls **outside** the given `[min_ratio, max_ratio]` range.

```python
check_line_height_ratios(css_source, 1.3, 1.7)
# -> []  if every .md-* rule's ratio is within [1.3, 1.7]
# -> ['.md-label'] if, say, .md-label's ratio were 2.5 (too loose)
```

## Hint

A simple regex capturing each `.md-*{ ... font-size: Npx; ... line-height: Mpx; ... }` block (in any order) is enough — you don't need a full CSS parser for this exercise's scope.

## Reflection Questions

1. Check this lesson's own `styles.css`: what are the actual `font-size`/`line-height` ratios for `.md-headline`, `.md-body`, and `.md-label`? Are they consistent with each other? Why might a type system deliberately aim to keep this ratio similar across otherwise very different text styles (a 24px headline vs. an 11px label), rather than treating each style's line-height as a totally independent, unrelated choice?
2. Why does Material Design (and most type systems) define this ratio as roughly consistent across text styles rather than choosing `line-height` independently per style?
3. What real, visible readability problem does a `line-height` set too close to `1.0x` the font-size cause, especially for multi-line body text?

## Deliverable

A working `check_line_height_ratios` function, run against this lesson's own `styles.css`, plus answers to the three reflection questions.
