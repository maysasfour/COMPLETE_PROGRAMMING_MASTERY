# 06 — Sass, SCSS, and Less

[Back to module overview](../README.md) | [Previous: SVG](../05-SVG/README.md)

## Learning Objectives

- Write real Sass (`@use` module system) and Less stylesheets using variables, nesting, and mixins, and compile both to real CSS.
- Understand the modern `@use`/`@forward` module system versus the legacy `@import` directive, including a genuine deprecation warning from the real Sass compiler.
- Recognize that Sass and Less, while different tools with different syntax, solve the same core problem and can compile genuinely equivalent designs to equivalent CSS.

## Concept: What a CSS Preprocessor Actually Does

Plain CSS has no variables (well, it now has [custom properties](../02-CSS3/README.md), covered in the previous CSS3 lesson — but no nesting, no mixins, no math), no nesting, and no reusable logic blocks. A **preprocessor** (Sass/SCSS, Less) is a *different, superset language* that compiles down to plain CSS — you write in the richer language, and a compiler outputs standard CSS a browser can actually read. Sass has two syntaxes: the original indentation-based `.sass` and the more common, CSS-like `.scss` (used throughout this lesson); Less uses its own `.less` syntax, closer to plain CSS with `@variable` syntax.

## Detailed Example: The Same Design, in SCSS and Less

[`src/main.scss`](src/main.scss) and [`src/main.less`](src/main.less) both define the identical `.card` component (variables for color/spacing, a nested `&__title`/`&__button` BEM-style structure, and a reusable button mixin taking a color parameter) — `build.mjs` compiles both with their real JS APIs and confirms they produce **equivalent CSS**, verified directly rather than assumed:

```
Sass and Less output normalize to the same CSS: true
```

## A Real, Genuine Deprecation Warning: `@import` vs. the Modern `@use`

`main.scss` uses the modern module system (`@use "variables" as vars`), which loads a partial file **exactly once** regardless of how many other files `@use` it, and namespaces its variables (`vars.$primary-color`, not a bare global). [`src/legacy-import-style.scss`](src/legacy-import-style.scss) deliberately uses the older `@import` directive instead — running the real Sass compiler against it produces a genuine, current deprecation warning, not a hypothetical one:

```
DEPRECATION WARNING [import]: Sass @import rules are deprecated and will be removed in Dart Sass 3.0.0.
More info and automated migrator: https://sass-lang.com/d/import

  ╷
3 │ @import "variables";
  │         ^^^^^^^^^^^
  ╵
    src\legacy-import-style.scss 3:9  root stylesheet
```

`@import`'s real, historical problems that `@use` fixes: it pollutes a single global namespace (every `@import`ed file's variables/mixins become bare global names, risking silent collisions across a large project), and a file `@import`ed by multiple other files gets its rules and CSS output **duplicated** in the compiled output rather than loaded once.

## How to Run

```bash
cd 02-Markup-and-Styling/06-Sass-SCSS-Less
npm install
node build.mjs
```

## Verified Output

```
=== Compiling main.scss (modern @use module system) ===
.card { border: 1px solid #e5e7eb; padding: 16px; border-radius: 8px; }
.card__title { color: #4f46e5; font-size: 1.25rem; }
.card__button { background-color: #4f46e5; ...; border-radius: 4px; ... }
.card__button--danger { background-color: #dc2626; ...; border-radius: 4px; ... }
  [PASS] variable $primary-color resolved to #4f46e5
  [PASS] nesting flattened to real .card__title selector
  [PASS] mixin expanded for BOTH the default and danger button (2x "border-radius: 4px")
  [PASS] $spacing-unit * 2 arithmetic resolved to 16px

=== Compiling main.less ===
  [PASS] variable @primary-color resolved to #4f46e5
  [PASS] nesting flattened to real .card__title selector
  [PASS] mixin expanded for both buttons (2x "border-radius: 4px")

=== Sass and Less compile the SAME design to equivalent CSS ===
SCSS and Less output normalize to the same CSS: true
```

## Common Mistakes

