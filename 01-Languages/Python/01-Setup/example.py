r"""
Lesson 01 - Setup
There's no package to install here - this script instead inspects the
Python environment itself, which is the whole point of the "setup" lesson:
knowing what interpreter/version/path you're actually running against.

Run with:
    python example.py

Expected output (values will vary by machine, structure will not - this
was verified against Python 3.14.0 on Windows):
    Python version: 3.14.0 (tags/v3.14.0:...) [MSC v.1944 64 bit (AMD64)]
    Interpreter executable: C:\Python314\python.exe
    Platform: win32 (Windows)
    Running inside a virtual environment: False
    sys.path entries (where Python looks for imports):
      - ...
      - ...
"""

import sys
import platform

print(f"Python version: {sys.version}")
print(f"Interpreter executable: {sys.executable}")
print(f"Platform: {sys.platform} ({platform.system()})")

# `sys.prefix != sys.base_prefix` is the standard way to detect whether the
# CURRENT interpreter is a virtual environment rather than the system Python -
# venvs set sys.prefix to the venv folder while base_prefix stays the real install.
in_virtualenv = sys.prefix != sys.base_prefix
print(f"Running inside a virtual environment: {in_virtualenv}")

print("sys.path entries (where Python looks for imports):")
# Only show the first few - a full sys.path can be long and isn't the point here.
for entry in sys.path[:5]:
    # An empty string in sys.path means "the current directory" - worth
    # showing explicitly since it silently confuses people who expect a path.
    shown = entry if entry else "(current directory)"
    print(f"  - {shown}")
