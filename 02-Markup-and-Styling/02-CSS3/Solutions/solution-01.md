# Solution 01 — Responsive Pricing Cards

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

Full markup/styles in [solution-01.html](solution-01.html) and [solution-01.css](solution-01.css). Key decisions:

- **`repeat(auto-fit, minmax(220px, 1fr))`** does all the reflow work — at narrow widths only one `220px+` column fits, so cards stack; as the viewport widens, more columns fit and `1fr` shares the remaining space equally. No `@media` query is needed purely for this reflow.
- **`.card--highlighted`** adds a `border: 2px solid var(--accent)` and a `::before`-positioned badge, rather than duplicating the whole card markup — the highlight is a style modifier on the same component, matching how real design systems flag a "recommended" variant.
- **Dark mode** only needed to override four `:root` custom properties inside `@media (prefers-color-scheme: dark)`; every rule elsewhere already references `var(--bg)` / `var(--card-bg)` / `var(--text)` / `var(--accent)`, so no component-level dark-mode logic was needed.
- **`transform: translateY(-4px)` on hover**, not `margin-top`, so the browser can animate on the compositor thread instead of re-running layout for every hovered card.

## Verification

Opened in a browser at three widths (narrow phone-sized, tablet-sized, and desktop-sized via DevTools device toolbar): observed 1, 2, then 3 columns respectively, with no code changes between them. Toggled DevTools' "Emulate CSS media feature prefers-color-scheme" between light and dark: all four custom properties repainted correctly and the Pro card's accent border remained visible in both themes.