- Using `&` incorrectly, expecting `.card { .title { ... } }` (no `&`) and `.card { &__title { ... } }` (with `&`) to compile the same way — they don't: the first produces the descendant selector `.card .title`, the second concatenates onto the parent's own class name, producing the flat `.card__title` — verified directly by this lesson's exercise, which specifically explores this distinction.
- Continuing to write new `@import`-based Sass — it's deprecated and scheduled for removal, produces a real warning as shown directly above, and has real global-namespace-pollution and duplicate-output problems `@use` was specifically created to fix.
- Assuming Sass and Less are interchangeable syntax for the same underlying tool — they're two genuinely separate preprocessor projects with their own syntax and compilers, that happen to solve overlapping problems (verified here to produce equivalent output for an equivalent design, but their syntax and feature sets are not identical).

## Best Practices

- Use `@use`/`@forward`, never `@import`, in any new Sass code — it's the current, non-deprecated module system.
- Namespace variables/mixins via `@use "file" as name` rather than relying on a shared global namespace, even in a small project — it costs nothing and prevents a real class of naming collision as a project grows.
- Reserve deep nesting for things that genuinely mirror a real structural/state relationship (like `&:hover`, `&__title` BEM-style concatenation); avoid nesting plain descendant selectors many levels deep, which compiles to increasingly specific, harder-to-override CSS (see this lesson's exercise).

## Summary

- A preprocessor (Sass/Less) compiles a richer, variable/nesting/mixin-supporting language down to plain CSS a browser can read.
- Sass's modern `@use` module system (namespaced, load-once) has replaced the deprecated `@import` (global namespace, duplicate output) — verified here with a real, current deprecation warning from the actual Sass compiler.
- Sass and Less are different tools with different syntax that can compile genuinely equivalent designs to equivalent CSS — verified directly by normalizing and comparing both compilers' real output.
- Nesting with `&` for BEM-style class concatenation (`&__title`) is structurally different from plain descendant nesting, despite looking similar in source — only the latter produces increasingly specific compiled selectors.

## Key Terms

- **Preprocessor** — a tool that compiles a superset/different language (Sass, Less) down to plain CSS.
- **`@use`/`@forward`** — Sass's modern, namespaced, load-once module system, replacing the deprecated `@import`.
- **Mixin** — a reusable, parameterized block of CSS declarations, included into a selector with `@include` (Sass) or by calling it like a selector (Less).
- **Parent selector (`&`)** — refers to the enclosing selector within a nested block; `&__title` concatenates onto the parent's class name rather than nesting a descendant selector.

## Interview Questions

1. **What problem does a CSS preprocessor like Sass or Less solve that plain CSS (even with modern custom properties) still doesn't?**
   Nesting (writing a selector's descendants inside it, rather than repeating the full selector chain), mixins (reusable, parameterized blocks of declarations), and richer computation (math on values, loops, conditionals) — plain CSS custom properties give you variables, but not nesting, mixins, or the same level of computed logic.

2. **Why is Sass's `@import` deprecated, and what does `@use` fix?**
   `@import` loads a file's contents directly, polluting a single shared global namespace (every imported file's variables/mixins become bare global names, risking silent naming collisions in larger projects) and duplicating output if the same file is imported from multiple places. `@use` loads a file exactly once regardless of how many other files `@use` it, and requires an explicit namespace prefix (`vars.$primary-color`) to access its contents, eliminating both problems.

3. **What's the real compiled difference between `.card { .title { color: red; } }` and `.card { &__title { color: red; } }` in Sass?**
   The first produces the CSS descendant selector `.card .title { color: red; }` — a real nested selector with correspondingly higher specificity. The second uses the parent-selector reference `&` to concatenate directly onto the parent's own class name, producing the flat, single-class selector `.card__title { color: red; }` with no added specificity at all, despite looking similarly "nested" in the Sass source.

4. **If Sass and Less are different tools, why might a team need to compare their compiled output when migrating between them?**
   Even though both preprocessors solve similar problems (variables, nesting, mixins), their exact feature sets, syntax, and edge-case behaviors differ — verifying that a design compiles to genuinely equivalent CSS (not just "looks similar" in source) before/after a migration is the only way to be confident the visual result hasn't silently changed, which is exactly what this lesson's `build.mjs` does directly rather than assuming.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Suggested Next Lesson

[07 — Tailwind CSS and Bootstrap](../07-Tailwind-and-Bootstrap/README.md)
