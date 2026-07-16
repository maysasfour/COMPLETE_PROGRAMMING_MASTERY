# Solution 01 — Build a Password Strength Checker

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
abc                  -> too short       | Too short: needs at least 8 characters.
abcdefgh             -> needs a digit   | Missing a digit or otherwise weak: add at least one number.
abcd1234             -> ok              | Looks good: meets the length and digit requirements.
password123          -> ok              | Looks good: meets the length and digit requirements.
```

## Explanation

`check_password` first checks length with a plain `if` — this is the cheapest possible check, so it runs before doing any character-by-character work. If the password clears that bar, a `for` loop scans each character looking for a digit:

```python
for char in password:
    if char.isdigit():
        break
else:
    return "needs a digit"
```

As soon as a digit is found, `break` exits the loop immediately — there's no need to keep scanning once the requirement is satisfied. The `else` clause is the key piece: it only executes if the loop ran through **every** character without ever hitting `break`, which is precisely the condition "no digit exists anywhere in this password." If a digit was found and `break` fired, control jumps past `else` straight to the final `return "ok"`.

`describe_outcome` uses `match` to turn the short outcome string into a full sentence, with `case "needs a digit" | "missing digit":` demonstrating the OR pattern (grouping two spellings of the same underlying idea into a single arm), and `case _:` as a safety net for any outcome string the function doesn't recognize.

## Reflection Answers

1. Using `else` avoids a manual flag because the loop construct itself already encodes "did we exit early or not" — `break` vs. falling off the end. A hand-rolled version would need `found_digit = False`, then `found_digit = True; break` inside the loop, then `if not found_digit:` afterward — three extra moving parts that `for/else` collapses into the loop's natural control flow. Without any `else` at all, you'd have no way to distinguish "loop ended because it finished" from "loop ended because it broke" except by re-testing some condition after the loop, which is exactly the boolean flag you were trying to avoid.

2. Without `case _:`, calling `describe_outcome` with an unrecognized string simply falls through the `match` statement doing nothing — the function would then hit its implicit end and return `None`, rather than raising an error or returning a helpful message. This is a classic silent-failure trap: no exception, no crash, just a quietly wrong `None` propagating downstream.

3. The "no spaces" rule belongs in the character-scanning loop, not as a separate `if` before it, because it needs to inspect the same characters the digit check already inspects — folding it into one pass avoids scanning the password twice. It should still come *after* the length check, though, since the length check is a fast, one-line early exit that make senses to run before doing any per-character work at all — there's no point checking for spaces in a password that's already disqualified for being too short.

## Common Pitfalls

- Adding a manual `found = False` / `found = True` flag out of habit, not realizing the loop's `else` clause already expresses that exact idea more directly.
- Forgetting that `break` must be inside the loop body's `if`, not the `else` — putting `break` in `else` is a syntax/logic error since `else` only runs when the loop *didn't* break.
- Leaving out `case _:` in `describe_outcome` and being confused when an unexpected password status silently returns `None` instead of erroring loudly.
