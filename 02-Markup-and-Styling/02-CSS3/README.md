# 02 — CSS3

[Back to module overview](../README.md) | [Previous: HTML5](../01-HTML5/README.md)

## Learning Objectives

- Explain the CSS box model and how `box-sizing` changes what "width" means.
- Select elements precisely using type, class, ID, attribute, pseudo-class, and combinator selectors, and reason about specificity when two rules conflict.
- Build layouts with Flexbox (one-dimensional) and Grid (two-dimensional), and choose correctly between them.
- Use custom properties (CSS variables) to implement a themeable design, including dark mode.
- Write transitions and keyframe animations, and know when `transform`/`opacity` are cheaper than animating `width`/`top`.
- Write mobile-first responsive CSS using media queries.

## Prerequisites

[01-HTML5](../01-HTML5/README.md) — CSS has nothing to select or style without HTML structure to attach to.

## Concept: What CSS Actually Is

CSS (Cascading Style Sheets) separates presentation from structure. Every HTML element becomes a rectangular **box** by default (even inline text is boxes at the character/line level), and CSS's core job is: which box gets which styles (**selectors**), what happens when two rules disagree (**the cascade and specificity**), and how boxes are sized and arranged relative to each other (**the box model** and **layout algorithms** like Flexbox/Grid).

## Syntax

```css
selector {
  property: value;
}
```

```css
/* Type selector */
p { color: #222; }

/* Class selector - reusable, most common in practice */
.card { border-radius: 8px; }

/* ID selector - unique per page, higher specificity, use sparingly */
#site-header { position: sticky; top: 0; }

/* Descendant combinator: any <a> inside .card */
.card a { text-decoration: none; }

/* Pseudo-class: state-based */
button:hover { opacity: 0.9; }
input:focus-visible { outline: 2px solid dodgerblue; }
```

## The Box Model

```css
.box {
  box-sizing: border-box; /* width/height include padding + border, not just content */
  width: 200px;
  padding: 16px;
  border: 1px solid #ccc;
  margin: 8px;
}
```

By default (`box-sizing: content-box`), `width` sets only the *content* area — padding and border are added on top, so a `200px`-wide box with `16px` padding and a `1px` border actually occupies `234px`. Almost every modern CSS reset sets `box-sizing: border-box` globally because it makes width math predictable: the declared `width` becomes the box's total rendered width, with padding and border eating into the content area instead of adding to the outside.

## Flexbox: One-Dimensional Layout

```css
.nav {
  display: flex;
  justify-content: space-between; /* main axis (row, by default) */
  align-items: center;            /* cross axis */
  gap: 1rem;
}
```

Flexbox distributes space along a single axis (row or column) and is the right tool for a navbar, a button group, or centering one thing inside another. `gap` (not margins on children) is the current best practice for spacing flex/grid children — it doesn't require canceling out an extra margin on the last child.

## Grid: Two-Dimensional Layout

```css
.gallery {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}
```

`repeat(auto-fit, minmax(200px, 1fr))` is the single most useful line in responsive Grid layout: it creates as many columns as fit, each at least `200px` wide, sharing remaining space equally — a fully responsive card grid with zero media queries.

## Custom Properties (CSS Variables) and Dark Mode

```css
:root {
  --bg: #ffffff;
  --text: #1a1a1a;
  --accent: #2563eb;
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg: #121212;
    --text: #f0f0f0;
    --accent: #60a5fa;
  }
}

body {
  background: var(--bg);
  color: var(--text);
}
```

Custom properties are real runtime values (unlike Sass variables, which are compile-time-only) — they cascade, can be overridden per-component, and can even be changed from JavaScript via `element.style.setProperty()`. `prefers-color-scheme` reads the operating system's light/dark setting with no JavaScript at all.

## Transitions and Animations

```css
.button {
  transition: transform 150ms ease, opacity 150ms ease;
}
.button:hover {
  transform: translateY(-2px);
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to   { transform: rotate(360deg); }
}
.spinner {
  animation: spin 1s linear infinite;
}
```

Animate `transform` and `opacity` where possible — the browser can run these on the compositor thread without re-running layout, making them smooth even on slower devices. Animating `width`, `top`/`left`, or `margin` forces layout recalculation on every frame and is a common source of janky animations.

## Responsive Design: Mobile-First Media Queries

```css
/* Base styles here target mobile by default */
.grid { display: grid; grid-template-columns: 1fr; }

/* Then progressively enhance for larger screens */
@media (min-width: 768px) {
  .grid { grid-template-columns: repeat(2, 1fr); }
}
@media (min-width: 1024px) {
  .grid { grid-template-columns: repeat(3, 1fr); }
}
```

"Mobile-first" means writing the small-screen layout as the unqualified default and using `min-width` queries to add complexity for larger viewports, rather than writing a desktop layout and using `max-width` queries to strip it down. It tends to produce simpler CSS because you're always adding, never overriding.

## Detailed Example

See [example.html](example.html) and [example.css](example.css) in this folder — a single page demonstrating the box model, Flexbox nav, a responsive Grid gallery, CSS variables with dark-mode support, and a hover transition, all together.

## Expected Output

