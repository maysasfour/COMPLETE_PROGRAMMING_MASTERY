# 12-Functional-Concepts: verified live against R 4.6.1 (supports \(x) lambda shorthand).

squares <- sapply(1:5, function(x) x^2)
cat("sapply with function(x):", squares, "\n")

squares2 <- sapply(1:5, \(x) x^2)
cat("sapply with \\(x) shorthand:", squares2, "\n\n")

cat("lapply result (list):\n")
print(lapply(1:3, \(x) x * 10))

cat("\nsapply result (simplified vector):", sapply(1:3, \(x) x * 10), "\n")
cat("vapply result (shape-checked):", vapply(1:3, \(x) x * 10, numeric(1)), "\n\n")

# vapply errors if the shape doesn't match what was declared
vapply_result <- tryCatch({
  vapply(1:3, \(x) c(x, x * 10), numeric(1))  # declares numeric(1) but function returns length 2!
}, error = function(e) paste("ERROR:", conditionMessage(e)))
cat("vapply with mismatched shape:", vapply_result, "\n\n")

cat("Map result:\n")
print(Map(\(x, y) x + y, c(1, 2, 3), c(10, 20, 30)))

cat("\nReduce sum:", Reduce(\(acc, x) acc + x, c(1, 2, 3, 4)), "\n")
cat("Reduce with accumulate=TRUE:", Reduce(\(acc, x) acc + x, c(1, 2, 3, 4), accumulate = TRUE), "\n\n")

make_counter <- function() {
  count <- 0
  function() {
    count <<- count + 1
    count
  }
}

counter <- make_counter()
cat("counter():", counter(), "\n")
cat("counter():", counter(), "\n")
cat("counter():", counter(), "(state persists across calls via closure + <<-)\n")
