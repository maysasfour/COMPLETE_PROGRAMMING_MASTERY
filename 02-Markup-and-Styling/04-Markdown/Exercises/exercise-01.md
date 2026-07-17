# Exercise 01 — Detect Un-Rendered GFM Tables

[Back to lesson](../README.md)

## Task

Write a function `looks_like_unrendered_table(html)` that returns `True` if a rendered HTML string appears to contain a Markdown table that was **not** actually converted into a real `<table>` element — i.e., the tell-tale leftover pipe-and-dash syntax (`| --- | --- |`) is still present as literal text in the output.

```python
looks_like_unrendered_table("<p>Language | Typed |\n|---|---|\n| Python | Dynamic |</p>")  # -> True
looks_like_unrendered_table("<table><tr><td>Python</td></tr></table>")                        # -> False
```

## Hint

A real Markdown table's separator row always looks like `|---|---|` (or `| --- | --- |`, with optional alignment colons like `:---`). A simple regular expression looking for that pattern is enough — you don't need a full Markdown parser to detect its *absence* of proper conversion.

## Reflection Questions

1. Why would a tool like this be useful as an automated check in a documentation build pipeline, rather than relying on someone noticing a broken-looking table by eye?
2. This lesson's `implementation.py` demonstrated the *cause* of un-rendered tables (missing the `tables` extension). Why might a check like this exercise's still be worth having even after fixing that — i.e., what's a DIFFERENT way an un-rendered table could still slip through?
3. Could this same detection approach (checking rendered output for a specific literal-text pattern) be adapted to catch other "was this Markdown feature actually enabled" bugs? Name one other extension from this lesson where a similar check would make sense.

## Deliverable

A working `looks_like_unrendered_table` function, demonstrated against this lesson's own default (un-rendered) and extended (correctly rendered) HTML output, plus answers to the three reflection questions.
