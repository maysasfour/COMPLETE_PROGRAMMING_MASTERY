"""
Lesson 15 - Modules and Packages
Demonstrates: importing a local module (this file's own directory is on
sys.path when run directly), using a package (mini_package/) with an
__init__.py that re-exports names from two submodules, and inspecting
sys.modules to show the "imported once, then cached" behavior.

Run with:
    python example.py

Expected output:
    --- importing a package ---
    mini_package.greet('Ada') -> Hello, Ada!
    mini_package.add(2, 3) -> 5

    --- re-import is cached, not re-run ---
    mini_package already in sys.modules before 2nd import -> True
    id() is identical across both imports -> True

    --- __all__ documents the public surface ---
    mini_package.__all__ -> ['greet', 'add']
"""

import sys

import mini_package

print("--- importing a package ---")
print(f"mini_package.greet('Ada') -> {mini_package.greet('Ada')}")
print(f"mini_package.add(2, 3) -> {mini_package.add(2, 3)}")

print("\n--- re-import is cached, not re-run ---")
# By this point mini_package is already in sys.modules from the import at
# the top of this file - a second `import mini_package` below reuses the
# same cached module object instead of re-running its __init__.py.
was_cached_before = "mini_package" in sys.modules
first_id = id(mini_package)

import mini_package as mini_package_again  # noqa: E402 - intentional 2nd import for the demo

print("mini_package already in sys.modules before 2nd import ->", was_cached_before)
print("id() is identical across both imports ->", id(mini_package_again) == first_id)

print("\n--- __all__ documents the public surface ---")
print("mini_package.__all__ ->", mini_package.__all__)
