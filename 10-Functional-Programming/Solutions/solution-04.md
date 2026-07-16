# Solution 04 — Composed Text Sanitizer

[Back to Solutions](README.md) | [Exercise](../Exercises/exercise-04-composed-text-sanitizer.md)

## Approach

Each of the three functions is small and independently verifiable: `collapse_whitespace` uses a regex to replace any run of whitespace with a single space and strips the ends; `remove_html_tags` strips anything matching `<...>`; `truncate(max_length)` is itself a function factory (like `min_length` in Exercise 02), returning a truncator configured for a specific length. `pipe()` is copied directly from Lesson 04.

The order chosen — `remove_html_tags` → `collapse_whitespace` → `truncate(30)` — matters: HTML tags removed first can leave extra whitespace behind (e.g., `<p>` and `</p>` removed leaves gaps where they were), so whitespace collapsing must happen *after* tag removal, not before. Truncation runs last so the final character-count limit applies to the actually-displayed, cleaned text, not to text still containing tags or raw whitespace that will later shrink.

Verified by running: all four standalone assertions passed silently (confirming each function in isolation), and the full pipeline correctly turned a messy, tag-and-whitespace-laden string into clean, truncated output.

## Reflection Answers

1. **Why does order matter — what breaks if `truncate` ran before `remove_html_tags`?** If truncation happened first, the character limit would be spent partly on HTML tag markup (`<p>`, `<b>`, etc.) that's about to be deleted anyway — the visible, actual text could end up shorter than intended, or a tag could be cut in half by the truncation, producing malformed/broken-looking output before `remove_html_tags` even runs. Running `remove_html_tags` first guarantees the character budget in `truncate` is spent entirely on real, user-visible text.

2. **Standalone assertion vs. tracing the full pipeline for a bug in `remove_html_tags`?** The standalone assertion (`assert remove_html_tags(...) == ...`) isolates the function completely — a failure there points directly at `remove_html_tags` with no other function's behavior involved, making the bug immediately locatable. Tracing through the full `sanitize` pipeline's output would require first determining *which* stage produced the wrong result, since the visible output has already been transformed by all three functions — the standalone test is strictly faster and more precise for isolating a bug in one specific stage.
