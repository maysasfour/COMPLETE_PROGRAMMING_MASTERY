"""Material Design principles: the 8dp spacing grid, verified
programmatically against the real stylesheet (not just eyeballed), plus a
real ripple-interaction demo verified live in a browser via ripple_check.mjs."""

import os
import re

CSS_PATH = os.path.join(os.path.dirname(__file__), "styles.css")

# Matches a --md-space-N custom property declaration and its pixel value.
SPACE_VAR_PATTERN = re.compile(r"--md-space-\d+:\s*(\d+)px")


def find_spacing_values(css_source):
    return [int(match.group(1)) for match in SPACE_VAR_PATTERN.finditer(css_source)]


def verify_8dp_grid(css_source):
    """Material Design's spacing system requires every spacing value to be a
    multiple of a single base unit (8dp / 8px here) -- this is what keeps
    layouts visually consistent across an entire design system, rather than
    every component inventing its own arbitrary spacing numbers."""
    values = find_spacing_values(css_source)
    violations = [v for v in values if v % 8 != 0]
    return values, violations


if __name__ == "__main__":
    with open(CSS_PATH, encoding="utf-8") as f:
        css_source = f.read()

    print("=== Verifying the 8dp spacing grid against the real stylesheet ===")
    values, violations = verify_8dp_grid(css_source)
    print("Spacing values found:", values)
    print("Values NOT a multiple of 8 (should be empty):", violations)
    print("Entire spacing system honors the 8dp grid:", len(violations) == 0)

    print("\n=== A deliberately introduced violation, to prove the check actually works ===")
    broken_css = css_source + "\n:root { --md-space-5: 13px; }"
    _, broken_violations = verify_8dp_grid(broken_css)
    print("Values NOT a multiple of 8 after adding a bad one:", broken_violations)
    print("Check correctly catches the violation:", broken_violations == [13])
