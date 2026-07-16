# Solution 01 — Semantic Recipe Page

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

The full markup is in [solution-01.html](solution-01.html). Key decisions:

- **`<article>` for the recipe, not `<section>`** — a recipe is meaningful and complete on its own; it would still make sense if syndicated to a recipe aggregator site. That's exactly the test for `<article>` vs `<section>`.
- **`<ol>` for steps, `<ul>` for ingredients** — step order is meaningful (you can't do step 3 before step 1); ingredient order in a list generally isn't, so a plain unordered list is the honest choice.
- **`<figure>`/`<figcaption>` for the image** — this pairing associates a caption with an image programmatically, which a plain `<img>` followed by a `<p>` does not; assistive technology announces the association.
- **`alt` describes content, not the filename** — `alt="A golden-brown baked lasagna in a white dish"`, not `alt="lasagna.jpg"` or `alt="image"`.

## Verification

Opened in a browser: renders an unstyled but correctly structured page. Viewed via "View Page Source": confirms `<!DOCTYPE html>` is present, `lang="en"` is set, and there is no `<div>` used where a semantic element was available.
