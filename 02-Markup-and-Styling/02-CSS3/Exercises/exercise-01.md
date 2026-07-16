# Exercise 01 — Responsive Pricing Cards with a Dark-Mode Palette

[Back to lesson](../README.md)

## Task

Starting from `recipe.html`/`solution-01.html` from the HTML5 lesson (or any HTML skeleton), build `pricing.html` + `pricing.css` implementing three pricing tiers ("Basic", "Pro", "Team") as cards, with:

1. A Grid layout (`display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));`) so the cards reflow from 1 to 3 columns as the viewport widens — no media query needed for the reflow itself.
2. `:root` custom properties for at least `--bg`, `--text`, `--card-bg`, and `--accent`, overridden inside `@media (prefers-color-scheme: dark)`.
3. The "Pro" card visually highlighted (e.g. a border in `var(--accent)` and a "Most Popular" badge) using only CSS — no extra HTML wrapper needed beyond a modifier class like `.card--highlighted`.
4. A hover effect on each card using `transform`, not `top`/`margin`.

## Constraints

- `box-sizing: border-box` must be set globally.
- No JavaScript.
- All spacing between cards must use `gap`, not margins on the cards.

## Expected Output

Resizing the browser window reflows the cards without any additional CSS beyond the `auto-fit`/`minmax` Grid line. Toggling OS/browser dark mode repaints the whole page's colors instantly. The "Pro" card is visually distinct from the other two.

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md), [Solutions/solution-01.html](../Solutions/solution-01.html), and [Solutions/solution-01.css](../Solutions/solution-01.css).
