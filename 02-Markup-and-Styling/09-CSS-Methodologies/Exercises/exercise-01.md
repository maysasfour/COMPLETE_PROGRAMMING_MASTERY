# Exercise 01 — Detect a BEM Naming Violation

[Back to lesson](../README.md)

## Task

Write a function `find_bem_violations(css_source)` that scans a CSS source string for class selectors and flags any that look like they're trying to express BEM's Block/Element/Modifier structure but use the WRONG separators — specifically, a single underscore or single hyphen where BEM requires a double (`__` for element, `--` for modifier).

```python
find_bem_violations(".alert { } .alert_title { } .alert--success { }")
# -> ['.alert_title']   (single underscore -- should be .alert__title)

find_bem_violations(".alert__title { } .alert--success { }")
# -> []   (correctly double-separated)
```

## Hint

Focus on **underscores**, not hyphens: a single underscore (not part of a double underscore) is a reliable signal of a broken BEM element separator. Deliberately do NOT try to flag single hyphens — think carefully about reflection question 1 before assuming that would work.

## Reflection Questions

1. Why does BEM insist on *double* underscores/hyphens specifically, rather than single ones? (Hint: think about block or element names that themselves legitimately contain a single hyphen, like `.date-picker`.)
2. This lesson's `bem/alert.css` uses `.alert__title` and `.alert--success`. Would your function correctly recognize these as VALID (not flag them)? Verify directly.
3. Is a naming-convention checker like this one something a general-purpose CSS linter (like Stylelint) can already do out of the box? What does that suggest about whether it's worth writing custom tooling for this vs. adopting an existing, community-maintained linter with a BEM plugin?

## Deliverable

A working `find_bem_violations` function, tested against both a violation and this lesson's own real, correct `bem/alert.css`, plus answers to the three reflection questions.
