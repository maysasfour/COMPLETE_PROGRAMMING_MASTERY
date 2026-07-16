# 01 — HTML5

[Back to module overview](../README.md)

## Learning Objectives

- Write a valid, semantic HTML5 document from scratch without a template generator.
- Choose the correct semantic element (`<article>`, `<section>`, `<nav>`, `<aside>`, `<header>`, `<footer>`, `<main>`) instead of defaulting to `<div>` everywhere.
- Build accessible forms with proper labels, input types, and validation attributes.
- Build tables that are actually structured for tabular data, not layout.
- Embed images, audio, and video with the accessibility and performance attributes browsers expect.
- Explain what makes a page accessible to screen readers and discoverable by search engines.

## Prerequisites

None — this is the entry point of the markup track. Basic familiarity with files and a text editor is assumed (covered in [19-Command-Line-and-Operating-Systems](../../19-Command-Line-and-Operating-Systems/) if needed).

## Concept: What HTML Actually Is

HTML (HyperText Markup Language) is not a programming language — it has no variables, loops, or functions. It is a **markup language**: it wraps content in **elements** that describe what the content *is* (a heading, a paragraph, a list item), and the browser decides how to render each element type by default. CSS then overrides that default rendering, and JavaScript can manipulate the structure at runtime. HTML5 is the current living standard, maintained by the WHATWG, and is what every modern browser implements — there is no "HTML6" on the horizon; the spec evolves incrementally.

## Syntax: Document Skeleton

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Page Title</title>
</head>
<body>
  <!-- visible content goes here -->
</body>
</html>
```

- `<!DOCTYPE html>` must be the very first line. It tells the browser to use standards mode rather than a legacy quirks-mode rendering engine — omitting it silently changes how the box model and other layout rules behave.
- `lang="en"` is not decorative — screen readers use it to select pronunciation rules, and browsers use it for "translate this page?" prompts.
- `<meta charset="UTF-8">` must appear within the first 1024 bytes of the document; without it, non-ASCII characters (accents, curly quotes, emoji) can render as garbled text (mojibake).
- The viewport `<meta>` tag is what makes a page responsive on mobile at all — without it, mobile browsers render the page at a fixed desktop-like width (usually 980px) and zoom out, defeating any responsive CSS you write.

## Simple Example

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Hello</title>
</head>
<body>
  <h1>Hello, World</h1>
  <p>This is a paragraph.</p>
</body>
</html>
```

## Detailed Example

See [example.html](example.html) in this folder — a single runnable page demonstrating semantic layout, a form with validation, a data table, and media embeds together. Open it in any browser; there is no server or build step.

## Expected Output

A rendered page with: a page header and nav bar, a main article region, a data table of three rows, a contact form that refuses to submit until the required fields and email format are valid (browser-native validation, no JavaScript), and a footer. View the page source (Ctrl+U / Cmd+Option+U) to see the annotated markup alongside the rendering.

## Line-by-Line Explanation (Key Excerpts from `example.html`)

```html
<header>
  <h1>Semantic HTML5 Demo</h1>
  <nav>
    <ul>
      <li><a href="#about">About</a></li>
      <li><a href="#contact">Contact</a></li>
    </ul>
  </nav>
</header>
```
`<header>` here is the *page* header (it could also be scoped to a single `<article>`). `<nav>` marks a block of navigation links specifically — screen readers expose it as a distinct landmark region, letting users jump straight to navigation instead of tabbing through every link on the page.

```html
<main>
  <article id="about">
    ...
  </article>
</main>
```
`<main>` must appear exactly once per page and represents the dominant, non-repeated content — not the header, nav, or footer. `<article>` marks content that would make sense distributed/syndicated on its own (a blog post, a news story, a self-contained widget); if the content only makes sense in the context of the surrounding page, `<section>` is the better fit instead.

```html
<label for="email">Email</label>
<input type="email" id="email" name="email" required>
```
The `for`/`id` pairing is what links a label to its input programmatically — clicking the label focuses the input, and screen readers announce the label when the input receives focus. Without this pairing, sighted mouse users can still see which label goes with which field, but screen-reader users cannot. `type="email"` triggers browser-native format validation and, on mobile, switches the on-screen keyboard to one with `@` and `.` readily available.

## Common Mistakes

- Using `<div class="button">` instead of `<button>` — a real `<button>` is keyboard-focusable and triggers on both Enter and Space by default; a styled `<div>` gets neither for free.
- Nesting block-level elements inside inline elements the wrong way round (e.g. a `<div>` inside a `<span>`), producing invalid HTML that different browsers may auto-correct differently.
- Skipping heading levels (`<h1>` straight to `<h3>`) purely for font-size reasons — headings form a document outline that assistive technology relies on; use CSS for size, not heading level.
- Forgetting `alt` text on `<img>` — this breaks screen readers entirely and is also what search engines and browsers fall back to when the image fails to load.
- Building tables for page layout instead of tabular data — this is what CSS Flexbox/Grid (next lesson) are for.

