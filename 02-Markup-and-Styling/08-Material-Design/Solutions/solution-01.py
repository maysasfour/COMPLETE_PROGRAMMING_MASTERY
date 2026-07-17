import os
import re

CSS_PATH = os.path.join(os.path.dirname(__file__), "..", "styles.css")

# Matches a ".md-name { ... font-size: Npx; ... line-height: Mpx; ... }" block,
# tolerating either property appearing first (both orders are used in
# styles.css: .md-headline has font-size before line-height; all three do,
# in fact, but this pattern doesn't assume a fixed order regardless).
RULE_PATTERN = re.compile(
    r"(\.md-[\w-]+)\s*\{([^}]*)\}"
)
FONT_SIZE_PATTERN = re.compile(r"font-size:\s*(\d+)px")
LINE_HEIGHT_PATTERN = re.compile(r"line-height:\s*(\d+)px")


def check_line_height_ratios(css_source, min_ratio, max_ratio):
    violations = []
    for rule_match in RULE_PATTERN.finditer(css_source):
        selector, body = rule_match.group(1), rule_match.group(2)
        font_size_match = FONT_SIZE_PATTERN.search(body)
        line_height_match = LINE_HEIGHT_PATTERN.search(body)
        if not font_size_match or not line_height_match:
            continue  # not a type-scale rule (e.g. .md-button has font-size but no line-height)

        font_size = int(font_size_match.group(1))
        line_height = int(line_height_match.group(1))
        ratio = line_height / font_size

        if not (min_ratio <= ratio <= max_ratio):
            violations.append((selector, ratio))

    return violations


if __name__ == "__main__":
    with open(CSS_PATH, encoding="utf-8") as f:
        css_source = f.read()

    print("=== Checking this lesson's real type scale (1.3x - 1.7x expected) ===")
    violations = check_line_height_ratios(css_source, 1.3, 1.7)
    print("Violations:", violations, "(expected [] -- all three type-scale rules are within range)")

    print("\n=== A deliberately introduced violation, to prove the check works ===")
    broken_css = css_source + "\n.md-overline { font-size: 10px; line-height: 30px; }"
    broken_violations = check_line_height_ratios(broken_css, 1.3, 1.7)
    print("Violations:", broken_violations, "(expected one: .md-overline at ratio 3.0, way outside range)")
