"""Markdown -- rendering sample.md to real HTML with Python's `markdown`
library, and a genuine, real gotcha: GitHub-Flavored Markdown tables/fenced
code blocks do NOT render correctly with python-markdown's default
(CommonMark-incompatible, base "Markdown.pl"-style) settings -- extensions
must be explicitly enabled."""

import os

import markdown

SAMPLE_PATH = os.path.join(os.path.dirname(__file__), "sample.md")


def render_default(text):
    return markdown.markdown(text)


def render_with_extensions(text):
    return markdown.markdown(text, extensions=["tables", "fenced_code", "sane_lists"])


if __name__ == "__main__":
    with open(SAMPLE_PATH, encoding="utf-8") as f:
        source = f.read()

    print("=== Rendering sample.md WITHOUT extensions (python-markdown's default) ===")
    default_html = render_default(source)
    has_table_tag_default = "<table>" in default_html
    has_pre_code_default = "<pre><code>python" in default_html or "<pre><code class=\"python\">" in default_html
    print("Contains a real <table> tag:", has_table_tag_default)
    print("Contains a proper fenced-code <pre><code> block with language info:", has_pre_code_default)

    # Show what actually happened to the table source instead -- it's just
    # left as a literal paragraph of pipe-separated text, NOT parsed as a table.
    table_line_start = default_html.find("Language")
    print("What the table source became instead (first 200 chars from there):")
    print(repr(default_html[table_line_start:table_line_start + 200]))

    print("\n=== Rendering sample.md WITH extensions=['tables', 'fenced_code', 'sane_lists'] ===")
    extended_html = render_with_extensions(source)
    has_table_tag_extended = "<table>" in extended_html
    has_pre_code_extended = "<pre><code" in extended_html
    print("Contains a real <table> tag:", has_table_tag_extended)
    print("Contains a proper fenced-code <pre><code> block:", has_pre_code_extended)

    print("\n=== Structural checks on the extended render ===")
    checks = {
        "<h1>": "<h1>" in extended_html,
        "<h2>": "<h2>" in extended_html,
        "<strong>": "<strong>" in extended_html,
        "<em>": "<em>" in extended_html,
        "<blockquote>": "<blockquote>" in extended_html,
        "<ul>": "<ul>" in extended_html,
        "<ol>": "<ol>" in extended_html,
        '<a href="https://example.com">': '<a href="https://example.com">' in extended_html,
        "<table>": "<table>" in extended_html,
    }
    for tag, present in checks.items():
        print(f"  {tag}: {'FOUND' if present else 'MISSING'}")
    print("All expected structural elements present:", all(checks.values()))
