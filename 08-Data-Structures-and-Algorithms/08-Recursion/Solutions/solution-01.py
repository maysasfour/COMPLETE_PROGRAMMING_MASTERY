"""
Solution 01 - Recursive Sum of Digits

Run with:
    python solution-01.py
"""


def sum_of_digits(n):
    """Recursively sums the digits of a non-negative integer.

    Base case: n < 10 means n IS a single digit already - return it
    directly, no further recursion needed.
    Recursive case: split off the last digit (n % 10) and add it to
    the recursive sum of whatever remains after removing that digit
    (n // 10) - each recursive call strictly shrinks the number of
    digits by one, which is what guarantees the base case is reached.
    """
    if n < 10:
        return n
    return (n % 10) + sum_of_digits(n // 10)


def main():
    for n in [0, 7, 123, 9999]:
        print(f"sum_of_digits({n}) -> {sum_of_digits(n)}")


if __name__ == "__main__":
    main()
