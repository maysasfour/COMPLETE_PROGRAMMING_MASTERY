"""
Solution 01 - Control Flow: Password Strength Checker
Runnable version covering check_password() (for + break + loop-else) and
describe_outcome() (match with an OR pattern and a wildcard).

Run with:
    python solution-01.py

Expected output:
    abc                  -> too short       | Too short: needs at least 8 characters.
    abcdefgh             -> needs a digit   | Missing a digit or otherwise weak: add at least one number.
    abcd1234             -> ok              | Looks good: meets the length and digit requirements.
    password123          -> ok              | Looks good: meets the length and digit requirements.
"""


def check_password(password):
    # Short-circuit the cheap check first - no point scanning characters
    # for a digit if the password already fails on length alone.
    if len(password) < 8:
        return "too short"

    for char in password:
        if char.isdigit():
            break  # found one digit - that's all we need, stop scanning
    else:
        # Only reached if the loop above completed WITHOUT hitting break,
        # i.e. not a single character in the password was a digit.
        return "needs a digit"

    return "ok"


def describe_outcome(outcome):
    # "too short" and "needs a digit" are both "still weak" outcomes,
    # but they're kept as separate match arms here so each gets its own
    # precise message; the OR pattern groups two truly interchangeable
    # phrasings for the same underlying "not ok yet" case below instead.
    match outcome:
        case "too short":
            return "Too short: needs at least 8 characters."
        case "needs a digit" | "missing digit":
            return "Missing a digit or otherwise weak: add at least one number."
        case "ok":
            return "Looks good: meets the length and digit requirements."
        case _:
            return "Unrecognized outcome - unable to describe it."


candidates = ["abc", "abcdefgh", "abcd1234", "password123"]

for candidate in candidates:
    outcome = check_password(candidate)
    description = describe_outcome(outcome)
    print(f"{candidate:<20} -> {outcome:<15} | {description}")
