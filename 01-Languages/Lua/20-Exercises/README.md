# 20 - Exercises

Spanning the whole course. Solutions and their real, run output are in [21-Solutions](../21-Solutions/README.md).

1. **Global-leak audit** (Lessons 03, 19): write a function that intentionally forgets `local` for a variable, call it, then prove the leak by reading the value from `_G` afterward, and finally fix the function with `local`.
2. **1-based indexing sum** (Lesson 07): given a table `{10, 20, 30, 40}`, write a function that sums only the elements at *even* 1-based indices (2 and 4), printing which indices/values were included.
3. **Multiple returns divmod** (Lesson 06): write `stats(...)` taking any number of numeric varargs and returning three values — count, sum, and average — in one call.
4. **Pattern-match parser** (Lesson 08): given a string like `"name=Ada;age=36;city=Lima"`, use `gmatch` to extract each `key=value` pair into a table.
5. **Minimal class + inheritance** (Lesson 11): build a `Shape` "class" (metatable-based) with an `area()` method returning 0, and a `Circle` subclass overriding `area()` using `radius^2 * math.pi`.
6. **Coroutine range generator** (Lesson 14): write a `coroutine.wrap`-based iterator that yields only even numbers from 1 to `n`.
7. **Error-safe parser** (Lesson 09): write a function that calls `error()` if given a non-numeric string, and a caller that uses `pcall` to report either the parsed number or a friendly failure message.
8. **Hand-rolled test** (Lesson 18): using `testkit.lua`'s pattern, write two test cases for a `is_even(n)` function, one passing and one deliberately failing, and confirm the harness reports both correctly.
