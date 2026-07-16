# Solution 01 — Evaluate Reverse Polish Notation

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
evaluate_rpn(['2', '3', '+']) -> 5  (expected 5, match: True)
evaluate_rpn(['4', '13', '5', '/', '+']) -> 6  (expected 6, match: True)
evaluate_rpn(['10', '2', '8', '*', '-']) -> -6  (expected -6, match: True)
```

## Explanation

Numbers are pushed onto the stack as they're encountered. Every time an operator is seen, the two most recently pushed values are popped and combined, and the result is pushed back — so the stack always holds exactly the partial results still waiting to be combined.

## Reflection Answers

1. **Why the second-popped value is the left operand.** Trace `["10", "2", "8", "*", "-"]`:
   - Push `10` → stack: `[10]`
   - Push `2` → stack: `[10, 2]`
   - Push `8` → stack: `[10, 2, 8]`
   - See `*`: `right = pop() = 8`, `left = pop() = 2` → stack: `[10]`. Compute `2 * 8 = 16`, push → stack: `[10, 16]`
   - See `-`: `right = pop() = 16`, `left = pop() = 10` → stack: `[]`. Compute `10 - 16 = -6`, push → stack: `[-6]`
   - Result: `-6` ✓, matching the expected output.

   If the order were reversed (treating the *first*-popped value as `left`), the final subtraction would compute `16 - 10 = 6` instead of `10 - 16 = -6` — silently wrong, and the kind of bug that only shows up on non-commutative operators (`-` and `/`), never on `+` or `*`, which makes it easy to miss if you only test with addition.

2. **Complexity.** O(n) where n is the number of tokens. Each token is pushed exactly once and popped at most a constant number of times (twice, for an operator) — no token is ever revisited, so total work scales linearly with the input length.

3. **Why RPN needs no parentheses.** In infix notation (`2 + 3 * 4`), parentheses (or precedence rules) are needed to say *which* operation happens first, because the operators and operands are interleaved ambiguously. In RPN, the **position of each operator relative to the stack's current contents** already encodes the order of evaluation — an operator always applies to exactly the two values that were most recently completed and not yet consumed, which uniquely determines execution order without any extra symbols. This is precisely why calculators and low-level expression evaluators often convert to RPN internally before evaluating.

## Common Pitfalls

- Popping the two operands in the wrong order for `-` and `/`, which produces a plausible-looking but wrong answer (see reflection question 1) — this bug is invisible if your test suite only covers commutative operators.
- Using true division (`/`) instead of integer division (`//`) for the `/` token, producing `2.6` instead of `2` for `13 / 5` and cascading into a wrong final answer.
- Forgetting that the final answer is whatever's left on the stack after all tokens are processed — for a valid RPN expression this is always exactly one value, so `stack.pop()` at the end (not `stack.peek()`) is correct and complete.
