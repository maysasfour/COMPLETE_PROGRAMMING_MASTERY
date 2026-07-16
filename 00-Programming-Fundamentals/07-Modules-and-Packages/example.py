"""
Lesson 07 - Modules and Packages
Demonstrates: importing a sibling module (math_utils.py), the
`import X` vs `from X import Y` vs `import X as alias` styles, and
importing from a package (shapes/) whose __init__.py re-exports
functions from its inner modules.

Run this file FROM THIS DIRECTORY so the sibling module/package are
found on the import path:
    python example.py

Expected output:
    --- import math_utils (access via module name) ---
    math_utils.add(2, 3) = 5

    --- from math_utils import multiply (direct name) ---
    multiply(4, 5) = 20

    --- import math_utils as mu (aliased module) ---
    mu.add(10, 20) = 30

    --- Package import: shapes/ re-exports via __init__.py ---
    circle_area(radius=2) = 12.566370614359172
    rectangle_area(width=3, height=4) = 12

    --- sys.modules proves math_utils was only executed once ---
    math_utils cached after first import: True
"""

import sys

print("--- import math_utils (access via module name) ---")
# The full module namespace is accessible only through `math_utils.`,
# which keeps it obvious in the rest of this file exactly where add()
# came from.
import math_utils
print("math_utils.add(2, 3) =", math_utils.add(2, 3))

print("\n--- from math_utils import multiply (direct name) ---")
# `multiply` is now usable directly, without the `math_utils.` prefix -
# convenient, but the reader has to trust the top-of-file import line
# to know where it came from.
from math_utils import multiply
print("multiply(4, 5) =", multiply(4, 5))

print("\n--- import math_utils as mu (aliased module) ---")
# Aliasing is useful for long module names or to avoid a name clash
# with something else already using the name `math_utils` in this file.
import math_utils as mu
print("mu.add(10, 20) =", mu.add(10, 20))

print("\n--- Package import: shapes/ re-exports via __init__.py ---")
# shapes/__init__.py imports `area` from shapes/circle.py and
# shapes/rectangle.py and re-exposes them as circle_area/rectangle_area,
# so we never need to know the package's internal file layout here.
from shapes import circle_area, rectangle_area
print("circle_area(radius=2) =", circle_area(radius=2))
print("rectangle_area(width=3, height=4) =", rectangle_area(width=3, height=4))

print("\n--- sys.modules proves math_utils was only executed once ---")
# Even though we imported math_utils three different ways above, Python
# only ran the file's top-level code ONCE and cached the resulting
# module object - every subsequent import reused that same cached object.
print("math_utils cached after first import:", "math_utils" in sys.modules)
