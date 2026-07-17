# Solution 01 — Validate a Type Scale's Line-Height Ratios

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
=== Checking this lesson's real type scale (1.3x - 1.7x expected) ===
Violations: [] (expected [] -- all three type-scale rules are within range)

=== A deliberately introduced violation, to prove the check works ===
Violations: [('.md-overline', 3.0)] (expected one: .md-overline at ratio 3.0, way outside range)
```

## Explanation

Each `.md-*` type-scale rule is matched, its `font-size` and `line-height` (both in pixels) extracted, and their ratio computed. A rule is flagged only if that ratio falls outside the given `[min_ratio, max_ratio]` range — rules that don't have both properties (like `.md-button`, which has a `font-size` but no `line-height`) are skipped entirely rather than incorrectly flagged.

## Reflection Answers

1. **The actual ratios, and why they're consistent.** `.md-headline` (24px/32px) = 1.333, `.md-body` (14px/20px) = 1.429, `.md-label` (11px/16px) = 1.455 — all three sit within a fairly tight band (1.33–1.46), despite spanning font sizes from 11px to 24px. This is deliberate: keeping the *ratio* roughly consistent (rather than an absolute line-height value) means every text style — no matter its size — gets a proportionally similar amount of "breathing room" between lines, so the whole type system reads as visually coherent rather than some styles looking cramped and others looking sparse purely because of unrelated, independently-chosen line-height values.

2. **Why a type system aims for a consistent ratio rather than independent per-style choices.** If each style's line-height were chosen in isolation, two styles could easily end up feeling inconsistent purely by accident — a designer picking a "reasonable-looking" line-height for a 24px headline and a completely different, unrelated-feeling one for an 11px label. Anchoring every style to roughly the same font-size-to-line-height *ratio* (rather than absolute pixel values) is what actually produces perceptually consistent spacing across dramatically different text sizes — the underlying reason Material's own official type scale documentation specifies ratios, not just a table of unrelated pixel pairs.

3. **The real readability problem with a too-tight line-height.** A line-height too close to 1.0x the font-size leaves too little vertical gap between lines — for single-line text (like a button label) this doesn't matter, but for multi-line body text, lines start to visually crowd together, making it genuinely harder for a reader's eye to track from the end of one line to the start of the next without accidentally re-reading or skipping a line — a real, measurable reading-speed and comprehension cost, not just an aesthetic complaint.

## Common Pitfalls

- Assuming every CSS rule with a class selector starting with `.md-` is automatically a type-scale rule with both `font-size` and `line-height` — `.md-button` has a `font-size` but deliberately no `line-height` (buttons are typically single-line), which this solution correctly skips rather than crashing or false-flagging.
- Comparing absolute line-height *values* across different font sizes instead of the *ratio* — an absolute comparison would incorrectly treat a headline's larger line-height as "inconsistent" with a label's much smaller one, even though their ratios are actually very close.
- Picking an unrealistically narrow `[min_ratio, max_ratio]` range that would flag legitimate, real type systems as broken — 1.3–1.7 is a reasonably representative range for body/label/headline text; a much tighter window (e.g., 1.4–1.45) would flag this lesson's own real, well-formed type scale as a false violation.
