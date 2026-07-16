"""example.py - map, filter, reduce: the classic functional trio for transforming,
selecting, and aggregating collections, plus Python's idiomatic comprehension alternatives."""

from functools import reduce


def main():
    numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    print("--- map(): transform EVERY element ---")
    doubled = map(lambda n: n * 2, numbers)  # map() returns a LAZY iterator, not a list
    print(list(doubled))  # must materialize it to see the values
    doubled_comprehension = [n * 2 for n in numbers]  # the more idiomatic Python equivalent
    print(doubled_comprehension)

    print("\n--- filter(): SELECT elements matching a predicate ---")
    evens = filter(lambda n: n % 2 == 0, numbers)
    print(list(evens))
    evens_comprehension = [n for n in numbers if n % 2 == 0]
    print(evens_comprehension)

    print("\n--- reduce(): AGGREGATE a collection down to a single value ---")
    total = reduce(lambda acc, n: acc + n, numbers, 0)  # 0 is the initial accumulator value
    print(total)
    product = reduce(lambda acc, n: acc * n, numbers, 1)
    print(product)
    # Python's built-in sum()/max()/min() cover the most common reduce cases directly:
    print(sum(numbers), max(numbers), min(numbers))

    print("\n--- Chaining map/filter/reduce together ---")
    # sum of the squares of the even numbers
    result = reduce(
        lambda acc, n: acc + n,
        map(lambda n: n * n, filter(lambda n: n % 2 == 0, numbers)),
        0,
    )
    print(result)
    # the equivalent, more Pythonic version using a single comprehension + sum():
    result_pythonic = sum(n * n for n in numbers if n % 2 == 0)
    print(result_pythonic)

    print("\n--- map()/filter() are LAZY -- verified live: they don't run until consumed ---")
    call_log = []

    def logged_square(n):
        call_log.append(n)
        return n * n

    lazy_map = map(logged_square, numbers)  # NOTHING has run yet
    print(f"call_log immediately after map(): {call_log}")  # []  -- empty! map() didn't execute anything
    first_value = next(lazy_map)  # NOW logged_square(1) actually runs
    print(f"call_log after consuming one value: {call_log}")  # [1]


if __name__ == "__main__":
    main()
