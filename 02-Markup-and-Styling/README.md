# 02 — Markup and Styling

[Back to repository root](../README.md)

This module covers the languages that describe *structure* (HTML5) and *presentation* (CSS3) on the web — the foundation everything in [03-Frontend-Development](../03-Frontend-Development/) builds on. If you can already write a semantic, accessible page and style it with Flexbox/Grid without a framework, the frontend frameworks later in the roadmap will make far more sense, because they are all ultimately generating HTML and applying CSS under the hood.

## Contents

| Folder | Status | Covers |
|---|---|---|
| [01-HTML5](01-HTML5/) | Complete | Document structure, semantic elements, forms + validation, tables, media, accessibility, SEO basics |
| [02-CSS3](02-CSS3/) | Complete | Box model, selectors, Flexbox, Grid, positioning, transitions/animations, custom properties, dark mode, responsive/mobile-first design |
| [Mini-Project](Mini-Project/) | Complete | A real, runnable responsive one-page site combining everything above — no framework, no build step |

## Not Yet Built

The full spec for this module also calls for dedicated lessons on XML, JSON, YAML, Markdown, SVG, JSX/TSX, Sass/SCSS/Less, Tailwind CSS, Bootstrap, Material Design, and CSS methodologies (BEM, OOCSS, SMACSS, CSS Modules, CSS-in-JS). None of those exist yet — they are tracked in [BUILD_STATUS.md](../BUILD_STATUS.md) as the next work for this module rather than being represented here as empty folders. JSON and Markdown are used informally throughout this repository already (every README is Markdown, every mini-project's data fixtures use JSON); a dedicated data-formats lesson would formalize that.

## How to Run the Examples

Every `.html` file in this module is a static file with no build step and no server requirement. Open it directly in a browser:

```bash
# from this module's directory, e.g. 01-HTML5/
start example.html      # Windows
open example.html       # macOS
xdg-open example.html   # Linux
```

Or use a simple local server (needed only if a lesson fetches another local file via `fetch`, which none currently do):

```bash
python -m http.server 8000
```

## Suggested Next Module

[03-Frontend-Development](../03-Frontend-Development/) — once you're comfortable with semantic HTML and CSS layout, browser JavaScript and the DOM are next.
