# 05 — SVG

[Back to module overview](../README.md) | [Previous: Markdown](../04-Markdown/README.md)

## Learning Objectives

- Write a real SVG file by hand — shapes, gradients, paths, text — and understand `viewBox` as an independent internal coordinate system.
- Validate SVG structurally with an XML parser, since **SVG is XML**, directly reusing [Lesson 03](../03-Data-Formats-XML-JSON-YAML/README.md)'s parsing technique.
- Understand and verify, in a real browser, the concrete difference between embedding an SVG inline (`<svg>...</svg>` directly in HTML) versus via `<img src="...svg">` — specifically, that only the inline form can be styled/animated by the page's own CSS.

## Concept: SVG Is XML, and `viewBox` Is Not the Same as Width/Height

SVG (Scalable Vector Graphics) describes images as **shapes and paths with coordinates**, not pixels — this is what makes it scale to any size with zero quality loss, unlike a raster format (PNG/JPEG). Critically, **SVG's root element is just an XML document** — [`icon.svg`](icon.svg) was parsed directly with Python's `xml.etree.ElementTree`, the exact same library and technique as [Lesson 03](../03-Data-Formats-XML-JSON-YAML/README.md)'s XML parsing, no SVG-specific library needed.

`viewBox="0 0 100 100"` defines an *internal* 100×100 coordinate system that every shape inside the SVG is positioned within — completely independent of the `width`/`height` attributes, which define the *actual rendered size* on the page. This is exactly what lets [`icon.svg`](icon.svg) render at `100×100` in one place and `300×300` elsewhere (see [`example.html`](example.html)) with zero blur or quality loss — the same shapes are just redrawn at a different scale, not stretched pixels.

## A Real Bug Caught Immediately: `--` Inside an XML Comment Is Illegal

The very first version of `icon.svg`'s explanatory comment contained the substring ` -- ` (a double hyphen) in its prose — and running this lesson's own `implementation.py` immediately raised a real `xml.etree.ElementTree.ParseError`, because **the XML specification forbids `--` anywhere inside a comment's content**, not just as a comment delimiter. This is a genuinely easy mistake to make (double hyphens are common in ordinary prose, exactly as used throughout this repository's own commentary style) and a real, useful thing to know: a browser rendering that same broken SVG might silently tolerate or guess around it, while a strict XML parser (or a build-time SVG optimizer/linter) will not — catching a mistake a browser would have hidden. Fixed by simply avoiding `--` inside the comment text.

## A Real, Browser-Verified Distinction: Inline `<svg>` vs. `<img src="...svg">`

[`example.html`](example.html) embeds the exact same icon three ways, with a CSS rule (`.icon-bg:hover { fill: red; }`) that can only actually reach one of them:

- **Inline `<svg>...</svg>`**: verified live with a real headless-Chromium (Playwright) hover event — the rect's computed `fill` genuinely changes from `url("#bg-gradient-inline")` to `rgb(220, 38, 38)` (red) on hover.
- **`<img src="icon.svg">`**: the *exact same* CSS rule and the *exact same* hover interaction produce **no change at all** — verified directly, not assumed. An SVG loaded via `<img>` is rendered as an opaque, isolated resource, the same way an `<iframe>`'s content is isolated from the parent page — the page's CSS simply cannot reach inside it, no matter how the selector is written.

A genuine bug was hit while writing this verification: the first hover attempt targeted the exact center of the inline SVG and found **no** change at all — not because the CSS was broken, but because the check itself was hovering the wrong element (the circle drawn on top of the rect at that exact point, since CSS `:hover` only ever matches the specific element directly under the pointer, not a sibling underneath it). Moving the hover point to a corner of the icon not covered by the circle/arrow fixed the check and confirmed the real behavior.

## How to Run

```bash
cd 02-Markup-and-Styling/05-SVG
python implementation.py          # structural XML validation
python -m http.server 8123        # then open http://localhost:8123/example.html in a browser
```

## Verified Output

```
=== Validating icon.svg structurally (SVG IS XML) ===
  [PASS] root is an <svg> element
  [PASS] has a viewBox attribute
  [PASS] viewBox has exactly 4 numbers
  [PASS] contains at least one <path>
  [PASS] every <path> has a valid-looking 'd' start
  [PASS] gradient (if present) has at least 2 stops

All checks passed: True

=== A real XML parse error on malformed SVG, on purpose ===
ET.fromstring raised a real ParseError: mismatched tag: line 1, column 54
```

**Real browser verification** (Playwright, headless Chromium):
```
Inline SVG rect fill BEFORE hover: url("#bg-gradient-inline")
Inline SVG rect fill AFTER hover: rgb(220, 38, 38)
Inline SVG genuinely changed on hover: true
The <img>-embedded SVG exposes any internal DOM/shadow content to the page: false
```

