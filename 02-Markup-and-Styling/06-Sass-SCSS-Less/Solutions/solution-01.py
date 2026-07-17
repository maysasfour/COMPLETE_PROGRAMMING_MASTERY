import os

MAIN_SCSS_PATH = os.path.join(os.path.dirname(__file__), "..", "src", "main.scss")


def max_nesting_depth(scss_source):
    depth = 0
    max_depth = 0
    for char in scss_source:
        if char == "{":
            depth += 1
            max_depth = max(max_depth, depth)
        elif char == "}":
            depth -= 1
    return max_depth


if __name__ == "__main__":
    print(max_nesting_depth(".a { .b { .c { color: red; } } }"), "(expected 3)")
    print(max_nesting_depth(".a { color: blue; }"), "(expected 1)")

    with open(MAIN_SCSS_PATH, encoding="utf-8") as f:
        main_scss_source = f.read()
    depth = max_nesting_depth(main_scss_source)
    print(f"this lesson's main.scss max nesting depth: {depth}")