A page with a sticky Flexbox navbar, a card grid that reflows from 1 to 3 columns as the browser window widens, and colors that flip automatically if your OS/browser is set to dark mode (test via browser DevTools' rendering emulation, or your OS dark mode toggle).

## Common Mistakes

- Forgetting `box-sizing: border-box`, then being surprised that padding makes elements wider than their declared `width`.
- Using `!important` to win a specificity fight instead of fixing the actual selector specificity — this makes the next override even harder to win cleanly.
- Centering with `margin: 0 auto` on a flex/grid child instead of `justify-content`/`align-items` — it works for block layout but not inside a flex container the way people expect.
- Animating `width`/`height`/`top`/`left` for movement instead of `transform: translate()`/`scale()`, causing layout thrashing.
- Writing desktop-first CSS with `max-width` overrides for mobile, ending up with deeply nested override chains.

## Best Practices

- Set `box-sizing: border-box` on `*` (or `*, *::before, *::after`) at the top of every stylesheet.
- Prefer `gap` over margin hacks for spacing flex/grid children.
- Keep selector specificity low and flat; reach for a new class before nesting three levels of descendant selectors.
- Define a small palette of custom properties at `:root` and reference them everywhere, rather than hardcoding color values throughout the stylesheet.
- Write mobile-first with `min-width` media queries.

## Real-World Usage

Every CSS framework covered later ([Tailwind](../../03-Frontend-Development/), Bootstrap, Material Design) is built on exactly these primitives — Tailwind's `flex justify-between` utility class and hand-written `display: flex; justify-content: space-between;` compile to the same rendering. Understanding raw CSS is what lets you debug a framework's output when something doesn't look right, and what lets you judge whether a framework is worth its cost for a given project.

## Performance Considerations

- Fewer, flatter selectors are cheaper for the browser to match; deeply nested descendant selectors (`.a .b .c .d span`) are the slowest common pattern.
- Large numbers of animated elements should stick to `transform`/`opacity` to stay on the compositor thread and avoid triggering layout/paint on every frame.

## Security Considerations

- CSS itself has a narrow attack surface, but `content: attr(...)` combined with untrusted attribute values, and CSS injection via unsanitized user-controlled `style` attributes, have both been used historically for data exfiltration (e.g. leaking `input:checked` selectors' state). Never let user input control raw CSS or inline `style` attributes without sanitization.

## Summary

- CSS's core mechanics are the box model, selectors + the cascade/specificity, and layout algorithms (normal flow, Flexbox, Grid).
- Flexbox is one-dimensional; Grid is two-dimensional — pick based on the shape of the layout problem.
- Custom properties are runtime values that make theming (including dark mode) simple with zero JavaScript.
- Prefer animating `transform`/`opacity` for performance.
- Mobile-first (`min-width` media queries) tends to produce simpler responsive CSS than desktop-first.

## Key Terms

- **Box model** — the content/padding/border/margin layers that make up every rendered element's box.
- **Specificity** — the algorithm the cascade uses to decide which of several conflicting rules wins.
- **Flexbox** — a one-dimensional layout mode for distributing space along a row or column.
- **Grid** — a two-dimensional layout mode for rows and columns simultaneously.
- **Custom property (CSS variable)** — a runtime, cascading, user-defined CSS value, declared as `--name` and read with `var(--name)`.
- **Compositor thread** — the browser thread that can animate `transform`/`opacity` without re-running layout, keeping animations smooth.

## Review Questions

1. Why does `box-sizing: border-box` change what `width` means?
2. When would you reach for Grid instead of Flexbox?
3. Why are CSS custom properties better suited to runtime theming than Sass variables?
4. Why is animating `transform` generally smoother than animating `width` or `top`?

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What is CSS specificity, and how is it calculated?**
   Specificity determines which rule wins when multiple rules target the same element with the same property. It's roughly ranked ID selectors > class/attribute/pseudo-class selectors > type/element selectors, with inline `style` attributes and `!important` overriding all of them. Equal-specificity rules are broken by source order — the later rule wins.

2. **What's the practical difference between Flexbox and Grid?**
   Flexbox lays out items along a single axis and is content-driven — items can wrap but there's no true concept of aligning across rows and columns simultaneously. Grid defines explicit rows and columns up front and can align items on both axes at once, making it the better fit for whole-page or card-gallery layouts, while Flexbox remains ideal for one-dimensional groups like navbars or button rows.

3. **Why prefer `transform`/`opacity` for animations over `width`/`top`/`left`?**
   `transform` and `opacity` can be handled entirely on the GPU-accelerated compositor thread without triggering layout (reflow) or paint recalculation on the main thread. Animating geometric properties like `width` or `top` forces the browser to recompute layout on every frame, which is far more expensive and can visibly stutter on constrained devices.

4. **How does `prefers-color-scheme` enable dark mode without JavaScript?**
   It's a media query that reflects the user's OS-level light/dark preference. Defining CSS custom properties at `:root` for the light theme and overriding them inside an `@media (prefers-color-scheme: dark)` block lets every component that already references `var(--bg)`/`var(--text)` etc. re-theme automatically, with no per-component JavaScript logic needed.

## Recommended Next Lesson

[03 — Data Formats: XML, JSON, and YAML](../03-Data-Formats-XML-JSON-YAML/README.md)
