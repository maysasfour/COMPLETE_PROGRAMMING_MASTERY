# 02 — Markup and Styling

[Back to repository root](../README.md)

This module covers the languages and tools that describe *structure* (HTML5, XML), *data* (JSON, YAML), *documentation* (Markdown), *graphics* (SVG), and *presentation* (CSS3 and its ecosystem of preprocessors, frameworks, and methodologies) — the foundation everything in [03-Frontend-Development](../03-Frontend-Development/) builds on. If you can already write a semantic, accessible page and style it with Flexbox/Grid, preprocessors, and a real CSS methodology, the frontend frameworks later in the roadmap will make far more sense, because they are all ultimately generating HTML and applying CSS under the hood.

## Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [HTML5](01-HTML5/) | Document structure, semantic elements, forms + validation, tables, media, accessibility, SEO basics |
| 02 | [CSS3](02-CSS3/) | Box model, selectors, Flexbox, Grid, positioning, transitions/animations, custom properties, dark mode, responsive/mobile-first design |
| 03 | [Data Formats: XML, JSON, YAML](03-Data-Formats-XML-JSON-YAML/) | Parsing all three with real code; a genuine, reproduced YAML gotcha (the "Norway problem") |
| 04 | [Markdown](04-Markdown/) | CommonMark vs. GitHub-Flavored Markdown; a real, reproduced GFM-table rendering bug |
| 05 | [SVG](05-SVG/) | Hand-authored vector graphics, `viewBox`, structural XML validation, and a real browser-verified inline-vs-`<img>` CSS isolation proof |
| 06 | [Sass, SCSS, and Less](06-Sass-SCSS-Less/) | Variables, nesting, mixins; the modern `@use` module system vs. deprecated `@import`, with a real compiler warning |
| 07 | [Tailwind CSS and Bootstrap](07-Tailwind-and-Bootstrap/) | Utility-first vs. component-based frameworks; a real dynamic-class-name bug and a genuine CSS-cascade-layers interop bug, both found and fixed live |
| 08 | [Material Design](08-Material-Design/) | Elevation, type scale, the 8dp grid, and the ripple interaction — implemented in plain CSS/JS and verified programmatically and in a real browser |
| 09 | [CSS Methodologies](09-CSS-Methodologies/) | BEM, OOCSS, SMACSS, CSS Modules, and CSS-in-JS — the same component built five ways, with real proof that CSS Modules/CSS-in-JS prevent naming collisions that the others cannot |
| — | [Mini-Project](Mini-Project/) | A real, runnable responsive one-page site combining HTML5/CSS3 — no framework, no build step |

## Verification Discipline

Every lesson's code was actually run — HTML/CSS opened in a browser (and, for several lessons, driven with real headless-Chromium via Playwright, the same tool used in [03-Frontend-Development](../03-Frontend-Development/)), every script executed with real captured output. Several genuine bugs were found and fixed along the way rather than smoothed over:

- **Lesson 03**: the real "Norway problem" — an unquoted `NO` (Norway's country code) parses as the boolean `False` under YAML 1.1.
- **Lesson 04**: GitHub-Flavored Markdown tables silently fail to render without an explicit extension enabled.
- **Lesson 05**: this lesson's own first-draft SVG comment contained `--`, which is illegal inside an XML comment — caught immediately by the lesson's own validation script.
- **Lesson 07**: a genuinely advanced discovery — Tailwind v4's CSS cascade layers cause an unlayered framework (Bootstrap) to silently win every style conflict regardless of specificity; found, diagnosed, and fixed live with a verified before/after comparison.
- **Lesson 08**: a verification script's own 700ms wait wasn't quite enough margin for a nominally-500ms CSS animation to finish in practice.
- **Lesson 09**: a CSS-in-JS verification script compared array elements by a guessed index, producing a coincidentally-correct result for the wrong reason — fixed to compare by name instead.

## How to Run the Examples

Static HTML/CSS files need no build step — open directly in a browser:

```bash
cd 01-HTML5/  # or any lesson folder with a plain .html file
start example.html      # Windows
open example.html       # macOS
xdg-open example.html   # Linux
```

Lessons with real tooling (03, 04, 06, 07, 09's CSS Modules/CSS-in-JS folders) have their own `README.md` with exact `pip install`/`npm install` and run commands.

## Suggested Next Module

[03-Frontend-Development](../../03-Frontend-Development/) — once you're comfortable with semantic HTML, CSS layout, and the broader styling ecosystem, browser JavaScript and the DOM are next.
