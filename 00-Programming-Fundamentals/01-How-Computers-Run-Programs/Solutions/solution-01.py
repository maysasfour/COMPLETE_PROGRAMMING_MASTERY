"""
Solution 01 - How Computers Run Programs
Bonus part of exercise-01: rewrite the imperative even-number filter
in functional style, and prove both versions produce the same result.

Run with:
    python solution-01.py

Expected output:
    Imperative result: [0, 2, 4, 6, 8]
    Functional result: [0, 2, 4, 6, 8]
    Results match: True
"""

# Imperative version (this is Snippet C from the exercise, reproduced
# so the comparison below is self-contained and runnable on its own).
result_imperative = []
for n in range(10):
    if n % 2 == 0:
        result_imperative.append(n)

# Functional rewrite: filter() expresses "keep values matching this
# predicate" as a single expression instead of a loop + conditional +
# mutable accumulator list built up step by step.
result_functional = list(filter(lambda n: n % 2 == 0, range(10)))

print(f"Imperative result: {result_imperative}")
print(f"Functional result: {result_functional}")
print(f"Results match: {result_imperative == result_functional}")
