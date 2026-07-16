"""example.py - currying (transforming a multi-argument function into a chain of
single-argument functions) and partial application (fixing SOME arguments of a function
ahead of time, producing a new function needing only the rest)."""

from functools import partial


def add_three_numbers(a, b, c):
    return a + b + c


# --- Manual currying: a chain of single-argument functions, each returning the next ---
def curry3(func):
    """A generic curry helper: converts any 3-argument function into a curried chain."""
    def curried(a):
        def with_b(b):
            def with_c(c):
                return func(a, b, c)
            return with_c
        return with_b
    return curried


def main():
    print("--- Ordinary multi-argument call ---")
    print(add_three_numbers(1, 2, 3))  # 6

    print("\n--- Currying: calling with ONE argument at a time, each step returns a function ---")
    curried = curry3(add_three_numbers)
    step1 = curried(1)  # a function still WAITING for b
    step2 = step1(2)  # a function still WAITING for c
    result = step2(3)  # NOW it actually computes
    print(result)  # 6
    print(curry3(add_three_numbers)(1)(2)(3))  # the same thing, chained directly

    print("\n--- Partial application: fixing SOME arguments up front with functools.partial ---")

    def greet(greeting, name):
        return f"{greeting}, {name}!"

    say_hello = partial(greet, "Hello")  # "greeting" is FIXED to "Hello"; "name" still required
    print(say_hello("Ada"))
    print(say_hello("Grace"))

    print("\n--- Partial application is genuinely different from currying ---")
    # partial() fixes however many arguments you give it RIGHT NOW and returns a function
    # taking the REST all at once -- it does not force one-argument-at-a-time calling
    # the way a fully curried function does.
    def add_three(a, b, c):
        return a + b + c

    add_5_and_10 = partial(add_three, 5, 10)  # fixes BOTH a AND b in one step
    print(add_5_and_10(3))  # 18 -- only c is still needed, supplied all at once

    print("\n--- A practical use: specializing a generic function for a specific case ---")

    def power(base, exponent):
        return base ** exponent

    square = partial(power, exponent=2)  # specialize power() into a "square" function
    cube = partial(power, exponent=3)
    print(square(5), cube(2))  # 25 8


if __name__ == "__main__":
    main()
