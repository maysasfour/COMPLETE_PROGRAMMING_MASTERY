"""
Solution 01 - Modules and Packages
Driver script for the stringutils/ package built for exercise-01.
Run this FROM THIS DIRECTORY so stringutils/ is found on the import path.

Run with:
    python solution-01.py

Expected output:
    shout('hello world') = HELLO WORLD!
    word_count('hello world from python') = 4
"""

# This single import line is only possible because stringutils/__init__.py
# re-exports both names - without that, we'd need the longer
# `from stringutils.casing import shout` / `from stringutils.counting import word_count`.
from stringutils import shout, word_count

print("shout('hello world') =", shout("hello world"))
print("word_count('hello world from python') =", word_count("hello world from python"))
