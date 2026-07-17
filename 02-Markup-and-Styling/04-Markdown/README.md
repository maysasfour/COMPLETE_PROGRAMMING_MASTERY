# 04 — Markdown

[Back to module overview](../README.md) | [Previous: Data Formats (XML, JSON, YAML)](../03-Data-Formats-XML-JSON-YAML/README.md)

## Learning Objectives

- Write standard Markdown syntax (headings, emphasis, lists, links, code blocks, blockquotes) and GitHub-Flavored Markdown extras (tables, task lists).
- Understand that "Markdown" is not one single, fully standardized language — different renderers support different feature sets by default.
- Recognize a real, common Markdown rendering bug: GitHub-Flavored features (tables, fenced code with language hints) silently failing to render with a plain/default Markdown processor.

## Concept: Markdown Is a Family of Dialects, Not One Spec

Markdown was originally a simple, informally-specified format (John Gruber's `Markdown.pl`). Since then, multiple **dialects** have grown around it — CommonMark (a rigorously specified attempt to standardize the core syntax) and GitHub-Flavored Markdown (GFM, which adds tables, task lists, strikethrough, and automatic URL linking on top of CommonMark) being the two most relevant in practice. This matters concretely: **a Markdown processor's *default* configuration may not support GFM's extras at all**, even though GFM features (especially tables) feel like "standard Markdown" to anyone who's only ever used them on GitHub.

## Detailed Example: A Real Rendering Gotcha, Reproduced Directly

[`sample.md`](sample.md) includes headings, emphasis, lists (including a GFM task list), a fenced code block, a link, and a GFM table. `implementation.py` renders it with Python's `markdown` library two ways:

**Without any extensions (the library's actual default):**
```
Contains a real <table> tag: False
Contains a proper fenced-code <pre><code> block with language info: False
What the table source became instead:
'Language | Typed | Year |\n|----------|-------|------|\n| Python   | Dynamic | 1991 |...'
```
The table source is left as **literal, un-rendered text** — pipes and dashes visible on the page exactly as typed, not a real `<table>`.

**With `extensions=["tables", "fenced_code", "sane_lists"]` explicitly enabled:**
```
Contains a real <table> tag: True
Contains a proper fenced-code <pre><code> block: True
```

This is a completely real, commonly-hit gotcha — anyone who writes a GFM table (second nature after using GitHub) and renders it through a plain/default Markdown library, expecting GitHub-identical output, will get silently broken-looking output with no error at all, exactly as reproduced above.

## How to Run

```bash
cd 02-Markup-and-Styling/04-Markdown
pip install markdown
python implementation.py
```

## Verified Output

```
=== Rendering sample.md WITHOUT extensions (python-markdown's default) ===
Contains a real <table> tag: False
Contains a proper fenced-code <pre><code> block with language info: False

=== Rendering sample.md WITH extensions=['tables', 'fenced_code', 'sane_lists'] ===
Contains a real <table> tag: True
Contains a proper fenced-code <pre><code> block: True

=== Structural checks on the extended render ===
  <h1>: FOUND
  <h2>: FOUND
  <strong>: FOUND
  <em>: FOUND
  <blockquote>: FOUND
  <ul>: FOUND
  <ol>: FOUND
  <a href="https://example.com">: FOUND
  <table>: FOUND
All expected structural elements present: True
```

## Common Mistakes

- Assuming any Markdown renderer supports GFM tables/task lists by default — many general-purpose Markdown libraries (including Python's `markdown` package, as demonstrated directly) require explicitly enabling extensions for GFM-specific features.
- Not reviewing rendered *output*, only the raw Markdown source, before publishing — an un-rendered table looks completely fine in the source file and only reveals the problem once actually rendered.
- Assuming "Markdown" means one single specification — CommonMark and GFM both extend/clarify the original informal Markdown.pl behavior differently, and different tools implement different subsets.

## Best Practices

- When using a Markdown library for anything beyond the most basic formatting, explicitly check and enable the extensions needed for the features actually being used (tables, fenced code, footnotes, etc.) rather than assuming defaults match GitHub's rendering.
- Add an automated check (like this lesson's exercise) to a documentation build pipeline that verifies expected structural elements (tables, code blocks) actually appear in rendered output, catching silent rendering failures before publishing.
- Prefer fenced code blocks (triple backticks with a language hint) over indented code blocks — they're unambiguous and let syntax highlighters know which language to apply.

## Summary

- Markdown is a family of related but non-identical dialects (original Markdown.pl, CommonMark, GitHub-Flavored Markdown) — not one fully standardized spec.
- A real, commonly-hit bug: GFM tables and language-hinted fenced code blocks require explicit extensions in many general-purpose Markdown libraries, and silently fail (left as literal text) without them — reproduced directly in this lesson, not just described.
- Checking rendered *output* for expected structural elements (not just reviewing Markdown source) is the reliable way to catch this class of bug before publishing.

## Key Terms

- **CommonMark** — a rigorously specified standardization of Markdown's core syntax, created to resolve inconsistencies between different implementations of the original informal spec.
- **GitHub-Flavored Markdown (GFM)** — GitHub's extension of CommonMark adding tables, task lists, strikethrough, and automatic URL linking.
- **Fenced code block** — a code block delimited by triple backticks (` ``` `), optionally followed by a language name for syntax highlighting, as opposed to an indented code block.

## Interview Questions

1. **Is Markdown a single, fully standardized language? Why does this matter practically?**
   No — it began as an informally specified format, and multiple dialects (CommonMark, GitHub-Flavored Markdown) have since formalized and extended it differently. Practically, this means the *same* Markdown source can render differently (or fail to render certain features at all) depending on which library/renderer processes it, as demonstrated directly in this lesson with GFM tables.

2. **Why did a GFM table fail to render as a real `<table>` element in this lesson's default configuration, and how was it fixed?**
   Python's `markdown` library's default configuration doesn't include GFM-specific features like tables — they require explicitly passing `extensions=["tables"]`. Without it, the table's Markdown source (pipes and dashes) is left as literal, un-rendered paragraph text. Enabling the extension fixes it, verified directly by checking for a real `<table>` tag in the output before and after.

3. **How would you catch a rendering bug like this automatically, rather than relying on someone visually reviewing rendered output?**
   Check the rendered HTML output programmatically for expected structural elements (a real `<table>` tag if the source contains a table, a real `<pre><code>` block if it contains fenced code) as part of a documentation build/CI pipeline — or, more specifically, check for the *absence* of tell-tale leftover source syntax (like a literal `|---|---|` separator row) that would only survive into the output if rendering failed, exactly as this lesson's exercise does.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Suggested Next Lesson

[05 — SVG](../05-SVG/README.md)
