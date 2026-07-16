"""
Lesson 08 - Strings
Demonstrates: immutability, indexing/slicing (incl. negative indices and
step), f-strings and format specs (.2f, alignment, !r), common string
methods (strip/split/join/replace/upper/lower/startswith/endswith/find),
and encoding basics (str vs bytes, encode/decode, UTF-8 default).

Run with:
    python example.py

Expected output:
    --- Immutability ---
    original name: python
    new name after 'modification': Python (original variable was reassigned, not mutated)

    --- Indexing and slicing ---
    s[0]    = P
    s[-1]   = n
    s[2:4]  = th
    s[:3]   = Pyt
    s[3:]   = hon
    s[::2]  = Pto
    s[::-1] = nohtyP

    --- f-strings and format specs ---
    fixed 2 decimals:  3.14
    right-aligned:  '       Ada'
    left-aligned:   'Ada       |'
    center-aligned: '   Ada    |'
    !r shows quotes: 'Ada'
    !r disambiguates None from 'None': None

    --- Common string methods ---
    strip():      'hi'
    split(','):   ['a', 'b', 'c']
    join():       a,b,c
    replace():    bat
    upper/lower:  CAT / cat
    startswith:   True
    endswith:     True
    find('txt'):  5
    find('zzz'):  -1 (not found, no exception)

    --- Encoding: str vs bytes ---
    text: cafe with accent -> café
    encoded (utf-8): b'caf\xc3\xa9'
    decoded back:    café
    len(text) = 4 characters
    len(encoded) = 5 bytes (the accented e takes 2 bytes in UTF-8)
"""

print("--- Immutability ---")
name = "python"
print(f"original name: {name}")
# name.upper() returns a NEW string - it never changes `name` in place, since
# str objects cannot be mutated. We must reassign to observe the "change".
name = name[0].upper() + name[1:]
print(f"new name after 'modification': {name} (original variable was reassigned, not mutated)")

print("\n--- Indexing and slicing ---")
s = "Python"
print(f"s[0]    = {s[0]}")
print(f"s[-1]   = {s[-1]}")       # negative index counts from the end
print(f"s[2:4]  = {s[2:4]}")      # stop index is exclusive
print(f"s[:3]   = {s[:3]}")       # omitted start defaults to 0
print(f"s[3:]   = {s[3:]}")       # omitted stop defaults to len(s)
print(f"s[::2]  = {s[::2]}")      # step of 2 skips every other character
print(f"s[::-1] = {s[::-1]}")     # negative step walks backward - reverses the string

print("\n--- f-strings and format specs ---")
pi = 3.14159265
person = "Ada"
print(f"fixed 2 decimals:  {pi:.2f}")
# Alignment specs pad to a fixed field width, useful for tabular CLI output.
print(f"right-aligned:  '{person:>10}'")
print(f"left-aligned:   '{person:<10}|'")
print(f"center-aligned: '{person:^10}|'")
# !r calls repr() instead of str() - it shows the quotes, which is what
# makes it useful for disambiguating None from the literal string "None".
print(f"!r shows quotes: {person!r}")
maybe_missing = None
print(f"!r disambiguates None from 'None': {maybe_missing!r}")

print("\n--- Common string methods ---")
# None of these mutate their target - each returns a new str (or list).
print(f"strip():      {'  hi  '.strip()!r}")
parts = "a,b,c".split(",")
print(f"split(','):   {parts}")
print(f"join():       {','.join(parts)}")
print(f"replace():    {'cat'.replace('c', 'b')}")
print(f"upper/lower:  {'Cat'.upper()} / {'Cat'.lower()}")
print(f"startswith:   {'file.txt'.startswith('file')}")
print(f"endswith:     {'file.txt'.endswith('.txt')}")
# .find() returns -1 instead of raising, which suits an `if ... != -1` check.
print(f"find('txt'):  {'file.txt'.find('txt')}")
print(f"find('zzz'):  {'file.txt'.find('zzz')} (not found, no exception)")

print("\n--- Encoding: str vs bytes ---")
text = "café"
print(f"text: cafe with accent -> {text}")
# .encode() turns the abstract Unicode str into concrete bytes using a
# chosen rulebook (UTF-8 here, and Python's default almost everywhere).
encoded = text.encode("utf-8")
decoded = encoded.decode("utf-8")
print(f"encoded (utf-8): {encoded!r}")
print(f"decoded back:    {decoded}")
# len() means something different for each type: characters for str,
# raw bytes for bytes - they diverge whenever multi-byte characters exist.
print(f"len(text) = {len(text)} characters")
print(f"len(encoded) = {len(encoded)} bytes (the accented e takes 2 bytes in UTF-8)")
