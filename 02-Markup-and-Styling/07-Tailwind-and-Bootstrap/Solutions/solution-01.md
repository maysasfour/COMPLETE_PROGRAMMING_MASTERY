# Solution 01 — Detect Dynamically-Constructed Tailwind Class Names

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
['`text-${color}-600`'] (expected 1 risky snippet)
[] (expected [] -- fully static)
['`text-${color}-${shade}`'] (this lesson's own demo, correctly flagged)
```

## Explanation

The regex `` `[^`]*\$\{[^}]*\}[^`]*` `` matches any backtick-delimited template literal containing at least one `${...}` interpolation. Each match is then checked for a known Tailwind utility prefix (`text-`, `bg-`, etc.) appearing anywhere in it — a simple but effective heuristic for flagging the specific "class name built from a variable" pattern this lesson's own demo broke on.

## Reflection Answers

1. **Why Tailwind can't "just run the JavaScript."** Tailwind's content scanner runs at *build time*, on static source text — it has no JavaScript runtime, no knowledge of what value `color` or `shade` will hold when the page actually executes, and generally can't (and shouldn't have to) execute arbitrary application code just to discover which CSS classes might be used. It treats every source file as plain text and looks for complete, literal class-name-shaped tokens — which a template literal with an interpolation, by definition, does not contain until the code actually runs.

2. **How the comment discovery affects this exercise.** It makes the underlying problem *more* interesting, but doesn't really make `find_dynamic_class_risks` harder or easier — this function is specifically about flagging *code* that constructs classes dynamically (a genuine correctness risk regardless of whether it happens to work by accident), not about replicating Tailwind's own scanner exactly. The real lesson from the comment discovery is a separate, important point: Tailwind's scanner has zero code-awareness at all (it doesn't even know the difference between a JS comment and executable code) — it is *pure text matching*, for better (very fast, simple) and worse (a stray mention anywhere can silently "fix" a bug that should have been caught).

3. **The actual recommended fix for dynamic/conditional classes.** Write out the *complete*, static class name for every possible branch, and pick between them with a conditional — e.g., `className = isActive ? "text-purple-600" : "text-gray-600"` — rather than concatenating fragments. Both complete strings are literal, scannable tokens Tailwind's build step can find, even though only one is ever actually applied at runtime. Tailwind's own documentation explicitly recommends this "spell out every full class name" pattern for exactly this reason.

## Common Pitfalls

- Assuming Tailwind's scanner does any kind of JavaScript parsing or evaluation — it does not; it is fundamentally a text-matching tool, which is both its speed advantage and the source of this entire class of bug.
- Trying to fix a dynamic-class bug by making the interpolation "smarter" (e.g., a lookup table keyed by color) without realizing the *fix* still needs to result in complete, literal class-name strings appearing somewhere in scanned source — a lookup table whose *values* are complete strings (`{ red: "text-red-600", purple: "text-purple-600" }`) works; string concatenation does not.
- Forgetting that comments, template placeholders, and even documentation strings inside scanned source files are not exempt from the scanner's text matching — as this lesson's own demo discovered directly, spelling out a class name anywhere in a scanned file is enough to generate its CSS rule, intentionally or not.
