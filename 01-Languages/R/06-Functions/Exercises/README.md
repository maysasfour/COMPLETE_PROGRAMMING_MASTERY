# Exercises — 06 Functions

1. **Default argument.** Write `power(base, exponent = 2)` that returns `base` raised to `exponent`, defaulting to squaring.

2. **Variadic average.** Write `average(...)` that returns the mean of any number of numeric arguments passed in.

3. **Forwarding wrapper.** Write `loud_paste <- function(...)` that forwards all its arguments to `paste(...)` and then converts the result to uppercase.

4. **Vectorize by hand vs. `sapply`.** Write a function `classify(x)` that returns `"even"` or `"odd"` for a single number `x`. Show that calling it directly on a vector does NOT work as expected (because `%%` inside an `if` needs a length-1 value), then fix it using `sapply`.
