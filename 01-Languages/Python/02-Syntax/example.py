"""
Lesson 02 - Syntax
Demonstrates: indentation-defined blocks, statements vs expressions,
the walrus operator, and pass as an explicit no-op.

Run with:
    python example.py

Expected output:
    --- Indentation defines blocks ---
    x is positive
    this line is still inside the if-block
    this line runs unconditionally, after the if-block ended

    --- Statement vs expression ---
    5 + 3 is an expression -> 8
    'x = 5 + 3' is a statement - it has no value itself

    --- Walrus operator: assign inside an expression ---
    Without walrus, len(data) is computed twice: 3 and 3
    With walrus, len(data) is computed once and reused: 3

    --- pass as an explicit no-op ---
    reached the branch that intentionally does nothing yet
    continued after the empty branch
"""

print("--- Indentation defines blocks ---")
x = 5
if x > 0:
    # Both of these lines belong to the if-block purely because they
    # share the same indentation level - there is no closing brace.
    print("x is positive")
    print("this line is still inside the if-block")
print("this line runs unconditionally, after the if-block ended")

print("\n--- Statement vs expression ---")
# "5 + 3" is an expression: it evaluates to a value we can capture.
result = 5 + 3
print(f"5 + 3 is an expression -> {result}")
# The assignment itself ("x = 5 + 3") is a STATEMENT - you cannot use
# it as a value (e.g. you can't write `print(x = 5 + 3)` expecting 8).
print("'x = 5 + 3' is a statement - it has no value itself")

print("\n--- Walrus operator: assign inside an expression ---")
data = [1, 2, 3]
# Without walrus: len(data) is called twice if you want to both check
# and use the value - wasteful if computing the value were expensive.
if len(data) > 0:
    print(f"Without walrus, len(data) is computed twice: {len(data)} and {len(data)}")

# With walrus: compute once, bind to n, and use n inside the block -
# useful anywhere you'd otherwise repeat a computation in the condition and body.
if (n := len(data)) > 0:
    print(f"With walrus, len(data) is computed once and reused: {n}")

print("\n--- pass as an explicit no-op ---")
status = "pending"
if status == "pending":
    # pass documents "this branch is intentionally empty (for now)" instead
    # of leaving the block syntactically invalid or silently missing logic.
    pass
print("reached the branch that intentionally does nothing yet")
print("continued after the empty branch")
