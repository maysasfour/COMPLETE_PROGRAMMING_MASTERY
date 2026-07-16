# __init__.py runs once, the first time anything imports the `shapes`
# package. Re-exporting `circle_area` and `rectangle_area` here lets
# callers do `from shapes import circle_area` without needing to know
# these functions actually live in shapes/circle.py and
# shapes/rectangle.py - the package hides that internal file layout.
from .circle import area as circle_area
from .rectangle import area as rectangle_area

__all__ = ["circle_area", "rectangle_area"]
