# Solution 01 — Slug Generator

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

The chain applies transformations in an order where each step's output is safe input for the next:

1. `.trim()` removes accidental leading/trailing whitespace before anything else runs.
2. `.toLowerCase()` normalizes case once, up front, so every later regex only needs to test for lowercase letters.
3. `.replace(/\s+/g, "-")` turns spaces (including multiple consecutive ones) into hyphens *before* punctuation is stripped — this matters because stripping punctuation first could leave adjacent words jammed together with no separator (e.g. `"What's New"` losing its apostrophe would otherwise still have a space to become a hyphen; the order here handles both correctly).
4. `.replace(/[^a-z0-9-]/g, "")` removes everything that isn't a lowercase letter, digit, or hyphen — this is what drops `'`, `,`, `!`, `?`.
5. `.replace(/-+/g, "-")` collapses any run of hyphens created by adjacent punctuation-turned-nothing (e.g., `"New in "` next to a stripped character) into a single hyphen.
6. `.replace(/^-+|-+$/g, "")` strips any hyphen left dangling at the very start or end.

## Verification

Ran with `node Solutions/solution-01.js`; actual output:

```
hello-world
whats-new-in-javascript-2026
already-hyphenated
```

Matches both cases required by the exercise exactly. The third line (`"---Already---Hyphenated---"` → `"already-hyphenated"`) was added as a self-check confirming the hyphen-collapsing and trimming steps work even when the input already contains excess hyphens.
