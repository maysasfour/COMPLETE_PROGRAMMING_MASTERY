# Solution 01 — Detect a BEM Naming Violation

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
['.alert_title'] (expected ['.alert_title'])
[] (expected [] -- correctly double-separated)

=== Checking this lesson's real bem/alert.css ===
Violations found: [] (expected [] -- the real file is correctly written)
```

## Explanation

Every class selector in the CSS source is extracted, and each class name is checked for a single underscore that is **not** part of a double underscore (a negative lookbehind/lookahead pair, `(?<!_)_(?!_)`, matches exactly that). A single underscore reliably indicates a broken `__element` separator; a double underscore is left untouched as correct BEM syntax.

## Reflection Answers

1. **Why BEM uses double separators, and why single hyphens are deliberately NOT flagged.** BEM's double underscore/hyphen convention exists specifically so it can be unambiguously distinguished from a legitimate single hyphen that's just part of a normal, multi-word block or element name — `.date-picker` is a perfectly valid BEM *block* name (a single hyphen, used the same way a CSS class name would use one anyway), not a broken attempt at `.date--picker` modifier syntax. If BEM used single separators instead of double ones, there would be no reliable way to tell "this hyphen is part of the base name" apart from "this hyphen was meant to introduce a modifier" — the double-separator convention exists *precisely* to remove that ambiguity. This is also exactly why this solution only checks underscores: underscores have no other legitimate use in a class name, so a lone one is unambiguous, while a lone hyphen is common and often completely correct.

2. **Whether this lesson's own `bem/alert.css` passes the check.** Yes, verified directly above — `find_bem_violations` returns `[]` against the real file, correctly recognizing `.alert__title` (double underscore) and `.alert--success` (double hyphen, not checked by this function at all, but also not a false positive) as valid.

3. **Whether a general-purpose linter already does this.** Yes — Stylelint (the standard CSS linter) has community-maintained plugins (e.g., `stylelint-selector-bem-pattern`) that enforce BEM naming conventions far more thoroughly and configurably than this exercise's simple heuristic. This is worth being honest about: writing this check was valuable for understanding *why* the double-separator convention exists and what a violation actually looks like structurally, but a real project should adopt an existing, actively-maintained linter plugin rather than hand-rolling and maintaining custom BEM-checking logic long-term — the same "don't reinvent a well-solved problem" judgment call that applies to most custom tooling.

## Common Pitfalls

- Trying to also flag single hyphens as BEM modifier-separator mistakes — as explained in reflection question 1, this produces false positives on the many completely legitimate block/element names that use a single hyphen as an ordinary word separator.
- Matching against raw text without properly extracting just the class-name portion of a selector — accidentally including the leading `.` or trailing `{`/whitespace in the check could produce subtly wrong match boundaries.
- Assuming this kind of hand-rolled check is the "final" solution for enforcing a naming convention on a real team/project — a mature linter plugin (see reflection question 3) will catch far more real violations with far less maintenance burden than continuing to extend a custom regex-based script.
