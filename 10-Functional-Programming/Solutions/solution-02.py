"""Solution 02 - A Configurable Validator Registry."""

import functools


def min_length(n):
    def validator(value):
        return len(value) >= n
    return validator


def contains_digit():
    def validator(value):
        return any(ch.isdigit() for ch in value)
    return validator


def run_validators(value, validators):
    return all(validator(value) for validator in validators)


def logged(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        result = func(*args, **kwargs)
        arg_repr = args[0] if len(args) == 1 and not kwargs else (args, kwargs)
        print(f"{func.__name__}({arg_repr!r}) -> {result!r}")
        return result
    return wrapper


def main():
    validators = [min_length(8), contains_digit()]

    for candidate in ["short1", "longenough1", "nodigitshere"]:
        print(f"{candidate!r}: {run_validators(candidate, validators)}")

    print("\n--- @logged applied to a returned validator function ---")
    logged_min_length_8 = logged(min_length(8))
    logged_min_length_8("hi")
    logged_min_length_8("longenough")


if __name__ == "__main__":
    main()
