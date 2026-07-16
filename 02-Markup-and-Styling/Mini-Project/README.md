# Mini-Project — Responsive One-Page Portfolio Site

[Back to module overview](../README.md)

## Overview

A single-page developer portfolio site combining every technique from [01-HTML5](../01-HTML5/) and [02-CSS3](../02-CSS3/): semantic landmarks, an accessible skip link, a data table, a native-validated contact form, a responsive Grid project gallery, CSS custom properties with automatic dark-mode support, and transform-based hover transitions. No framework, no build step, no JavaScript required for any of the above.

## Files

- [index.html](index.html) — full page markup.
- [styles.css](styles.css) — all styling.

## Run It

```bash
# from this directory
start index.html      # Windows
open index.html       # macOS
xdg-open index.html   # Linux
```

## What to Look For

- **Accessibility**: tab through the page from the very top — the first focusable element is a "Skip to main content" link, invisible until focused, letting keyboard users bypass the navbar. `<label for>` is paired with every form input.
- **Responsive layout**: resize the browser window (or use DevTools' device toolbar) — the project card grid reflows from one column to three with zero media queries, via `grid-template-columns: repeat(auto-fit, minmax(220px, 1fr))`.
- **Dark mode**: toggle your OS or browser's dark-mode preference (DevTools → Rendering → "Emulate CSS media feature prefers-color-scheme") — every color on the page repaints via CSS custom properties, with no JavaScript involved.
- **Native form validation**: try submitting the contact form with the name field empty, or an invalid email — the browser blocks submission and shows its built-in validation message before any server or script runs.

## Architecture Notes

- One stylesheet, organized top-to-bottom in the same order as the page sections, with a global reset (`box-sizing: border-box`) and theme variables declared first.
- The `.grid`/`.card` classes are reused for the project gallery and could be reused for any future card-based section — this is the same responsive Grid pattern taught in the CSS3 lesson's own exercise.
- No IDs are used for styling (only for label/input pairing and in-page anchor links) — every visual rule is a class, keeping specificity flat and predictable.

## Suggested Extensions

- Add a `<template>`-driven "load more projects" button (requires JavaScript — see [03-Frontend-Development](../../03-Frontend-Development/)).
- Extract the color palette into a shared `tokens.css` if this page grows into a multi-page site.
- Add a real backend for the contact form (see [04-Backend-Development](../../04-Backend-Development/)) — currently `action="#"` is a placeholder with no server behind it.
