"""
Solution 01 - Evaluate Reverse Polish Notation

Run with:
    python solution-01.py
"""

import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from implementation import Stack  # noqa: E402


def evaluate_rpn(tokens):
    """Evaluates a Reverse Polish Notation expression using a Stack.

    Numbers get pushed as we see them. An operator always applies to the
    two most recently seen (and not-yet-consumed) values - which is
    exactly what a stack's LIFO order gives us for free, without needing
    to track operator precedence or parentheses at all.
    """
    stack = Stack()
    operators = {"+", "-", "*", "/"}

    for token in tokens:
        if token in operators:
            # The RIGHT operand was pushed most recently, so it's popped
            # FIRST. Getting this backward silently flips subtraction and
            # division results - see solution-01.md's reflection answer.
            right = stack.pop()
            left = stack.pop()
            if token == "+":
                result = left + right
            elif token == "-":
                result = left - right
            elif token == "*":
                result = left * right
            else:  # token == "/"
                result = left // right
            stack.push(result)
        else:
            stack.push(int(token))

    return stack.pop()


def main():
    test_cases = [
        (["2", "3", "+"], 5),
        (["4", "13", "5", "/", "+"], 6),
        (["10", "2", "8", "*", "-"], -6),
    ]
    for tokens, expected in test_cases:
        result = evaluate_rpn(tokens)
        print(f"evaluate_rpn({tokens}) -> {result}  (expected {expected}, match: {result == expected})")


if __name__ == "__main__":
    main()