## Best Practices

- Reach for a semantic element before a generic `<div>`/`<span>` whenever one fits (`<nav>`, `<header>`, `<footer>`, `<article>`, `<section>`, `<aside>`, `<figure>`, `<time>`).
- Always pair `<label>` with its input via `for`/`id`, even when the design doesn't visually show a label (use a visually-hidden CSS class, not a missing label).
- Use the most specific `input type` available (`email`, `tel`, `number`, `date`, `url`) — it gets you free validation and better mobile keyboards.
- Provide `alt=""` (empty, not omitted) for purely decorative images so screen readers skip them silently instead of reading a filename.

## Real-World Usage

Semantic structure is what powers screen-reader navigation, browser reader mode, search-engine result snippets, and social-media link previews (via Open Graph meta tags, which sit on top of a well-structured `<head>`). Framework-generated markup (React, Angular, Vue — covered in [03-Frontend-Development](../../03-Frontend-Development/)) still ultimately renders down to these same HTML elements; understanding this layer makes debugging rendered output in browser DevTools far easier.

## Performance Considerations

- Images should specify `width`/`height` attributes (even if CSS also sets a display size) so the browser can reserve layout space before the image loads, preventing content from jumping around (this is part of the Cumulative Layout Shift metric).
- `<script>` tags placed before content, without `defer`/`async`, block HTML parsing until the script downloads and runs — place scripts at the end of `<body>` or use `defer`.

## Security Considerations

- Never interpolate untrusted user input directly into HTML on the server without escaping it — this is how stored/reflected XSS happens (see [16-Security](../../16-Security/)).
- `target="_blank"` links to external sites should include `rel="noopener noreferrer"` — without it, the opened page can access `window.opener` and redirect your original tab (a reverse tabnabbing attack).

## Summary

- HTML is a markup language describing structure/meaning, not behavior or presentation.
- `<!DOCTYPE html>`, `lang`, `charset`, and the viewport meta tag are non-negotiable boilerplate with real functional consequences.
- Semantic elements (`<nav>`, `<main>`, `<article>`, `<section>`, etc.) communicate document structure to browsers, search engines, and assistive technology — generic `<div>`s do not.
- Forms need `<label for>`/`id` pairing and specific `input type`s to be both accessible and user-friendly.

## Key Terms

- **Semantic element** — an HTML tag whose name describes its content's meaning (`<article>`) rather than only its appearance (`<div>`).
- **Landmark region** — a semantic element (`<nav>`, `<main>`, `<header>`, `<footer>`, `<aside>`) that assistive technology exposes as a jump target.
- **Quirks mode** — a legacy browser rendering mode triggered by a missing/incorrect `<!DOCTYPE>`, with different box-model behavior than standards mode.
- **Reverse tabnabbing** — an attack where a page opened via `target="_blank"` uses `window.opener` to redirect the original tab.

## Review Questions

1. Why does a missing `<!DOCTYPE html>` matter even though the page might still look fine?
2. What is the functional (not just semantic) difference between `<button>` and a styled `<div>`?
3. Why must `<label for="x">` match the input's `id="x"` exactly?
4. When would you choose `<section>` over `<article>`?

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's the difference between `<section>` and `<article>`?**
   `<article>` is self-contained content that would still make sense on its own if syndicated elsewhere (a blog post, a product card). `<section>` groups related content that only makes sense within the surrounding page (a chapter within a page, a themed group of content). A page can have `<section>`s inside an `<article>`, or vice versa.

2. **Why is `<!DOCTYPE html>` required, and what happens without it?**
   It tells the browser to render in standards mode. Without it, older browsers (and some modern ones, for compatibility) fall back to quirks mode, which uses a different, less predictable box model and CSS parsing behavior — bugs that are hard to reproduce because they depend on browser-specific legacy behavior.

3. **Why use semantic elements instead of `<div>` for everything?**
   Accessibility (screen readers expose landmark regions and rely on correct heading structure), SEO (search engines weight semantic structure when generating result snippets), and maintainability (a codebase full of `<div>`s conveys no meaning to the next developer reading it).

4. **What does `rel="noopener noreferrer"` protect against on a `target="_blank"` link?**
   Without it, the newly opened page has access to `window.opener` and can navigate the original tab to a phishing page (reverse tabnabbing). `noopener` cuts that reference; `noreferrer` additionally suppresses the `Referer` header.

## Recommended Next Lesson

[02 — CSS3](../02-CSS3/README.md)
