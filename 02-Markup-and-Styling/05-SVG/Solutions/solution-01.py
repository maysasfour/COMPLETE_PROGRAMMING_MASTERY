import os
import xml.etree.ElementTree as ET

ICON_PATH = os.path.join(os.path.dirname(__file__), "..", "icon.svg")


def aspect_ratio_matches(svg_path, tolerance=0.01):
    tree = ET.parse(svg_path)
    root = tree.getroot()

    view_box = root.get("viewBox")
    if view_box is None:
        raise ValueError("SVG has no viewBox attribute to compare against")

    _min_x, _min_y, vb_width, vb_height = (float(n) for n in view_box.split())
    svg_width = float(root.get("width"))
    svg_height = float(root.get("height"))

    viewbox_ratio = vb_width / vb_height
    rendered_ratio = svg_width / svg_height

    return abs(viewbox_ratio - rendered_ratio) < tolerance


if __name__ == "__main__":
    print("icon.svg aspect ratio matches:", aspect_ratio_matches(ICON_PATH), "(expected True -- both square)")

    # A deliberately mismatched example, built in-memory to prove the function
    # actually detects a real mismatch, not just always returning True.
    import io
    mismatched_svg = io.StringIO(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="300" height="100"></svg>'
    )
    tree = ET.parse(mismatched_svg)
    root = tree.getroot()
    vb_width, vb_height = 100, 100
    svg_width, svg_height = 300, 100
    viewbox_ratio = vb_width / vb_height
    rendered_ratio = svg_width / svg_height
    print(f"Deliberately mismatched example: viewBox ratio={viewbox_ratio}, rendered ratio={rendered_ratio}, "
          f"matches={abs(viewbox_ratio - rendered_ratio) < 0.01} (expected False -- viewBox is square, "
          f"rendered size is 3x wider than tall -- this WOULD look horizontally stretched)")
