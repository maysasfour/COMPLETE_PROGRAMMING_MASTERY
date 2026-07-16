# Exercise 01 — A Safe Config Loader

[Back to lesson](../README.md)

## Task

Write a function `get_setting(config, key, expected_type)` that:

1. Looks up `key` in the `config` dictionary.
2. Raises a **custom exception** `MissingSettingError` (subclassing `Exception`) with a clear message if `key` is not present.
3. Raises a **custom exception** `SettingTypeError` (subclassing `Exception`) with a clear message if the value's type does not match `expected_type`.
4. Returns the value if both checks pass.

Then write code that calls `get_setting` three times against this config:

```python
config = {"max_retries": 3, "debug": "yes"}
```

- `get_setting(config, "max_retries", int)` — should succeed.
- `get_setting(config, "timeout", int)` — should raise `MissingSettingError`; catch it and print a friendly message.
- `get_setting(config, "debug", bool)` — should raise `SettingTypeError` (the value is a string, not a bool); catch it and print a friendly message.

## Design Question (answer in a comment)

Is this function fail-fast or defensive, or does it do both depending on the caller? Justify your answer using the lesson's definitions — specifically, think about whether `get_setting` itself decides what happens on failure, or whether it leaves that decision to the caller.

## Deliverable

A `.py` file with both custom exception classes, `get_setting`, and the three demonstrated calls with their results printed. Attempt this before checking `Solutions/solution-01.py`.
