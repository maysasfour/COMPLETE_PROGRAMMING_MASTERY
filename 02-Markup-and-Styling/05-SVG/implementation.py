"""SVG -- structural validation of a real SVG file using Python's
xml.etree.ElementTree (SVG IS XML, reusing Lesson 03's parsing technique
directly), since a browser rendering an SVG will happily hide the SAME kinds
of structural mistakes an XML parser would flag immediately."""

import os
import re
import xml.etree.ElementTree as ET

SVG_NAMESPACE = {"svg": "http://www.w3.org/2000/svg"}
ICON_PATH = os.path.join(os.path.dirname(__file__), "icon.svg")

# A path's `d` attribute is a mini-language of its own (M/L/C/A/Z commands and
# coordinates) -- this simple check only confirms it starts with a valid move
# command, not full path-syntax validation, which is out of scope here.
VALID_PATH_START = re.compile(r"^\s*[Mm]\s*[-\d.]")


def validate_svg(path):
    """SVG is XML -- `ET.parse` will raise a real ParseError on malformed SVG
    exactly the same way it would for the catalog.xml in Lesson 03. This is
    itself worth knowing: many "SVG rendering issues" are actually plain XML
    syntax errors that a browser silently tolerates/guesses around, while a
    strict XML parser (or an SVG optimizer/build tool) will not."""
    tree = ET.parse(path)
    root = tree.getroot()

    checks = {}
    checks["root is an <svg> element"] = root.tag == "{http://www.w3.org/2000/svg}svg"
    checks["has a viewBox attribute"] = root.get("viewBox") is not None

    view_box = root.get("viewBox", "")
    view_box_parts = view_box.split()
    checks["viewBox has exactly 4 numbers"] = len(view_box_parts) == 4

    paths = root.findall(".//svg:path", SVG_NAMESPACE)
    checks["contains at least one <path>"] = len(paths) > 0
    checks["every <path> has a valid-looking 'd' start"] = all(
        VALID_PATH_START.match(p.get("d", "")) for p in paths
    )

    gradients = root.findall(".//svg:linearGradient", SVG_NAMESPACE)
    checks["gradient (if present) has at least 2 stops"] = all(
        len(g.findall("svg:stop", SVG_NAMESPACE)) >= 2 for g in gradients
    ) if gradients else True

    return checks


if __name__ == "__main__":
    print("=== Validating icon.svg structurally (SVG IS XML) ===")
    results = validate_svg(ICON_PATH)
    for description, passed in results.items():
        print(f"  [{'PASS' if passed else 'FAIL'}] {description}")
    print("\nAll checks passed:", all(results.values()))

    print("\n=== A real XML parse error on malformed SVG, on purpose ===")
    malformed_svg = '<svg xmlns="http://www.w3.org/2000/svg"><rect x="0"></svg>'
    try:
        ET.fromstring(malformed_svg)
    except ET.ParseError as e:
        print(f"ET.fromstring raised a real ParseError: {e}")
        print("A browser would likely still render SOMETHING here, silently guessing "
              "how to recover -- an XML parser (or a build-time SVG linter/optimizer) "
              "will not, and catches the mistake immediately instead.")
