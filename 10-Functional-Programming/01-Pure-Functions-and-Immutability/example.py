"""example.py - pure functions vs. impure functions, and immutability."""

# --- Impure: depends on / mutates state OUTSIDE its own parameters ---
total = 0


def add_to_total_impure(amount):
    global total
    total += amount  # SIDE EFFECT: mutates state outside the function itself
    return total


# --- Pure: same inputs ALWAYS produce the same output, no side effects at all ---
def add(a, b):
    return a + b  # depends ONLY on its arguments, changes NOTHING outside itself


def append_impure(items, value):
    items.append(value)  # SIDE EFFECT: mutates the CALLER's list
    return items


def append_pure(items, value):
    return items + [value]  # returns a NEW list; the caller's original is untouched


def main():
    print("--- Impure function: depends on and mutates external state ---")
    print(add_to_total_impure(5))  # 5
    print(add_to_total_impure(5))  # 10 -- SAME argument, DIFFERENT result! Not pure.

    print("\n--- Pure function: same input, same output, always ---")
    print(add(2, 3))  # 5
    print(add(2, 3))  # 5 -- always 5, no matter how many times or when it's called

    print("\n--- Impure vs pure list handling ---")
    original = [1, 2, 3]
    mutated = append_impure(original, 4)
    print(f"original after append_impure: {original}")  # [1, 2, 3, 4] -- caller's list CHANGED!

    original2 = [1, 2, 3]
    new_list = append_pure(original2, 4)
    print(f"original2 after append_pure: {original2}")  # [1, 2, 3] -- UNCHANGED
    print(f"new_list: {new_list}")  # [1, 2, 3, 4] -- a genuinely separate list

    print("\n--- Immutable tuples vs mutable lists ---")
    point = (1, 2)  # tuple: immutable
    try:
        point[0] = 99
    except TypeError as e:
        print(f"caught: {e}")

    coords = [1, 2]  # list: mutable
    coords[0] = 99
    print(f"coords after mutation: {coords}")

    print("\n--- Why purity matters for memoization/caching ---")
    from functools import lru_cache

    call_count = 0

    @lru_cache
    def slow_square(n):
        nonlocal call_count
        call_count += 1
        return n * n

    slow_square(4)
    slow_square(4)  # cached -- the function body does NOT run again
    print(f"slow_square called {call_count} time(s) for two identical calls")
    # Caching is only SAFE because slow_square is pure: identical input always
    # produces identical output, so skipping re-computation changes nothing observable.


if __name__ == "__main__":
    main()
