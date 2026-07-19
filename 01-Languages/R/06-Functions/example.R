# 06-Functions: defaults, ..., and vectorization-for-free - verified live.

greet <- function(name, greeting = "Hello") {
  paste0(greeting, ", ", name, "!")
}
cat(greet("Ada"), "\n")
cat(greet("Ada", "Hi"), "\n")
cat(greet("Ada", greeting = "Hey"), "\n\n")

sum_all <- function(...) sum(...)
cat("sum_all(1,2,3,4):", sum_all(1, 2, 3, 4), "\n")

log_message <- function(prefix, ...) {
  cat(prefix, ..., "\n")
}
log_message("INFO:", "server started on port", 8080)
cat("\n")

square <- function(x) x^2
cat("square(5):", square(5), "\n")
cat("square(c(1,2,3,4)):", square(c(1, 2, 3, 4)), "(vectorized for free, no code change)\n\n")

cat("sapply version:", sapply(c(1, 2, 3), function(x) x^2), "\n")
result_list <- lapply(c(1, 2, 3), function(x) x^2)
cat("lapply version (as list, printed):\n")
print(result_list)
