"""example.py - function composition: building complex behavior by combining simple
functions, rather than writing one large function that does everything at once."""

from functools import reduce


def add_one(x):
    return x + 1


def double(x):
    return x * 2


def square(x):
    return x * x


def compose_two(f, g):
    """Returns a new function equivalent to f(g(x))."""
    return lambda x: f(g(x))


def compose(*functions):
    """Compose any number of functions, applied RIGHT TO LEFT (mathematical convention:
    compose(f, g, h)(x) == f(g(h(x)))."""
    return reduce(compose_two, functions)


def pipe(*functions):
    """Like compose, but applied LEFT TO RIGHT -- often considered more readable since it
    reads in the same order the operations are actually applied."""
    return reduce(compose_two, reversed(functions))


def main():
    print("--- compose_two: combining exactly two functions ---")
    add_then_double = compose_two(double, add_one)  # double(add_one(x))
    print(add_then_double(3))  # double(add_one(3)) = double(4) = 8

    print("\n--- compose(): combining ANY number of functions, right-to-left ---")
    pipeline = compose(square, double, add_one)  # square(double(add_one(x)))
    print(pipeline(3))  # add_one(3)=4, double(4)=8, square(8)=64

    print("\n--- pipe(): the same idea, but left-to-right (often more readable) ---")
    pipeline_readable = pipe(add_one, double, square)  # same operations, same order as written
    print(pipeline_readable(3))  # identical result: 64

    print("\n--- A practical example: a text-processing pipeline ---")

    def strip_whitespace(s):
        return s.strip()

    def to_lowercase(s):
        return s.lower()

    def remove_punctuation(s):
        return "".join(c for c in s if c.isalnum() or c.isspace())

    clean_text = pipe(strip_whitespace, to_lowercase, remove_punctuation)
    print(repr(clean_text("  Hello, World!!  ")))

    print("\n--- Why composition matters: each piece is independently testable ---")
    # strip_whitespace, to_lowercase, and remove_punctuation can each be tested in
    # isolation with trivial inputs/outputs -- the composed pipeline is then just
    # "do these, in this order," with no new logic of its own to get wrong.
    assert strip_whitespace("  x  ") == "x"
    assert to_lowercase("X") == "x"
    assert remove_punctuation("a,b!") == "ab"
    print("all individual pipeline steps verified independently")


if __name__ == "__main__":
    main()