## Common Mistakes

- Using `--` inside an SVG/XML comment — illegal per the XML spec, and a real, easy mistake since it's completely ordinary in prose (caught directly while writing this lesson).
- Assuming an `<img src="icon.svg">` can be styled/animated by the page's CSS the same way an inline `<svg>` can — verified directly above that it cannot; this is a common source of "why doesn't my icon's hover color change" confusion.
- Confusing `viewBox` with `width`/`height` — they describe two independent things (an internal coordinate system vs. the actual rendered box size); see this lesson's exercise for a check that catches them mismatching.
- Testing `:hover` behavior at a shape's exact geometric center without accounting for other shapes drawn on top of it at that same point — a real bug hit directly while writing this lesson's own verification script.

## Best Practices

- Use inline `<svg>` (not `<img>`) whenever the icon/graphic needs to respond to CSS (hover states, dark-mode color changes, animations) or JavaScript.
- Use `<img src="...svg">` (or a CSS `background-image`) for static icons/illustrations that never need page-level styling — it's simpler markup and the browser can cache it as a normal external resource.
- Always set a `viewBox` on hand-authored SVGs, even when `width`/`height` are also set, so the graphic scales correctly if `width`/`height` are later changed or overridden by CSS.
- Validate hand-authored SVG with a real XML parser (or a dedicated SVG linter) before relying on "it looks fine in my browser" — as demonstrated directly, a browser can silently tolerate mistakes a strict parser will not.

## Summary

- SVG is XML — the exact same parsing tools and rules from Lesson 03 apply directly, including XML's ban on `--` inside comments, which this lesson's own first draft violated and caught immediately.
- `viewBox` (internal coordinate system) and `width`/`height` (rendered size) are independent; scaling an SVG by changing only `width`/`height` produces zero quality loss because nothing is being stretched at the pixel level.
- Inline `<svg>` can be styled by page CSS; `<img src="...svg">` cannot — verified directly in a real browser, including a real bug in the verification script itself (hovering the wrong overlapping element) that was caught and fixed before trusting the result.

## Key Terms

- **viewBox** — an SVG attribute defining an internal coordinate system (`min-x min-y width height`), independent of the element's actual rendered size.
- **Vector graphics** — images described as shapes/paths with mathematical coordinates, scalable to any size with no quality loss, as opposed to raster (pixel-grid) formats like PNG/JPEG.
- **CSS isolation (via `<img>`)** — the browser renders an `<img>`-embedded SVG as an opaque external resource; the page's CSS cannot select or style anything inside it, the same isolation an `<iframe>` has.

## Interview Questions

1. **Why can an inline `<svg>` be styled by page CSS (e.g., `:hover` color changes) while the same SVG loaded via `<img>` cannot?**
   An inline `<svg>` becomes part of the page's own DOM — the page's CSS selectors can match and style its internal elements exactly like any other HTML element. An SVG loaded via `<img>` is rendered as an opaque, isolated external resource (the same isolation an `<iframe>`'s content has); the browser deliberately does not expose its internal structure to the parent page's CSS or JavaScript at all.

2. **What's the difference between an SVG's `viewBox` and its `width`/`height` attributes?**
   `viewBox` defines an internal coordinate system that every shape inside the SVG is positioned within. `width`/`height` define the actual rendered size on the page. They're independent — changing only `width`/`height` rescales the entire internal coordinate system to fit the new size with zero quality loss (since it's redrawing vector shapes, not stretching pixels), while a `viewBox` that doesn't match the `width`/`height` aspect ratio can cause visible stretching or letterboxing, depending on `preserveAspectRatio`.

3. **Why is `--` inside an SVG comment a real, easy-to-hit bug, and how would you catch it before it reaches production?**
   SVG is XML, and the XML specification forbids the sequence `--` anywhere inside a comment's content (not just as its start/end delimiter) — a genuinely easy mistake since double hyphens are common in ordinary prose. A browser may silently tolerate or work around it, hiding the mistake, while a strict XML parser (`xml.etree.ElementTree`, or a dedicated SVG linter/optimizer run in CI) will raise a real, immediate parse error — exactly as this lesson's own first draft demonstrated.

4. **When verifying hover/interaction behavior on an SVG shape with a testing tool, what's a subtle mistake that could produce a false negative?**
   Targeting the exact geometric center (or any point covered by another overlapping shape) rather than a point uniquely on the intended target element — CSS `:hover` only matches the specific element directly under the pointer, so if a different shape is drawn on top at that exact point, the intended element's `:hover` rule never triggers, even though the underlying CSS and markup are both completely correct. This is a real bug this lesson's own verification script hit and had to fix.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Suggested Next Lesson

[06 — Sass, SCSS, and Less](../06-Sass-SCSS-Less/README.md)
