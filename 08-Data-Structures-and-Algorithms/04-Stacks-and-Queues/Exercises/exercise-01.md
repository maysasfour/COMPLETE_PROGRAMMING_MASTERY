# Exercise 01 — Evaluate Reverse Polish Notation

[Back to lesson](../README.md)

## Task

Using the `Stack` class from `implementation.py`, write a function `evaluate_rpn(tokens)` that evaluates an expression written in **Reverse Polish Notation** (postfix notation), where operators come after their operands.

```python
evaluate_rpn(["2", "3", "+"])              # -> 5   (2 + 3)
evaluate_rpn(["4", "13", "5", "/", "+"])   # -> 6   (13 / 5 = 2 (integer division), then 4 + 2 = 6)
evaluate_rpn(["10", "2", "8", "*", "-"])   # -> -6  (2 * 8 = 16, then 10 - 16 = -6)
```

Support `+`, `-`, `*`, `/` (use integer division `//` for `/`). Assume the input is always a valid, fully-formed RPN expression (no error handling required for malformed input).

Hint: push numbers onto the stack. When you hit an operator, pop the top two values (the second-popped is the LEFT operand, the first-popped is the RIGHT operand — order matters for `-` and `/`), apply the operator, and push the result back.

## Reflection Questions

1. Why must the second value popped be treated as the left operand rather than the first? Trace `["10", "2", "8", "*", "-"]` by hand and show what goes wrong if you get the order backward.
2. What is the time complexity of your solution in terms of the number of tokens, and why?
3. RPN never needs parentheses to disambiguate order of operations, unlike the infix notation (`2 + 3 * 4`) most people write by hand. Why does the stack-based evaluation process make parentheses unnecessary?

## Deliverable

A working `evaluate_rpn` function tested against the three examples above, plus answers to the three reflection questions.
