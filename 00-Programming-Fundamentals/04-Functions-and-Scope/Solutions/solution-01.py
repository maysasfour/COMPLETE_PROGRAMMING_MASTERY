"""
Solution 01 - Functions and Scope
Closure-based counter factory, recursive digit sum, and the mutable
default argument bug demonstrated side by side with its fix.

Run with:
    python solution-01.py

Expected output:
    --- Part A: Closures ---
    counter_a() = 1
    counter_a() = 2
    counter_b() = 1

    --- Part B: Recursion ---
    sum_digits(1234) = 10
    sum_digits(7) = 7

    --- Part C: Mutable default argument ---
    Buggy   call 1 (user=Alice): ['Alice']
    Buggy   call 2 (user=Bob):   ['Alice', 'Bob']  <- Bob's call sees Alice too, that's the bug
    Fixed   call 1 (user=Alice): ['Alice']
    Fixed   call 2 (user=Bob):   ['Bob']  <- correctly independent
"""

print("--- Part A: Closures ---")


def make_counter():
    count = 0

    def increment():
        # Plain `count += 1` here would raise UnboundLocalError: Python
        # sees an assignment to `count` inside increment() and treats it
        # as a local variable for the WHOLE function body, so the read
        # on the right-hand side would reference a local that doesn't
        # exist yet. `nonlocal` tells Python "count belongs to the
        # enclosing scope, don't shadow it locally."
        nonlocal count
        count += 1
        return count

    return increment


# Each call to make_counter() creates a BRAND NEW `count` variable in a
# brand new enclosing scope. counter_a and counter_b close over two
# entirely separate `count` cells, so incrementing one never affects
# the other - this is the same "fresh scope per call" behavior as the
# lesson's make_multiplier example.
counter_a = make_counter()
counter_b = make_counter()
print("counter_a() =", counter_a())
print("counter_a() =", counter_a())
print("counter_b() =", counter_b())

print("\n--- Part B: Recursion ---")


def sum_digits(n):
    # Base case: a single-digit number's digit sum is itself - no
    # further recursion needed.
    if n < 10:
        return n
    # Recursive case: split off the last digit (n % 10) and recurse on
    # the remaining, strictly smaller number (n // 10) - guaranteed to
    # shrink toward the base case since integer division reduces
    # magnitude every call.
    return n % 10 + sum_digits(n // 10)


print("sum_digits(1234) =", sum_digits(1234))
print("sum_digits(7) =", sum_digits(7))

print("\n--- Part C: Mutable default argument ---")


def track_visit_buggy(user, log=[]):
    # BUG: this same list object is reused across every call that
    # doesn't pass its own `log`, because default values are evaluated
    # ONCE at function-definition time.
    log.append(user)
    return log


def track_visit_fixed(user, log=None):
    if log is None:
        log = []
    log.append(user)
    return log


print("Buggy   call 1 (user=Alice):", track_visit_buggy("Alice"))
print("Buggy   call 2 (user=Bob):  ", track_visit_buggy("Bob"), " <- Bob's call sees Alice too, that's the bug")
print("Fixed   call 1 (user=Alice):", track_visit_fixed("Alice"))
print("Fixed   call 2 (user=Bob):  ", track_visit_fixed("Bob"), " <- correctly independent")
