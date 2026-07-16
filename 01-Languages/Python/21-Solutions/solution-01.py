"""
Solution 01 - FizzBuzz Variant
See: ../20-Exercises/README.md#exercise-01--fizzbuzz-variant-beginner

Run with:
    python solution-01.py

Expected output:
    ['1', '2', 'Fizz', '4', 'Buzz', 'Fizz', '7', '8', 'Fizz', 'Buzz', '11', 'Fizz', '13', '14', 'FizzBuzz']
"""


def fizzbuzz(n: int) -> list[str]:
    result = []
    for i in range(1, n + 1):
        # Check "both" first - checking 3 or 5 individually first would
        # never let a multiple of 15 reach the combined "FizzBuzz" case.
        if i % 15 == 0:
            result.append("FizzBuzz")
        elif i % 3 == 0:
            result.append("Fizz")
        elif i % 5 == 0:
            result.append("Buzz")
        else:
            result.append(str(i))
    return result


if __name__ == "__main__":
    print(fizzbuzz(15))
