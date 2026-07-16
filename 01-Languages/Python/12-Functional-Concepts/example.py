"""
Lesson 12 - Functional Concepts
Demonstrates: lambda expressions, map()/filter() vs comprehensions,
functools.reduce, functions as first-class objects (closures/factories),
and a logging/timing decorator built with functools.wraps.

Run with:
    python example.py

Expected output:
    --- Lambda ---
    square(5) = 25
    add(2, 3) = 5

    --- map() / filter() vs comprehensions ---
    doubled (map)          = [2, 4, 6, 8, 10]
    doubled (comprehension) = [2, 4, 6, 8, 10]
    evens (filter)          = [2, 4]
    evens (comprehension)   = [2, 4]

    --- functools.reduce ---
    sum via reduce = 15
    sum via builtin = 15
    product via reduce = 120

    --- Functions as first-class objects ---
    strategies["shout"]("hello") = HELLO!
    apply_twice(shout, "hi") = HI!!
    triple(7) = 21

    --- Decorator with functools.wraps ---
    slow_add.__name__ = slow_add
    slow_add.__doc__  = Add two numbers (with a tiny simulated delay).
    slow_add(2, 3) took >= 0.01s: True
    slow_add(2, 3) = 5
"""

import functools
import time


print("--- Lambda ---")
# A lambda is fine here because it's a single expression with no need for a
# name of its own - assigning it to a variable is just for this demo.
square = lambda x: x ** 2
add = lambda a, b: a + b
print(f"square(5) = {square(5)}")
print(f"add(2, 3) = {add(2, 3)}")

print("\n--- map() / filter() vs comprehensions ---")
numbers = [1, 2, 3, 4, 5]

# map()/filter() return lazy iterators, so they need list() to materialize -
# that extra wrapping is exactly why comprehensions usually read better.
doubled_map = list(map(lambda n: n * 2, numbers))
doubled_comp = [n * 2 for n in numbers]
evens_filter = list(filter(lambda n: n % 2 == 0, numbers))
evens_comp = [n for n in numbers if n % 2 == 0]
print(f"doubled (map)          = {doubled_map}")
print(f"doubled (comprehension) = {doubled_comp}")
print(f"evens (filter)          = {evens_filter}")
print(f"evens (comprehension)   = {evens_comp}")

print("\n--- functools.reduce ---")
# reduce is shown here for teaching purposes, but sum() already solves the
# accumulation case more readably - that's why reduce isn't a builtin anymore.
total_reduce = functools.reduce(lambda acc, n: acc + n, numbers, 0)
total_builtin = sum(numbers)
product = functools.reduce(lambda acc, n: acc * n, numbers, 1)
print(f"sum via reduce = {total_reduce}")
print(f"sum via builtin = {total_builtin}")
print(f"product via reduce = {product}")

print("\n--- Functions as first-class objects ---")


def shout(text):
    return text.upper() + "!"


def whisper(text):
    return text.lower() + "..."


# Storing functions as dict values replaces a chain of if/elif with a lookup -
# a common way to implement a "strategy" or "dispatch table" pattern.
strategies = {"shout": shout, "whisper": whisper}
print(f'strategies["shout"]("hello") = {strategies["shout"]("hello")}')


def apply_twice(func, value):
    # func is just a value here - it was passed in like any other argument.
    return func(func(value))


print(f'apply_twice(shout, "hi") = {apply_twice(shout, "hi")}')


def make_multiplier(factor):
    # multiplier is a closure: it keeps a reference to "factor" from this
    # enclosing scope even after make_multiplier itself has already returned.
    def multiplier(x):
        return x * factor
    return multiplier


triple = make_multiplier(3)
print(f"triple(7) = {triple(7)}")

print("\n--- Decorator with functools.wraps ---")


def timed(func):
    # @functools.wraps(func) copies func's __name__/__doc__/__module__ onto
    # wrapper - without it, every decorated function would masquerade as
    # a function literally named "wrapper" with no docstring.
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - start
        # Stashing the elapsed time on the wrapper lets the caller verify
        # timing behavior deterministically instead of parsing printed text.
        wrapper.last_elapsed = elapsed
        return result
    wrapper.last_elapsed = None
    return wrapper


@timed
def slow_add(a, b):
    """Add two numbers (with a tiny simulated delay)."""
    time.sleep(0.01)
    return a + b


# These prove functools.wraps did its job - without it, both would be wrong.
print(f"slow_add.__name__ = {slow_add.__name__}")
print(f"slow_add.__doc__  = {slow_add.__doc__}")

result = slow_add(2, 3)
# Only assert the *lower bound* of elapsed time - actual wall-clock timing
# is inherently variable, but "at least the sleep duration" always holds.
print(f"slow_add(2, 3) took >= 0.01s: {slow_add.last_elapsed >= 0.01}")
print(f"slow_add(2, 3) = {result}")
