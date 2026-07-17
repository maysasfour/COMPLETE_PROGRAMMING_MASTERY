# Exercise 01 — Detect Excessive Selector Nesting Depth

[Back to lesson](../README.md)

## Task

Deeply nested Sass/Less selectors compile to increasingly long, over-specific CSS selectors that become hard to override later. Write a function `max_nesting_depth(scss_source)` that returns the deepest level of `{`-brace nesting found in a raw SCSS source string (a simple structural check, not a full parser).

```python
max_nesting_depth(".a { .b { .c { color: red; } } }")  # -> 3
max_nesting_depth(".a { color: blue; }")                # -> 1
```

## Hint

Track a running counter as you scan the source character by character: increment on `{`, decrement on `}`, and record the highest value the counter ever reaches.

## Reflection Questions

1. Why does deep nesting in Sass/Less lead to increasingly *specific* compiled CSS selectors, and why is high specificity often considered a real maintenance problem rather than just a style preference?
2. This lesson's own `main.scss` nests one level deep (`.card { &__title { ... } }`). Would a stricter limit (say, max depth 1) have prevented writing that file the way it is? Why or why not — does the BEM-style `&__title` pattern actually correspond to genuine selector nesting depth in the *compiled* CSS?
3. What's a concrete, common real-world scenario where deep nesting (3+ levels) becomes a genuine problem when someone later needs to override a style?

## Deliverable

A working `max_nesting_depth` function, tested against this lesson's own `main.scss`, plus answers to the three reflection questions.
