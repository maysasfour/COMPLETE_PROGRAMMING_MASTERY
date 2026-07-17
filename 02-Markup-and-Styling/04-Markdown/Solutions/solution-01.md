# Solution 01 — Detect Un-Rendered GFM Tables

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
default (no extensions) render looks unrendered: True (expected True)
extended (tables enabled) render looks unrendered: False (expected False)
```

## Explanation

A Markdown table's separator row always follows the pattern `|---|---|` (with optional spaces and alignment colons like `:---`/`---:`). When the `tables` extension isn't enabled, python-markdown leaves the entire table source — including that literal separator row — as plain paragraph text in the output HTML. The regular expression `\|[\s:-]+\|[\s:-]+\|` matches that specific leftover pattern; its presence in rendered HTML is a reliable signal that a table failed to convert.

## Reflection Answers

1. **Why an automated check matters.** A broken-looking table (raw pipes and dashes visible on a rendered page) is often easy to miss visually, especially in a long document, a PDF export, or content nobody reviews closely before publishing — an automated check in a documentation build pipeline catches it every single time, immediately, rather than depending on a human happening to scroll past and notice.

2. **Why a check like this is still worth having even after fixing the missing-extension cause.** The specific cause this lesson demonstrated (forgetting `extensions=["tables"]`) is one way tables can fail to render — but it's not the only one. A table could also fail to render correctly due to a malformed separator row in the *source* Markdown itself (e.g., a missing pipe character, inconsistent column counts between the header and separator rows) even with the extension correctly enabled — a check on the *output* catches both causes, whereas fixing the specific missing-extension bug only guards against that one specific cause.

3. **Adapting this approach to other extensions.** The same "check the *output* for a tell-tale unconverted pattern" idea applies directly to `fenced_code`: without it, a triple-backtick fenced code block (```` ```python ````) is left as literal backtick characters in the rendered HTML rather than becoming a real `<pre><code>` block — a check for literal ```` ``` ```` sequences surviving into the HTML output would catch that specific extension being missing, the same way this exercise catches a missing `tables` extension.

## Common Pitfalls

- Writing a regex that's too strict (e.g., requiring exactly three dashes) and missing valid separator-row variations (more dashes, alignment colons `:---`, `---:`, `:---:`) — the pattern here deliberately uses a character class (`[\s:-]+`) to match any reasonable combination of dashes, colons, and spaces.
- Checking the *source* Markdown for table syntax instead of the *rendered* HTML output — that only tells you a table was *attempted*, not whether it actually rendered correctly, which is the entire point of this check.
- Assuming a missing `<table>` tag alone is sufficient evidence of the bug — a document simply might not contain any tables at all, which is a completely different (and totally fine) situation from a table that failed to render; checking specifically for the *leftover separator syntax* avoids this false positive.
