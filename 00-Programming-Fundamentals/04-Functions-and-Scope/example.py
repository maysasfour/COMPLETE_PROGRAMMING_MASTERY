"""
Lesson 04 - Functions and Scope
Demonstrates: parameters/arguments/return values, the LEGB scope rule,
the mutable-default-argument pitfall, closures, and recursion with a
clear base case.

Run with:
    python example.py

Expected output:
    --- Parameters, arguments, return values ---
    greet('Ana') -> Hello, Ana!
    greet('Ana', greeting='Hi') -> Hi, Ana!

    --- LEGB scope resolution ---
    inner sees: local
    outer sees (after inner ran): enclosing
    module sees (after outer ran): global

    --- Mutable default argument pitfall ---
    Buggy version call 1: ['item']
    Buggy version call 2 (should be fresh, but isn't): ['item', 'item']
    Fixed version call 1: ['item']
    Fixed version call 2 (correctly independent): ['item']

    --- Closures ---
    double(5) = 10
    triple(5) = 15

    --- Recursion ---
    factorial(5) = 120
"""

print("--- Parameters, arguments, return values ---")
# `name` and `greeting` are PARAMETERS; the strings passed at the call
# site are ARGUMENTS; the f-string built inside is the RETURN VALUE.
def greet(name, greeting="Hello"):
    return f"{greeting}, {name}!"

print("greet('Ana') ->", greet("Ana"))
print("greet('Ana', greeting='Hi') ->", greet("Ana", greeting="Hi"))

print("\n--- LEGB scope resolution ---")
x = "global"

def outer():
    x = "enclosing"

    def inner():
        # Assigning here creates a NEW local `x` - it does not touch
        # outer()'s `x`, even though the name is identical.
        x = "local"
        print("inner sees:", x)

    inner()
    # outer()'s own `x` is untouched by inner()'s local assignment -
    # this is the LEGB rule in action: each scope's assignment is local
    # to itself unless `nonlocal`/`global` says otherwise.
    print("outer sees (after inner ran):", x)

outer()
print("module sees (after outer ran):", x)

print("\n--- Mutable default argument pitfall ---")
# BUGGY: the default list `[]` is created ONCE, at function definition
# time, and that SAME list object is reused on every call that doesn't
# pass its own `items` argument.
def add_item_buggy(item, items=[]):
    items.append(item)
    return items

print("Buggy version call 1:", add_item_buggy("item"))
print("Buggy version call 2 (should be fresh, but isn't):", add_item_buggy("item"))

# FIXED: default to None (immutable, safe to reuse) and build a fresh
# list inside the function body on every call.
def add_item_fixed(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items

print("Fixed version call 1:", add_item_fixed("item"))
print("Fixed version call 2 (correctly independent):", add_item_fixed("item"))

print("\n--- Closures ---")
# `multiplier` captures `factor` from make_multiplier's scope. Each call
# to make_multiplier creates a DISTINCT closure with its own captured
# factor, even though both closures share the same function body.
def make_multiplier(factor):
    def multiplier(n):
        return n * factor
    return multiplier

double = make_multiplier(2)
triple = make_multiplier(3)
print("double(5) =", double(5))
print("triple(5) =", triple(5))

print("\n--- Recursion ---")
# Base case (n <= 1) stops the recursion; the recursive case always
# calls with a strictly smaller n, guaranteeing the base case is reached.
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)

print("factorial(5) =", factorial(5))
