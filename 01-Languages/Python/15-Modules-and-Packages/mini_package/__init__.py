"""
mini_package - a tiny demo package used by ../example.py to illustrate the
import system: __init__.py, submodule imports, and package-level re-exports.

Importing `mini_package` runs this file, which is what makes `greet` and
`add` available directly as `mini_package.greet` / `mini_package.add`
instead of requiring callers to know the submodule names.
"""

from .greetings import greet
from .math_utils import add

# __all__ controls what `from mini_package import *` would pull in - it's
# also useful documentation of the package's intended public surface.
__all__ = ["greet", "add"]
