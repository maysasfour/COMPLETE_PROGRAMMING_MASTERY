"""
Solution 01 - Variables and Types
Runnable version of all four parts from exercise-01, plus both fixes
for Part 3, so predictions can be checked against real output.

Run with:
    python solution-01.py

Expected output:
    Part 1: [1, 2, 3]
    Part 2: [1, 2]
    Part 3: blocked as expected -> can only concatenate str (not "int") to str
    Part 4: 6
    Fix A (cast the string): 6
    Fix B (cast the int instead, build a string): 51
"""

print("Part 1:", end=" ")
# x and y are bound to the SAME list object, so mutating through x
# is visible through y - classic reference-type aliasing.
x = [1, 2]
y = x
x.append(3)
print(y)

print("Part 2:", end=" ")
# make_list() returns a NEW list object on every call, so x and y
# reference two independent lists despite looking identical at creation.
def make_list():
    return [1, 2]

x = make_list()
y = make_list()
x.append(3)
print(y)

print("Part 3:", end=" ")
# Python's strong typing refuses to silently coerce "5" (str) and 1 (int)
# into a common type the way a weakly typed language would.
count = "5"
try:
    total = count + 1
    print(total)
except TypeError as error:
    print(f"blocked as expected -> {error}")

print("Part 4:", end=" ")
# Explicit cast makes the intent (treat this string as a number) clear
# and turns a silent-failure risk into a deliberate, visible step.
count = "5"
total = int(count) + 1
print(total)

print("Fix A (cast the string):", int("5") + 1)
print("Fix B (cast the int instead, build a string):", "5" + str(1))
