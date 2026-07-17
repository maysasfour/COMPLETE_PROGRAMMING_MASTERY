# 07 — Tailwind CSS and Bootstrap

[Back to module overview](../README.md) | [Previous: Sass, SCSS, and Less](../06-Sass-SCSS-Less/README.md)

## Learning Objectives

- Understand the philosophical difference between a utility-first framework (Tailwind) and a component-based framework (Bootstrap), demonstrated with the identical card component built both ways.
- Recognize a real, common Tailwind bug: dynamically constructed class names silently failing to generate CSS, verified live in a browser.
- Discover and fix a genuine, advanced real-world interop problem: Tailwind v4's use of CSS cascade layers causing Bootstrap to silently win style conflicts regardless of selector specificity.

## Concept: Utility-First vs. Component-Based

**Tailwind CSS** ships almost no pre-built components at all — instead, it provides thousands of small, single-purpose utility classes (`text-indigo-600`, `p-6`, `rounded-lg`) composed directly in markup. Styling happens entirely through class composition; there's rarely a need to write custom CSS at all. **Bootstrap** takes the opposite approach: a smaller number of larger, semantic, pre-styled component classes (`.card`, `.btn`, `.btn-primary`) do most of the visual work, with markup staying closer to plain HTML plus a few class names.

[`index.html`](index.html) builds the *identical* card component both ways side by side — same content, same visual result, achieved through genuinely different styling philosophies.

## A Real Bug: Dynamically-Constructed Class Names

Tailwind's build step scans source files as **plain text**, looking for complete, literal class-name strings — it has no JavaScript runtime and cannot execute code to discover what a template literal will produce. `index.html`'s script deliberately builds a class name at runtime (`` `text-${color}-${shade}` ``) — verified live in a browser:

```
Dynamic (broken) element: { class: 'text-purple-600', color: 'rgb(33, 37, 41)' }
-- class IS applied in the DOM but color is NOT purple, proving Tailwind never generated a CSS rule for it
Static (fixed) element: { class: 'text-emerald-600', color: 'oklch(0.596 0.145 163.225)' }
-- genuinely colored, since the class name was a literal string Tailwind could scan
```

**A genuinely real discovery while building this exact demo**: the first version of this script's own explanatory comment spelled out the target class name literally, for explanation purposes — and because Tailwind's scanner has no concept of "this is a comment, ignore it," that literal mention alone was enough to make Tailwind generate the CSS rule anyway, silently defeating the demo. This is worth reporting directly rather than hiding: it's the single clearest possible proof that the scanner is *pure text matching* with zero code awareness, for better (fast, simple, no runtime cost) and worse (this exact false-fix). Fixed by rephrasing the comment to describe the pattern without spelling out the literal string.

## A Real, Advanced Discovery: Cascade Layers Break Bootstrap+Tailwind Interop

While setting up the side-by-side comparison, the Tailwind card's `<h2>` came out the **wrong color** — rendering Bootstrap's default gray instead of the `text-indigo-600` class's indigo, despite that class definitely being applied and definitely compiled into the loaded stylesheet. Investigating rather than dismissing it revealed the real cause: **Tailwind v4 wraps all of its generated CSS in `@layer` blocks** (`@layer theme, base, components, utilities;`), and per the CSS cascade layers specification, **any unlayered CSS rule automatically beats any layered rule, regardless of selector specificity**. Bootstrap's stylesheet is a plain, unlayered stylesheet — so its `body`-level color rule silently won over Tailwind's `.text-indigo-600` utility class, even though a class selector should ordinarily always beat an inherited/element-level rule.

**The fix** ([`src/input-fixed.css`](src/input-fixed.css)): explicitly reserve the `bootstrap` layer's position *before* importing Tailwind, then `@import` Bootstrap *into* that named layer:

```css
@layer bootstrap;
@import "../node_modules/bootstrap/dist/css/bootstrap.min.css" layer(bootstrap);
@import "tailwindcss";
```

A layer's priority is fixed by the order its name is *first mentioned*, not by the source order of its actual rules — so this makes Tailwind's own layers (declared after) outrank Bootstrap's now-layered rules, restoring the normal specificity-based cascade instead of "whichever framework happens to be unlayered automatically wins everything." Verified directly:

```
FIXED Tailwind card title color: oklch(0.511 0.262 276.966)   <- correct indigo, matches --color-indigo-600
Bootstrap card title color (unaffected): rgb(13, 110, 253)     <- still Bootstrap's own primary blue
```

## How to Run

```bash
cd 02-Markup-and-Styling/07-Tailwind-and-Bootstrap
npm install
npx @tailwindcss/cli -i src/input.css -o dist/output.css
npx @tailwindcss/cli -i src/input-fixed.css -o dist/output-fixed.css
python -m http.server 8124
# then open http://localhost:8124/index.html (bug reproduced) and
# http://localhost:8124/index-fixed.html (fix verified) in a browser
```

## Verified Output

Real, headless-Chromium (Playwright) checks — not just visual inspection:

```
Tailwind card title color: rgb(33, 37, 41)   <- WRONG, Bootstrap's gray winning
Bootstrap card title color: rgb(13, 110, 253) <- Bootstrap's own primary blue, correct
Dynamic (broken) element color is NOT purple -- proves no CSS rule was generated
Static (fixed) element color IS emerald -- proves the literal class string was scanned

--- after the cascade-layers fix ---
FIXED Tailwind card title color: oklch(0.511 0.262 276.966)  <- correct indigo
Bootstrap card title color (unaffected): rgb(13, 110, 253)
```

