# Exercises — 05 Control Flow

Attempt each problem yourself before checking `../Solutions/`.

1. **FizzBuzz.** Loop `1` through `20` (inclusive). Print "Fizz" for multiples of 3, "Buzz" for multiples of 5, "FizzBuzz" for both, and the number otherwise.

2. **Safe last element.** Write code that gets the *last* element of a vector `v` correctly regardless of its length, without hardcoding an index (remember 1-based indexing and that `length(v)` is the last valid index).

3. **Count negatives with `next`.** Given `nums <- c(3, -1, 4, -1, 5, -9, 2, -6)`, use a `for` loop with `next` to count how many elements are negative, skipping non-negative ones.

4. **First match with `break`.** Given a vector of words, loop until you find the first word longer than 5 characters (use `nchar()`), print it, and `break`. If none is found, print "no match".

5. **Empty-vector safety.** Demonstrate the `1:length(x)` vs `seq_along(x)` gotcha from the lesson: write a loop using each approach over an empty vector `x <- c()` and show that only `seq_along` behaves correctly.
