# Solution 5: demonstrate the 1:length(x) vs seq_along(x) gotcha on an empty vector.
x <- c()

cat("Using 1:length(x):\n")
ran_wrong <- FALSE
for (i in 1:length(x)) {
  ran_wrong <- TRUE
  cat("  iteration with i =", i, "(should not happen for an empty vector!)\n")
}
if (!ran_wrong) cat("  (did not print - unexpected)\n")

cat("Using seq_along(x):\n")
ran_right <- FALSE
for (i in seq_along(x)) {
  ran_right <- TRUE
}
if (!ran_right) cat("  correctly ran zero iterations\n")