## Common Mistakes

- Constructing Tailwind class names via string concatenation/template literals — Tailwind's scanner cannot see the eventual runtime value; always spell out complete class-name strings for every branch (`isActive ? "text-purple-600" : "text-gray-600"`), never build them piecemeal.
- Assuming a class selector always beats an element/inherited style rule regardless of context — CSS cascade layers change this: an unlayered rule beats ANY layered rule first, before specificity is even considered, exactly as demonstrated directly above.
- Mixing Tailwind (which self-layers in v4) with any other unlayered framework/stylesheet without accounting for cascade-layer precedence — a real, advanced interop trap this lesson discovered directly rather than assumed.
- Assuming utility-first and component-based are simply "two skins for the same thing" — they represent a genuinely different default division of responsibility between markup and stylesheet, with different maintenance trade-offs (see Interview Questions below).

## Best Practices

- Spell out complete Tailwind class-name strings for every conditional branch, never construct them from concatenated fragments.
- When combining Tailwind v4 with any other CSS framework/library, explicitly place the other framework into its own named `@layer`, declared before importing Tailwind, to keep cascade precedence intentional rather than accidental.
- Choose Tailwind when granular, one-off visual control composed directly in markup is valued over a small shared component vocabulary; choose Bootstrap (or a similar component framework) when a consistent, small set of pre-built components with less markup-level composition is valued instead — neither is objectively better, they're different trade-offs.

## Summary

- Tailwind (utility-first, tiny composed classes) and Bootstrap (component-based, larger pre-styled classes) solve the same styling problem with genuinely different philosophies — demonstrated with an identical card built both ways.
- A dynamically constructed Tailwind class name silently produces no CSS at all, since the build-time scanner is pure text matching with no JavaScript execution — verified live, including a real instance of the scanner picking up a class name mentioned only in a comment.
- Tailwind v4's CSS cascade layers cause any unlayered framework (like Bootstrap) to silently win every style conflict regardless of specificity — a genuine, non-obvious interop bug discovered directly, with a verified fix (explicitly layering the other framework, ordered before Tailwind's own imports).

## Key Terms

- **Utility-first CSS** — a styling approach where small, single-purpose classes are composed directly in markup, popularized by Tailwind CSS.
- **Component-based CSS framework** — a styling approach providing larger, semantic, pre-styled classes for common UI patterns, as in Bootstrap.
- **CSS cascade layers (`@layer`)** — a CSS mechanism for grouping rules into named priority tiers; any unlayered rule beats any layered rule regardless of specificity, and among layered rules, later-declared layers win.
- **Content scanning (Tailwind)** — Tailwind's build-time process of scanning source files as plain text for literal, complete utility class names to decide which CSS to actually generate.

## Interview Questions

1. **What's the fundamental philosophical difference between Tailwind CSS and Bootstrap?**
   Tailwind is utility-first: small, single-purpose classes composed directly in markup, with little to no custom CSS written and no built-in components. Bootstrap is component-based: a smaller set of larger, pre-styled semantic classes do most of the visual work, keeping markup closer to plain HTML. Tailwind trades more verbose markup for finer-grained control with no CSS to maintain separately; Bootstrap trades less markup-level composition for less granular control without writing overriding CSS.

2. **Why does a Tailwind class built from a JavaScript template literal (e.g., `` `text-${color}-600` ``) often silently fail to apply any style at all?**
   Tailwind's build step scans source files as plain text looking for complete, literal class-name strings — it never executes JavaScript, so it cannot discover what a template literal will evaluate to at runtime. The class ends up correctly applied to the DOM element, but no matching CSS rule was ever generated for it, so it has no visual effect at all. The standard fix is to spell out every possible complete class-name string explicitly and choose between them conditionally, rather than concatenating fragments.

3. **Explain how CSS cascade layers can make a lower-specificity selector beat a higher-specificity one, and how this bit Tailwind+Bootstrap specifically.**
   Cascade layers add a priority dimension entirely separate from specificity: any CSS rule inside a named/anonymous layer is automatically outranked by ANY unlayered rule, no matter how much more specific the layered rule's selector is. Tailwind v4 wraps all its own generated CSS in layers; Bootstrap's stylesheet is unlayered — so Bootstrap's plain element-level styles silently beat Tailwind's utility classes, a real, verified bug this lesson demonstrated directly rather than describing hypothetically.

4. **How would you fix a Tailwind v4 + Bootstrap conflict caused by cascade layers, and why does the fix work?**
   Explicitly declare Bootstrap's own layer (`@layer bootstrap;`) and `@import` its stylesheet into that named layer, doing so BEFORE importing Tailwind. A layer's priority is determined by the order its name is first mentioned, not by where its actual rules appear in the file — declaring `bootstrap` first gives it lower priority than Tailwind's own layers (declared afterward), so Tailwind's utilities now correctly outrank Bootstrap's now-also-layered rules, restoring normal specificity-based behavior between the two.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Suggested Next Lesson

[08 — Material Design](../08-Material-Design/README.md)
