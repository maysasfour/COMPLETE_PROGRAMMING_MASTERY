# 04-Operators: vectorized arithmetic and the recycling rule, verified live.

a <- c(1, 2, 3)
b <- c(10, 20, 30)
cat("a + b:", a + b, "\n")
cat("a * b:", a * b, "\n\n")

cat("5 / 3:", 5 / 3, "\n")
cat("5 %% 3:", 5 %% 3, "\n")
cat("5 %/% 3:", 5 %/% 3, "\n\n")

# Recycling that divides evenly - silent, no warning
r1 <- c(1, 2, 3, 4) + c(10, 20)
cat("c(1,2,3,4) + c(10,20):", r1, "(silent recycling, evenly divides)\n")

# Recycling that does NOT divide evenly - captures the actual warning text
result <- withCallingHandlers(
  c(1, 2, 3, 4) + c(10, 20, 30),
  warning = function(w) {
    cat("Captured warning:", conditionMessage(w), "\n")
    invokeRestart("muffleWarning")
  }
)
cat("c(1,2,3,4) + c(10,20,30):", result, "\n\n")

# Vectorized vs scalar logical operators
cat("c(TRUE, FALSE) & c(TRUE, TRUE):", c(TRUE, FALSE) & c(TRUE, TRUE), "\n")
cat("TRUE && FALSE:", TRUE && FALSE, "\n")

# Demonstrate that && on a vector of length > 1 errors in modern R
test_result <- tryCatch({
  if (c(TRUE, FALSE) && TRUE) "yes" else "no"
}, error = function(e) paste("ERROR:", conditionMessage(e)))
cat("if (c(TRUE, FALSE) && TRUE):", test_result, "\n")
