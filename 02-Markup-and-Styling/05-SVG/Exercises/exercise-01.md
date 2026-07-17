# Exercise 01 — Validate an SVG's viewBox Aspect Ratio Matches Its Rendered Size

[Back to lesson](../README.md)

## Task

Write a function `aspect_ratio_matches(svg_path)` that parses an SVG file and returns `True` if its `viewBox` aspect ratio matches its `width`/`height` attribute aspect ratio (within a small tolerance) — `False` if they mismatch, which would cause the rendered image to look stretched/squashed.

```python
aspect_ratio_matches("icon.svg")  # -> True   (viewBox is "0 0 100 100" -- square; width=100, height=100 -- also square)
```

## Hint

Parse `viewBox="min-x min-y width height"` (4 space-separated numbers — the last two are what matter here) and compare `viewBox_width / viewBox_height` against `svg_width / svg_height` (the root `<svg>` element's own `width`/`height` attributes).

## Reflection Questions

1. Why would a mismatched aspect ratio cause a real visual problem, given that `viewBox` and `width`/`height` are conceptually two separate things (an internal coordinate system vs. an actual rendered size)?
2. This lesson's `icon.svg` uses matching aspect ratios (both square). Construct (in your head, or as a test) a `viewBox`/`width`/`height` combination that would legitimately fail this check, and describe what the rendered result would visually look like.
3. Is there ever a legitimate reason to intentionally have a mismatched aspect ratio between `viewBox` and the rendered `width`/`height`? (Hint: think about `preserveAspectRatio`.)

## Deliverable

A working `aspect_ratio_matches` function, tested against `icon.svg`, plus answers to the three reflection questions.
