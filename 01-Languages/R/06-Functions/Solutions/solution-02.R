average <- function(...) {
  values <- c(...)
  sum(values) / length(values)
}
cat("average(1,2,3):", average(1, 2, 3), "\n")
cat("average(10,20,30,40):", average(10, 20, 30, 40), "\n")
