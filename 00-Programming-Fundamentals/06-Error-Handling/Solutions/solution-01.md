# Solution 01 — A Safe Config Loader

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Full runnable code is in `solution-01.py`. Verified output:

```
max_retries = 3
Missing setting handled: Setting 'timeout' is missing from config
Type mismatch handled: Setting 'debug' expected bool but got str
```

## Walkthrough

```python
class MissingSettingError(Exception):
    pass

class SettingTypeError(Exception):
    pass

def get_setting(config, key, expected_type):
    if key not in config:
        raise MissingSettingError(f"Setting '{key}' is missing from config")
    value = config[key]
    if not isinstance(value, expected_type):
        raise SettingTypeError(
            f"Setting '{key}' expected {expected_type.__name__} but got {type(value).__name__}"
        )
    return value
```

Two separate exception classes (rather than one generic one) let callers distinguish "the setting doesn't exist" from "the setting exists but is the wrong type" — these usually call for different recovery strategies (fall back to a default vs. treat the config file as corrupt and refuse to start).

## Design Question Answer

`get_setting()` itself is **fail-fast**: it never returns a sentinel like `None` or a default value on invalid input — it raises immediately at the point the problem is detected, refusing to let bad config data travel further into the program disguised as a valid value.

Whether the *program as a whole* behaves defensively is then entirely up to the **caller**. In the demonstration, wrapping the `timeout` and `debug` lookups in `try/except` and printing a friendly message *is* a defensive use of a fail-fast building block — the caller chooses to recover gracefully rather than let the exception propagate and crash the program. This is exactly the pattern the lesson recommends: fail-fast at the boundary (inside `get_setting`, which refuses to hand back bad data silently) and defensive at the call site (the caller decides what "gracefully handle this" means for their specific situation — retry, use a default, log and continue, or let it crash).

## Common Pitfalls

- Using a single generic `Exception` (or reusing a built-in like `ValueError` for both cases) instead of two distinct custom classes — this forces callers to inspect the error message string to figure out what actually went wrong, which is fragile.
- Making `get_setting` itself "defensive" by returning `None` on a missing key instead of raising — this pushes the bug discovery further downstream, to wherever `None` eventually gets used in a way that assumes a real value, which is much harder to trace back to the actual missing config key.
- Catching `Exception` broadly around the `get_setting` calls instead of the specific custom exception types — this would also swallow genuine bugs elsewhere in the same try block, the same bare-except problem covered in the lesson.
