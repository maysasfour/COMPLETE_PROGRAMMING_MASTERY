"""
Lesson 04 - Operators
Demonstrates: arithmetic (incl. true vs floor division), comparison,
short-circuiting logical operators, is vs ==, membership, and bitwise ops.

Run with:
    python example.py

Expected output:
    --- Arithmetic ---
    7 / 3 = 2.3333333333333335 (true division always returns float)
    7 // 3 = 2 (floor division)
    -7 // 2 = -4 (floors toward negative infinity, not toward zero)
    7 % 3 = 1
    7 ** 3 = 343

    --- Logical operators short-circuit and return an operand, not just True/False ---
    0 and 5 -> 0 (returns the falsy left operand)
    '' or 'default' -> default (left falsy, returns right operand)
    5 and 10 -> 10 (both truthy, returns the last operand)

    --- is vs == ---
    a == b -> True (equal contents)
    a is b -> False (two distinct list objects)
    c is a -> True (c and a are bound to the same object)

    --- Membership ---
    3 in [1, 2, 3] -> True
    'a' in 'cat' -> True
    'a' in {'a': 1, 'b': 2} -> True (checks dict keys)
    'x' in {'a': 1, 'b': 2} -> False ('x' is not a key)

    --- Bitwise ---
    5 & 3 = 1
    5 | 3 = 7
    5 ^ 3 = 6
    5 << 1 = 10
    5 >> 1 = 2
"""

print("--- Arithmetic ---")
# / is "true division" in Python 3 - it ALWAYS returns a float, even when
# the numbers divide evenly, which surprises people coming from languages
# where int / int stays an int.
print(f"7 / 3 = {7 / 3} (true division always returns float)")
print(f"7 // 3 = {7 // 3} (floor division)")
# Floor division rounds toward NEGATIVE INFINITY, not toward zero - this
# is why a negative floor division doesn't match naive "truncate" intuition.
print(f"-7 // 2 = {-7 // 2} (floors toward negative infinity, not toward zero)")
print(f"7 % 3 = {7 % 3}")
print(f"7 ** 3 = {7 ** 3}")

print("\n--- Logical operators short-circuit and return an operand, not just True/False ---")
# `and`/`or` don't just produce True/False - they return whichever ORIGINAL
# operand determined the result, which is what makes the "x or default" idiom possible.
print(f"0 and 5 -> {0 and 5} (returns the falsy left operand)")
print(f"'' or 'default' -> {'' or 'default'} (left falsy, returns right operand)")
print(f"5 and 10 -> {5 and 10} (both truthy, returns the last operand)")

print("\n--- is vs == ---")
a = [1, 2, 3]
b = [1, 2, 3]
c = a
# a and b have equal CONTENTS but are two separate list objects in memory.
print(f"a == b -> {a == b} (equal contents)")
print(f"a is b -> {a is b} (two distinct list objects)")
# c was assigned directly from a, so c and a are literally the same object.
print(f"c is a -> {c is a} (c and a are bound to the same object)")

print("\n--- Membership ---")
print(f"3 in [1, 2, 3] -> {3 in [1, 2, 3]}")
print(f"'a' in 'cat' -> {'a' in 'cat'}")
# Membership on a dict checks its KEYS by default, not its values.
sample_dict = {"a": 1, "b": 2}
print(f"'a' in {sample_dict} -> {'a' in sample_dict} (checks dict keys)")
print(f"'x' in {sample_dict} -> {'x' in sample_dict} ('x' is not a key)")

print("\n--- Bitwise ---")
print(f"5 & 3 = {5 & 3}")
print(f"5 | 3 = {5 | 3}")
print(f"5 ^ 3 = {5 ^ 3}")
print(f"5 << 1 = {5 << 1}")
print(f"5 >> 1 = {5 >> 1}")
