# Solution 01 — Validate an SVG's viewBox Aspect Ratio Matches Its Rendered Size

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
icon.svg aspect ratio matches: True (expected True -- both square)
Deliberately mismatched example: viewBox ratio=1.0, rendered ratio=3.0, matches=False (expected False -- viewBox is square, rendered size is 3x wider than tall -- this WOULD look horizontally stretched)
```

## Explanation

`viewBox="min-x min-y width height"` defines an internal coordinate system's own aspect ratio (its `width`/`height`, the last two of the four numbers); the root `<svg>` element's own `width`/`height` attributes define the actual rendered box's aspect ratio. `aspect_ratio_matches` computes both ratios independently and compares them within a small floating-point tolerance.

## Reflection Answers

1. **Why a mismatch causes a real visual problem.** The `viewBox` coordinate system gets mapped onto the actual rendered box by default (without `preserveAspectRatio="none"` overriding it, the browser still tries to fit the content, but a genuinely mismatched ratio means SOMETHING has to give — either the content is non-uniformly stretched to fill the box exactly, or it's uniformly scaled with extra empty space added on one axis, depending on the `preserveAspectRatio` setting in effect). A square icon rendered into a 3x-wider-than-tall box, with default settings, would either be squashed horizontally-stretched-looking or centered with visible padding — neither of which is what someone expects from "just resizing an icon."

2. **Constructing a legitimately failing example.** `viewBox="0 0 100 100"` (square internal coordinates) with `width="300" height="100"` (a 3:1 rendered box) — exactly the example demonstrated above. Rendered with default `preserveAspectRatio` behavior, the square icon would appear horizontally stretched to 3x its intended width relative to its height, distorting every shape inside it.

3. **Legitimate reasons for an intentional mismatch.** Yes — `preserveAspectRatio="none"` explicitly tells the browser "stretch the content to exactly fill the rendered box, ignoring the aspect ratio mismatch entirely," which is occasionally wanted for backgrounds or fills that are meant to stretch to fit a container regardless of shape. Without that explicit opt-in, though, a mismatch is far more often an accidental bug (someone changed `width`/`height` for a layout reason without updating `viewBox`, or vice versa) than an intentional design choice — which is exactly why an automated check like this one is worth having.

## Common Pitfalls

- Comparing `width`/`height` against the *first two* numbers in `viewBox` (the min-x/min-y offset) instead of the *last two* (the actual width/height of the internal coordinate system) — a real, easy-to-make parsing mistake.
- Using exact equality (`==`) instead of a small tolerance when comparing floating-point ratios — accumulated floating-point rounding can make two ratios that are conceptually identical compare as unequal.
- Assuming any `viewBox`/rendered-size mismatch is automatically a bug — as shown in reflection question 3, `preserveAspectRatio="none"` is a real, valid way to intentionally allow (and account for) exactly this mismatch.
