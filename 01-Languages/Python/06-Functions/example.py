"""
Lesson 06 - Functions
Demonstrates: positional vs. keyword arguments, implicit None return,
default arguments, the mutable default argument pitfall (broken then fixed),
*args and **kwargs (collecting and unpacking), and docstrings with help().

Run with:
    python example.py

Expected output:
    --- Positional vs keyword arguments ---
    greet("Ada", "Hello") -> Hello, Ada!
    greet(name="Ada", greeting="Hello") -> Hello, Ada!
    greet(greeting="Hello", name="Ada") -> Hello, Ada!

    --- Implicit None return ---
    hi
    log_message("hi") returned: None

    --- Default arguments ---
    power(3) -> 9
    power(3, 3) -> 27

    --- Mutable default argument pitfall (BROKEN) ---
    add_item_broken("apple") -> ['apple']
    add_item_broken("banana") -> ['apple', 'banana']  <- bug: banana call also has apple!

    --- Fixed version ---
    add_item_fixed("apple") -> ['apple']
    add_item_fixed("banana") -> ['banana']

    --- *args and **kwargs ---
    positional: (1, 2, 3)
    keyword: {'name': 'Ada', 'role': 'engineer'}

    --- Unpacking into a call ---
    add(*[1, 2, 3]) -> 6
    add(**{'a': 1, 'b': 2, 'c': 3}) -> 6

    --- Docstrings and help() ---
    celsius_to_fahrenheit.__doc__ -> Convert a Celsius temperature to Fahrenheit.
    celsius_to_fahrenheit(0) -> 32.0
"""

print("--- Positional vs keyword arguments ---")


def greet(name, greeting):
    return f"{greeting}, {name}!"


# All three calls below produce the same result - positional args are
# matched by order, keyword args by name, so reordering keywords is safe.
print(f'greet("Ada", "Hello") -> {greet("Ada", "Hello")}')
print(f'greet(name="Ada", greeting="Hello") -> {greet(name="Ada", greeting="Hello")}')
print(f'greet(greeting="Hello", name="Ada") -> {greet(greeting="Hello", name="Ada")}')

print("\n--- Implicit None return ---")


def log_message(msg):
    print(msg)
    # No return statement - the function implicitly returns None. This is
    # easy to miss because the function still clearly "does something" (prints).


result = log_message("hi")
print(f"log_message(\"hi\") returned: {result}")

print("\n--- Default arguments ---")


def power(base, exponent=2):
    return base ** exponent


print(f"power(3) -> {power(3)}")
print(f"power(3, 3) -> {power(3, 3)}")

print("\n--- Mutable default argument pitfall (BROKEN) ---")


def add_item_broken(item, basket=[]):
    # basket=[] is created ONCE, when this def statement runs - every call
    # that omits `basket` shares that same persistent list object.
    basket.append(item)
    return basket


print(f'add_item_broken("apple") -> {add_item_broken("apple")}')
print(f'add_item_broken("banana") -> {add_item_broken("banana")}  <- bug: banana call also has apple!')

print("\n--- Fixed version ---")


def add_item_fixed(item, basket=None):
    # None is immutable and safe to reuse as a default; the real mutable
    # list is only constructed here, fresh, on calls that need it.
    if basket is None:
        basket = []
    basket.append(item)
    return basket


print(f'add_item_fixed("apple") -> {add_item_fixed("apple")}')
print(f'add_item_fixed("banana") -> {add_item_fixed("banana")}')

print("\n--- *args and **kwargs ---")


def summarize(*args, **kwargs):
    print("positional:", args)
    print("keyword:", kwargs)


summarize(1, 2, 3, name="Ada", role="engineer")

print("\n--- Unpacking into a call ---")


def add(a, b, c):
    return a + b + c


numbers = [1, 2, 3]
# The * here unpacks the list into three separate positional arguments -
# the mirror image of *args collecting them.
print(f"add(*[1, 2, 3]) -> {add(*numbers)}")

values = {"a": 1, "b": 2, "c": 3}
# ** unpacks a dict into keyword arguments, matched to parameters by key.
print(f"add(**{{'a': 1, 'b': 2, 'c': 3}}) -> {add(**values)}")

print("\n--- Docstrings and help() ---")


def celsius_to_fahrenheit(celsius):
    """Convert a Celsius temperature to Fahrenheit.

    Args:
        celsius: temperature in degrees Celsius.

    Returns:
        The equivalent temperature in degrees Fahrenheit.
    """
    return celsius * 9 / 5 + 32


# __doc__ is how tools like help() and IDEs retrieve this text at runtime -
# it's a real attribute on the function object, not a discarded comment.
first_line = celsius_to_fahrenheit.__doc__.strip().splitlines()[0]
print(f"celsius_to_fahrenheit.__doc__ -> {first_line}")
print(f"celsius_to_fahrenheit(0) -> {celsius_to_fahrenheit(0)}")
