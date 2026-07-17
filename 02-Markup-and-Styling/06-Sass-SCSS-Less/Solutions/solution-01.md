# Solution 01 — Detect Excessive Selector Nesting Depth

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
3 (expected 3)
1 (expected 1)
this lesson's main.scss max nesting depth: 2
```

## Explanation

A running counter increments on every `{` and decrements on every `}`, tracking the highest value reached — that peak value is the deepest brace-nesting level anywhere in the source.

## Reflection Answers

1. **Why deep nesting produces high-specificity CSS, and why that's a real problem.** Each level of Sass/Less nesting (using descendant combinators, not `&`) compiles to an additional descendant selector in the output — `.a { .b { .c { ... } } }` compiles to the real CSS selector `.a .b .c { ... }`, which has higher specificity than a flat `.c { ... }` would. Higher specificity means overriding that style later requires an equally (or more) specific selector, which encourages ever-deeper/more-specific overrides in a growing codebase — a real, common maintenance spiral where specificity keeps escalating just to win the cascade.

2. **Whether a max-depth-1 limit would have blocked `main.scss`, and the `&` nuance.** This lesson's `main.scss` has a brace-nesting depth of 2 (`.card { &__title { ... } }`), so a strict "depth 1" limit checked purely on source braces WOULD flag it — but this reveals an important nuance the exercise is specifically testing: `&__title` uses Sass's parent-selector reference (`&`) to *concatenate* onto the parent class name, producing the flat compiled selector `.card__title` (verified directly in `build.mjs`'s output) — NOT the descendant selector `.card .card__title` that plain nesting without `&` would produce. So this specific pattern, despite having *source*-level brace nesting, does **not** actually create the specificity problem reflection question 1 describes. A naive brace-counting check (like this exercise's function) cannot distinguish these two cases — it would need to specifically recognize the `&` parent-selector-concatenation pattern to avoid a false positive on legitimate BEM-via-Sass code like this.

3. **A concrete real-world scenario where deep nesting becomes a genuine problem.** A common real case: `.page .sidebar .widget .widget-title { color: blue; }` (four levels deep, mirroring the HTML structure) makes it later genuinely hard to override that title's color for one specific widget instance elsewhere on the page — the override needs an equally specific (or `!important`-laden) selector just to win the cascade, and that new override then becomes its own future obstacle for the next person who needs to change it again. This compounding-specificity problem is exactly what CSS methodologies like BEM (see [09-CSS-Methodologies](../../09-CSS-Methodologies/README.md)) exist to avoid, by keeping every selector flat and equally (low) specific regardless of how deeply nested the actual HTML/component structure is.

## Common Pitfalls

- Treating any brace-nesting depth as automatically bad — as shown directly, `&`-based BEM-style nesting (common and often encouraged) has source-level nesting but does NOT produce the compiled-selector specificity problem plain descendant nesting does.
- Writing a nesting-depth checker that can't distinguish `&`-concatenation from plain descendant nesting — a genuinely more complete version of this exercise's check would need to look at whether each nested block starts with `&` to avoid flagging legitimate, flat-compiling BEM patterns.
- Assuming a simple brace counter handles all SCSS syntax correctly — this implementation doesn't account for braces inside strings or comments, which is a reasonable simplification for this exercise's scope but a real limitation for a production linter.
