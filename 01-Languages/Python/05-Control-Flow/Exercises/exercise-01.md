# Exercise 01 — Build a Password Strength Checker

[Back to lesson](../README.md)

## Task

Write a program that checks a list of candidate passwords against a set of rules and reports each one's result, using at least **three** control-flow concepts from the lesson: a `for` loop, the loop's `else` clause, and `break`/`continue`.

Build a function `check_password(password)` that returns a string outcome:

1. If the password is shorter than 8 characters, it's `"too short"`.
2. Otherwise, scan its characters. If it contains **no digit at all**, it's `"needs a digit"`.
3. If it passes both checks, it's `"ok"`.

Requirements for the character scan in step 2:
- Loop over the password's characters with a plain `for` loop.
- Use `break` as soon as you find a digit (no need to keep scanning).
- Use the loop's `else` clause to detect "the loop finished and never found a digit" — this is exactly the "search, else not-found" pattern from the lesson. Do not use a manual `found = False` flag.

Then write a `match` statement–based function `describe_outcome(outcome)` that takes the string returned by `check_password` and returns a longer human-readable message, using an OR pattern (`|`) to group at least two related outcomes into one message if you can find a sensible grouping, and a wildcard `_` fallback.

Run your program against this list and print each password with its outcome and description:

```python
candidates = ["abc", "abcdefgh", "abcd1234", "password123"]
```

## Reflection Questions

1. Why does using the loop's `else` clause here avoid the need for a separate boolean flag variable? Walk through what would happen if you used `break` without any `else` at all.
2. What would happen to your `describe_outcome` function if you removed the `case _:` wildcard and then called it with an outcome string it didn't recognize?
3. Suppose you needed to add a rule "must not contain spaces." Would you add it as a new `if` before the digit-scanning loop, or inside the loop? Justify your answer in terms of short-circuiting the "too short" check first.

## Deliverable

A working Python script (or notes plus pseudocode if you're doing this on paper first) implementing both functions, run against the given `candidates` list, plus written answers to the three reflection questions. Do not peek at `Solutions/solution-01.py` until you've attempted your own version.
