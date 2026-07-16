"""
Lesson 05 - Memory Concepts
Demonstrates: stack exhaustion from unbounded recursion, mutation
visible through a shared reference vs. rebinding a local parameter
being invisible to the caller, and the tuple-can-hold-mutable-data
caveat.

Run with:
    python example.py

Expected output:
    --- Stack: recursion without a base case exhausts it ---
    Caught expected error: maximum recursion depth exceeded

    --- Reference semantics: mutation is visible to the caller ---
    Before modify_list: [1, 2, 3]
    After modify_list:  [1, 2, 3, 99]

    --- Rebinding a parameter does NOT affect the caller ---
    Before modify_number: 5
    After modify_number:  5

    --- Mutability: strings are immutable, lists are mutable ---
    Blocked as expected: 'str' object does not support item assignment
    List mutated in place: [1, 2, 3, 4]

    --- Tuple caveat: outer structure frozen, inner list still mutable ---
    Tuple after mutating its inner list: ([1, 2, 3], 'fixed')
    Blocked as expected: 'tuple' object does not support item assignment
"""

import sys

print("--- Stack: recursion without a base case exhausts it ---")
sys.setrecursionlimit(2000)  # keep the demo fast rather than waiting on the default 1000+ depth


def infinite_recursion(n):
    # No base case at all - every call recurses again, so this can only
    # ever end when the stack itself runs out of frames to allocate.
    return infinite_recursion(n + 1)


try:
    infinite_recursion(0)
except RecursionError as error:
    print(f"Caught expected error: {error}")

print("\n--- Reference semantics: mutation is visible to the caller ---")


def modify_list(lst):
    # This mutates the SAME heap object `numbers` refers to - there is
    # only one list here, and both names see it.
    lst.append(99)


numbers = [1, 2, 3]
print("Before modify_list:", numbers)
modify_list(numbers)
print("After modify_list: ", numbers)

print("\n--- Rebinding a parameter does NOT affect the caller ---")


def modify_number(n):
    # This does not mutate anything - it points the LOCAL name `n` at a
    # new int object. The caller's `value` still points at the old one.
    n = n + 1


value = 5
print("Before modify_number:", value)
modify_number(value)
print("After modify_number: ", value)

print("\n--- Mutability: strings are immutable, lists are mutable ---")
name = "Ana"
try:
    name[0] = "B"  # strings forbid in-place item assignment entirely
except TypeError as error:
    print(f"Blocked as expected: {error}")

mutable_list = [1, 2, 3]
mutable_list.append(4)  # lists explicitly support in-place modification
print("List mutated in place:", mutable_list)

print("\n--- Tuple caveat: outer structure frozen, inner list still mutable ---")
t = ([1, 2], "fixed")
t[0].append(3)  # legal: the LIST inside the tuple is still a mutable object
print("Tuple after mutating its inner list:", t)

try:
    t[0] = [9]  # illegal: this would reassign the tuple's own slot, which is frozen
except TypeError as error:
    print(f"Blocked as expected: {error}")
