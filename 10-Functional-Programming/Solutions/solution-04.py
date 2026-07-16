"""Solution 04 - Composed Text Sanitizer."""

import re
from functools import reduce


def collapse_whitespace(s):
    return re.sub(r"\s+", " ", s).strip()


def remove_html_tags(s):
    return re.sub(r"<[^>]*>", "", s)


def truncate(max_length):
    def truncator(s):
        if len(s) <= max_length:
            return s
        return s[:max_length] + "..."
    return truncator


def compose_two(f, g):
    return lambda x: f(g(x))


def pipe(*functions):
    return reduce(compose_two, reversed(functions))


def main():
    # Standalone tests for each function, in isolation, BEFORE combining them.
    assert collapse_whitespace("  a   b\n\tc  ") == "a b c"
    assert remove_html_tags("<b>hello</b> <i>world</i>") == "hello world"
    assert truncate(5)("hello world") == "hello..."
    assert truncate(20)("short") == "short"
    print("all individual functions verified in isolation")

    # Order matters: strip tags FIRST, then collapse whitespace (tags might leave
    # extra whitespace behind), THEN truncate LAST (so length is measured on the
    # final, cleaned text, not on text still containing tags/extra whitespace).
    sanitize = pipe(remove_html_tags, collapse_whitespace, truncate(30))

    messy = "  <p>Hello,    <b>World</b>!</p>   This is a long sentence with extra text.  "
    print(f"\ninput:  {messy!r}")
    print(f"output: {sanitize(messy)!r}")


if __name__ == "__main__":
    main()
