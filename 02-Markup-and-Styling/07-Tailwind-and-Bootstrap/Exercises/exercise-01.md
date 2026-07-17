# Exercise 01 — Detect Dynamically-Constructed Tailwind Class Names

[Back to lesson](../README.md)

## Task

Write a function `find_dynamic_class_risks(js_source)` that scans a JavaScript source string for template-literal patterns that look like they're constructing a Tailwind utility class name at runtime (e.g., `` `text-${color}-600` ``) and returns a list of the risky snippets found — exactly the pattern that broke in this lesson's `index.html` demo.

```python
find_dynamic_class_risks('el.className = `text-${color}-600`;')
# -> ['`text-${color}-600`']

find_dynamic_class_risks('el.className = "text-red-600";')
# -> []   (a fully static string is not at risk -- Tailwind's scanner can see it)
```

## Hint

A reasonable heuristic: look for a template literal (backtick-delimited string) that contains at least one `${...}` interpolation AND also contains a Tailwind-like prefix immediately before it (e.g., `text-`, `bg-`, `border-`, `p-`, `m-`). You don't need to handle every possible Tailwind prefix exhaustively — a representative list is enough for this exercise.

## Reflection Questions

1. Why can't Tailwind's build-time content scanner simply "run the JavaScript" to see what class name a template literal would produce at runtime?
2. This lesson's own demo accidentally proved a related point: literally spelling out a class name inside a comment was enough to make Tailwind generate the CSS rule for it. Does that fact make your `find_dynamic_class_risks` function's job easier or harder? Why?
3. What's the actual recommended fix for needing a dynamic/conditional Tailwind class (rather than avoiding dynamic styling altogether)?

## Deliverable

A working `find_dynamic_class_risks` function, tested against a snippet resembling this lesson's own `index.html` script, plus answers to the three reflection questions.
