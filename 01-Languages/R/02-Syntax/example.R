# 02-Syntax: assignment operators, verified live.

x <- 10
y = 20
cat("x =", x, " y =", y, "\n")

# The genuinely surprising part: `=` inside a call names an argument,
# it does NOT assign in the calling scope. Verify it live.
x <- 10
result <- mean(x = c(1, 2, 3))
cat("result of mean(x = c(1,2,3)):", result, "\n")
cat("outer x is still:", x, "\n")  # still 10, untouched

# -> assigns left to right
5 -> z
cat("z (via ->):", z, "\n")

# No semicolons needed; they're legal but not idiomatic
a <- 1; b <- 2
cat("a:", a, "b:", b, "\n")

# Only # comments exist - no block comment syntax
# this line and the one above are both single-line comments
cat("done\n")
