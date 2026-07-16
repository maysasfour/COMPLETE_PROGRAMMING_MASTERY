"""Solution 05 - Specialized Loggers."""

from functools import partial


def log(level, module, message):
    print(f"[{level}] {module}: {message}")


def curry2(func):
    def curried(a):
        def with_b(b):
            return func(a, b)
        return with_b
    return curried


def multiply(a, b):
    return a * b


def main():
    print("--- partial application, one layer at a time ---")
    log_error = partial(log, "ERROR")
    log_info = partial(log, "INFO")
    log_error("auth", "invalid token")
    log_info("startup", "server ready")

    print("\n--- further specializing log_error ---")
    log_auth_error = partial(log_error, "auth")
    log_auth_error("invalid token")
    log_auth_error("session expired")

    print("\n--- curry2 applied to multiply ---")
    curried_multiply = curry2(multiply)
    print(curried_multiply(3)(4), "==", multiply(3, 4))

    print("\n--- why partial(log, 'ERROR') and a fully curried version behave differently ---")
    # partial(log, "ERROR") still accepts TWO remaining arguments in ONE call:
    partial_result = log_error("auth", "works fine with two args at once")

    # A fully curried log (via a hypothetical curry3) would NOT accept two args at once --
    # curry3(log)("ERROR") returns a function taking ONLY "module", which itself returns a
    # function taking ONLY "message" -- calling it with BOTH remaining args in one call
    # would raise a TypeError, since a curried single-argument function takes exactly one.
    def curry3(func):
        def c(a):
            def with_b(b):
                def with_c(c_):
                    return func(a, b, c_)
                return with_c
            return with_b
        return c

    curried_log_error = curry3(log)("ERROR")
    try:
        curried_log_error("auth", "this will fail")  # TypeError -- with_b takes only ONE argument
    except TypeError as e:
        print(f"caught, as expected: {e}")


if __name__ == "__main__":
    main()
