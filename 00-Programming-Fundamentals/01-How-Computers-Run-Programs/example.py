"""
Lesson 01 - How Computers Run Programs
Demonstrates: compile-then-interpret pipeline (visible via __pycache__),
and the four programming paradigms solving the identical problem
(summing a shopping cart) so they can be compared directly.

Run with:
    python example.py

Expected output:
    --- Proof Python compiles before it interprets ---
    Compiled bytecode cache exists after import: True

    --- Same task, four paradigms ---
    Imperative total : 60
    OOP total        : 60
    Functional total  : 60
    Declarative-style total (via a rule table): 60
"""

import importlib
import sys
from functools import reduce

print("--- Proof Python compiles before it interprets ---")

# We import a throwaway helper module purely to force CPython to compile it.
# CPython caches compiled bytecode as .pyc files under __pycache__ so that
# the NEXT import skips re-compiling unchanged source - this cache is the
# concrete, on-disk evidence that "interpreted" Python still has a compile
# step before the interpreter ever touches it.
import _bytecode_proof_helper  # noqa: F401  (module lives next to this file)

cache_dir = sys.modules["_bytecode_proof_helper"].__cached__
import os
print(f"Compiled bytecode cache exists after import: {os.path.exists(cache_dir)}")

prices = [10, 20, 30]

print("\n--- Same task, four paradigms ---")

# IMPERATIVE: we spell out each step that mutates a running total.
# The "how" (loop, accumulate) is fully explicit in the code.
total_imperative = 0
for price in prices:
    total_imperative += price
print(f"Imperative total : {total_imperative}")


# OBJECT-ORIENTED: state (self.items) and the behavior that acts on it
# (add, total) are bundled together in one unit instead of living as
# loose variables and free-floating functions.
class ShoppingCart:
    def __init__(self):
        self.items = []

    def add(self, price):
        self.items.append(price)

    def total(self):
        return sum(self.items)


cart = ShoppingCart()
for price in prices:
    cart.add(price)
print(f"OOP total        : {cart.total()}")


# FUNCTIONAL: reduce() expresses "combine these values with this rule"
# without a mutable accumulator variable owned by the surrounding scope -
# the accumulation is an argument that flows through, not a variable we edit.
total_functional = reduce(lambda accumulated, price: accumulated + price, prices, 0)
print(f"Functional total  : {total_functional}")


# DECLARATIVE (illustrative, since Python has no built-in query language):
# we state WHAT we want ("the sum, according to this rule") via a data
# structure, and a tiny generic engine decides HOW to apply it. This is
# the same shape as "SELECT SUM(price) FROM cart" - the caller never
# writes the loop themselves.
def apply_aggregation_rule(values, rule):
    # `rule` describes the desired aggregation; this engine is the "how".
    if rule == "sum":
        return sum(values)
    raise ValueError(f"Unsupported rule: {rule}")


total_declarative = apply_aggregation_rule(prices, rule="sum")
print(f"Declarative-style total (via a rule table): {total_declarative}")
