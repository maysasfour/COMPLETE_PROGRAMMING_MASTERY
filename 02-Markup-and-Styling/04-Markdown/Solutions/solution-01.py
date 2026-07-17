import os
import re
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from implementation import render_default, render_with_extensions, SAMPLE_PATH

# Matches a Markdown table separator row like |---|---| or | :--- | ---: |,
# which should NEVER survive into correctly-rendered HTML as literal text --
# its presence proves the table extension wasn't applied.
TABLE_SEPARATOR_PATTERN = re.compile(r"\|[\s:-]+\|[\s:-]+\|")


def looks_like_unrendered_table(html):
    return bool(TABLE_SEPARATOR_PATTERN.search(html))


if __name__ == "__main__":
    with open(SAMPLE_PATH, encoding="utf-8") as f:
        source = f.read()

    default_html = render_default(source)
    extended_html = render_with_extensions(source)

    print("default (no extensions) render looks unrendered:", looks_like_unrendered_table(default_html),
          "(expected True)")
    print("extended (tables enabled) render looks unrendered:", looks_like_unrendered_table(extended_html),
          "(expected False)")
