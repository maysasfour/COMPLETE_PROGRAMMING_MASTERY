"""example.py - higher-order functions: functions that take other functions as arguments,
or return functions, treating functions as first-class values."""

import time


# --- Functions are first-class values: assign them, pass them, store them in collections ---
def shout(text):
    return text.upper() + "!"


def whisper(text):
    return text.lower() + "..."


def main():
    print("--- Functions as first-class values ---")
    greeting_style = shout  # no () -- we're referencing the FUNCTION ITSELF, not calling it
    print(greeting_style("hello"))
    greeting_style = whisper
    print(greeting_style("hello"))

    print("\n--- Passing a function AS AN ARGUMENT ---")

    def apply_twice(func, value):
        return func(func(value))  # func is a PARAMETER holding a function

    print(apply_twice(shout, "hi"))  # shout(shout("hi"))

    print("\n--- Built-in higher-order functions: sorted() with a key function ---")
    words = ["banana", "kiwi", "apple", "fig"]
    print(sorted(words))  # default: alphabetical
    print(sorted(words, key=len))  # key=len -- passes the len FUNCTION, sorts by its result

    print("\n--- Returning a function: a function FACTORY ---")

    def make_multiplier(factor):
        def multiplier(x):
            return x * factor  # `factor` is captured from the enclosing scope -- a CLOSURE
        return multiplier  # returns the FUNCTION itself, not a call to it

    double = make_multiplier(2)
    triple = make_multiplier(3)
    print(double(5), triple(5))  # 10 15 -- each remembers its OWN factor

    print("\n--- Decorators: a higher-order function that WRAPS another function ---")

    def timed(func):
        def wrapper(*args, **kwargs):
            start = time.perf_counter()
            result = func(*args, **kwargs)
            elapsed = time.perf_counter() - start
            print(f"  {func.__name__} took {elapsed:.6f}s")
            return result
        return wrapper

    @timed  # sugar for: slow_sum = timed(slow_sum)
    def slow_sum(n):
        return sum(range(n))

    print(slow_sum(1_000_000))


if __name__ == "__main__":
    main()
