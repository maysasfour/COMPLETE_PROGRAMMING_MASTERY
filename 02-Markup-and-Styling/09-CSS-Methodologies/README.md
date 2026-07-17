# 09 — CSS Methodologies

[Back to module overview](../README.md) | [Previous: Material Design](../08-Material-Design/README.md)

## Learning Objectives

- Understand what problem CSS methodologies actually solve: keeping large stylesheets maintainable as a project grows, primarily by controlling selector specificity and preventing naming collisions.
- Build the *exact same* alert component five different ways — BEM, OOCSS, SMACSS, CSS Modules, and CSS-in-JS — to compare their real, concrete mechanics rather than just their philosophies in the abstract.
- See genuine proof (not just a claim) that CSS Modules and CSS-in-JS actually prevent class-name collisions that plain global CSS (even BEM/OOCSS/SMACSS) cannot.

## Concept: What Problem Are These Methodologies Actually Solving?

Plain CSS has exactly one, entirely global namespace for class names, and specificity that only ever *compounds* as a codebase grows (see [Lesson 06](../06-Sass-SCSS-Less/README.md)'s nesting-specificity discussion) — nothing stops two unrelated components from both defining `.title` and silently colliding. The five approaches in this lesson are five different answers to "how do we prevent that," ranging from pure naming *convention* (still global CSS, just disciplined) to genuine, tool-enforced *scoping*:

| Approach | Mechanism | Collision prevention |
|---|---|---|
| **BEM** ([`bem/`](bem/)) | `.block__element--modifier` naming convention | Convention only — still one global namespace, just disciplined enough that collisions are unlikely in practice |
| **OOCSS** ([`oocss/`](oocss/)) | Separate "structure" classes from "skin" classes | Convention only — encourages reuse, doesn't prevent collisions |
| **SMACSS** ([`smacss/`](smacss/)) | Categorize rules into Base/Layout/Module/State/Theme files | Convention + file organization only |
| **CSS Modules** ([`css-modules/`](css-modules/)) | Build-time tool rewrites every class name to a unique, hashed identifier | **Enforced** — verified directly below |
| **CSS-in-JS** ([`css-in-js/`](css-in-js/)) | Styles defined in JS, scoped class names generated at runtime | **Enforced** — verified directly below |

## Real Proof: CSS Modules Actually Prevent Collisions

[`css-modules/alert.module.css`](css-modules/alert.module.css) and [`css-modules/card.module.css`](css-modules/card.module.css) are two **completely unrelated** files that both define a class named `.title` — in plain global CSS (or even BEM without careful naming), this would be a real collision. `build.mjs` processes both with the real `postcss-modules` package and checks the actual generated names:

```
alert.module.css .title  -> _title_dmm50_3
card.module.css  .title  -> _title_10v5a_2
Generated names are different (no collision): true
```

## Real Proof: CSS-in-JS Does the Same, at Runtime Instead of Build Time

[`css-in-js/render.mjs`](css-in-js/render.mjs) defines two real `styled-components` — an `Alert`'s `Title` and a completely unrelated `CardTitle` — and server-renders them with styled-components' real `ServerStyleSheet` API:

```
Alert-scoped Title class: sc-gsDLFA kCRBAl
Card-scoped Title class: sc-dkPvMp dlkthQ
Alert-scoped Title class differs from Card-scoped Title class: true
```

**A real bug was caught while writing this exact check**: the first version compared the rendered HTML's class-attribute matches by a guessed array index (`classMatches[1]` vs. `classMatches[3]`), assuming 4 class-bearing elements — but the plain, unstyled `<p>` tags in the demo never receive a `class="..."` attribute at all, so there are only 3 real matches, and `classMatches[3]` was silently `undefined`. The comparison still printed `true`, but only because `anything !== undefined` is always true — not because it was actually comparing the two real `Title` classes. Fixed by destructuring the three real matches by name instead of guessing indices, and reproducing the corrected, genuinely meaningful comparison above.

## How to Run

```bash
cd 02-Markup-and-Styling/09-CSS-Methodologies

# BEM / OOCSS / SMACSS -- just open the HTML files directly, no build step:
# bem/alert.html, oocss/alert.html, smacss/alert.html

cd css-modules && npm install && node build.mjs   # then open demo.html
cd ../css-in-js && npm install && node render.mjs
```

## Verified Output

```
=== CSS Modules ===
alert.module.css .title  -> _title_dmm50_3
card.module.css  .title  -> _title_10v5a_2
Generated names are different (no collision): true

=== CSS-in-JS (styled-components) ===
Alert-scoped Title class: sc-gsDLFA kCRBAl
Card-scoped Title class: sc-dkPvMp dlkthQ
Alert-scoped Title class differs from Card-scoped Title class: true
```

## Common Mistakes

- Assuming BEM/OOCSS/SMACSS *prevent* naming collisions the same way CSS Modules/CSS-in-JS do — they only reduce the *likelihood* through discipline and convention; two developers on a large team can still accidentally pick the same block name and collide, since it's still one shared global CSS namespace underneath.
- Treating "which methodology is best" as a single objective ranking — BEM/OOCSS/SMACSS require zero build tooling and work with plain CSS anywhere; CSS Modules/CSS-in-JS require a build step (or a JS framework) but offer genuine, enforced scoping — a real trade-off, not a strict improvement in only one direction.
- Verifying a "different values means no collision" check with guessed array indices instead of named/keyed access — a real bug this lesson's own CSS-in-JS verification script hit, silently producing a coincidentally-correct-looking result for the wrong reason.

## Best Practices

- For a plain-CSS project with no build tooling, use BEM (or SMACSS's file-categorization alongside it) — the discipline of consistent naming meaningfully reduces (if it can't fully eliminate) collision risk at zero tooling cost.
- For a project that already has a build step (most modern frontend projects do), prefer CSS Modules or CSS-in-JS for anything where collision risk genuinely matters — the scoping guarantee is enforced by tooling, not just convention.
- Whichever methodology is chosen, apply it consistently across an entire project — mixing BEM in some files and ad hoc naming in others reintroduces exactly the collision risk the methodology was meant to prevent.

## Summary

- All five approaches in this lesson solve the same underlying problem (CSS's single global namespace and ever-compounding specificity) with different mechanisms and different strength of guarantee.
- BEM, OOCSS, and SMACSS are naming/organizational *conventions* on top of plain global CSS — real and valuable, but not tool-enforced.
- CSS Modules (build-time) and CSS-in-JS (runtime) both genuinely, verifiably prevent naming collisions — proven directly in this lesson by giving two unrelated components the identical class name `.title`/`Title` and confirming the generated output never collides.
- A real bug in this lesson's own CSS-in-JS verification script (a guessed array index producing a coincidentally-correct result for the wrong reason) is a good reminder to verify comparisons by name/key, not by assumed position.

## Key Terms

- **BEM (Block\_\_Element--Modifier)** — a naming convention using double underscores/hyphens to unambiguously encode a component's structure in its class names.
- **OOCSS (Object-Oriented CSS)** — a methodology separating "structure" (layout/box-model) classes from "skin" (visual theme) classes for independent reuse.
- **SMACSS (Scalable and Modular Architecture for CSS)** — a methodology categorizing CSS rules into Base/Layout/Module/State/Theme, often reflected in file organization.
- **CSS Modules** — a build-time tool that rewrites CSS class names to unique, scoped identifiers per file, preventing cross-file naming collisions.
- **CSS-in-JS** — writing component styles directly in JavaScript (e.g., `styled-components`), with scoped class names generated at runtime based on the styles' own content.

## Interview Questions

1. **What real problem do CSS methodologies like BEM, OOCSS, and SMACSS solve, and what's their actual limitation?**
   They address CSS's single global class-name namespace and ever-increasing specificity as a codebase grows, via naming/organizational discipline. Their real limitation: they're conventions enforced by developer discipline, not tooling — nothing actually *prevents* two developers from accidentally choosing the same block/class name; it just becomes much less likely with consistent, careful naming.

2. **How do CSS Modules and CSS-in-JS provide a STRONGER guarantee than BEM/OOCSS/SMACSS, and how would you prove it?**
   Both use tooling (a build-time processor for CSS Modules, a runtime library for CSS-in-JS) to rewrite every class name into a unique, scoped identifier, so two completely unrelated components can use the identical source class name (`.title`) and never actually collide in the generated output. This lesson proves it directly rather than asserting it: two files/components both named a class `title`/`Title`, and the real generated output (`_title_dmm50_3` vs. `_title_10v5a_2` for CSS Modules; `kCRBAl` vs. `dlkthQ` for CSS-in-JS) was checked and confirmed different.

3. **Why does BEM use a DOUBLE underscore/hyphen rather than a single one?**
   A single hyphen is also the ordinary, legitimate way to spell a multi-word block or element name in CSS generally (`.date-picker`) — using a single hyphen for BEM's modifier separator too would make it genuinely ambiguous whether a given hyphen is part of the base name or introduces a modifier. The double separator removes that ambiguity entirely, which is also why a reliable "detect broken BEM syntax" checker (this lesson's exercise) can safely flag a lone underscore but should NOT try to flag lone hyphens.

4. **What's the practical trade-off between choosing a naming-convention methodology (BEM/OOCSS/SMACSS) versus a tooling-enforced one (CSS Modules/CSS-in-JS)?**
   Naming conventions require zero build tooling and work in any plain-CSS context, but only reduce (not eliminate) collision risk and require ongoing developer discipline to maintain consistently. Tooling-enforced scoping genuinely eliminates collision risk, but requires a build step (CSS Modules) or a JavaScript framework/runtime (CSS-in-JS) — not a strict improvement in every dimension, since it adds a real dependency/tooling requirement a plain-CSS project may not otherwise need.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Suggested Next Lesson

This is the last lesson in `02-Markup-and-Styling`. Return to the [module overview](../README.md) for the full lesson index.
