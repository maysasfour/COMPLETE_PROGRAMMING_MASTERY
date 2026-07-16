"""
Solution 01 - Control Flow
FizzBuzz classify(), the required for-loop version, and the bonus
comprehension version.

Run with:
    python solution-01.py

Expected output:
    1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16 17 Fizz 19 Buzz
    Comprehension result matches loop result: True
"""


def classify(n):
    # Order matters: check "divisible by both" BEFORE checking either
    # alone, otherwise "divisible by 3" would catch 15 first and the
    # FizzBuzz case would never be reached.
    if n % 3 == 0 and n % 5 == 0:
        return "FizzBuzz"
    elif n % 3 == 0:
        return "Fizz"
    elif n % 5 == 0:
        return "Buzz"
    else:
        return str(n)


# `for` is correct here because the sequence (1 through 20) is fully
# known ahead of time - there's no condition to wait on, just a fixed
# range of items to process one by one.
loop_results = []
for n in range(1, 21):
    result = classify(n)
    loop_results.append(result)
print(" ".join(loop_results))

# Bonus: a comprehension is an EXPRESSION that produces the same list
# in one line - preferable when you need the whole collection to use
# later (pass it somewhere, test it) rather than printing immediately.
comprehension_results = [classify(n) for n in range(1, 21)]
print("Comprehension result matches loop result:", comprehension_results == loop_results)
