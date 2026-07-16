"""
Solution 01 - Error Handling
A safe config loader using two custom exception types, demonstrating
fail-fast validation whose failure handling is left to the caller.

Run with:
    python solution-01.py

Expected output:
    max_retries = 3
    Missing setting handled: Setting 'timeout' is missing from config
    Type mismatch handled: Setting 'debug' expected bool but got str
"""


class MissingSettingError(Exception):
    # Distinct from SettingTypeError so callers can react differently
    # (e.g., "missing" might mean "use a default", while "wrong type"
    # might mean "the config file itself is corrupt").
    pass


class SettingTypeError(Exception):
    pass


def get_setting(config, key, expected_type):
    # Fail-fast: reject invalid state IMMEDIATELY at the point it's
    # discovered, rather than returning a sentinel value (like None)
    # that the caller might forget to check and use silently downstream.
    if key not in config:
        raise MissingSettingError(f"Setting '{key}' is missing from config")

    value = config[key]
    if not isinstance(value, expected_type):
        raise SettingTypeError(
            f"Setting '{key}' expected {expected_type.__name__} but got {type(value).__name__}"
        )

    return value


# Design answer: get_setting() itself is fail-fast - it never silently
# returns a default or None on invalid input, it raises immediately.
# Whether the OVERALL program is fail-fast or defensive is then up to
# the CALLER: catching the exception and supplying a fallback (as done
# below) is a defensive use of a fail-fast building block. This is the
# recommended pattern from the lesson: fail-fast at the boundary
# (get_setting refuses bad input), defensive at the call site (the
# caller decides how to gracefully recover).

config = {"max_retries": 3, "debug": "yes"}

max_retries = get_setting(config, "max_retries", int)
print("max_retries =", max_retries)

try:
    timeout = get_setting(config, "timeout", int)
except MissingSettingError as error:
    print(f"Missing setting handled: {error}")

try:
    debug = get_setting(config, "debug", bool)
except SettingTypeError as error:
    print(f"Type mismatch handled: {error}")
