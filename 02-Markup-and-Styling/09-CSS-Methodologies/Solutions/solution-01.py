import os
import re

BEM_CSS_PATH = os.path.join(os.path.dirname(__file__), "..", "bem", "alert.css")

CLASS_SELECTOR_PATTERN = re.compile(r"\.([a-zA-Z0-9_-]+)")

# A single underscore NOT part of a double underscore is a reliable signal of
# a BEM element-separator typo (".alert_title" instead of ".alert__title").
# Single HYPHENS are deliberately NOT flagged here -- unlike underscores,
# a single hyphen is also the normal, legitimate way to spell a multi-word
# block/element name in BEM itself (".date-picker" is a perfectly valid
# BEM block name, not a broken modifier) -- flagging every single hyphen
# would produce far too many false positives to be a useful check.
SINGLE_UNDERSCORE_PATTERN = re.compile(r"(?<!_)_(?!_)")


def find_bem_violations(css_source):
    violations = []
    for match in CLASS_SELECTOR_PATTERN.finditer(css_source):
        class_name = match.group(1)
        if SINGLE_UNDERSCORE_PATTERN.search(class_name):
            violations.append(f".{class_name}")
    return violations


if __name__ == "__main__":
    print(find_bem_violations(".alert { } .alert_title { } .alert--success { }"),
          "(expected ['.alert_title'])")
    print(find_bem_violations(".alert__title { } .alert--success { }"),
          "(expected [] -- correctly double-separated)")

    print("\n=== Checking this lesson's real bem/alert.css ===")
    with open(BEM_CSS_PATH, encoding="utf-8") as f:
        real_css = f.read()
    real_violations = find_bem_violations(real_css)
    print("Violations found:", real_violations, "(expected [] -- the real file is correctly written)")
