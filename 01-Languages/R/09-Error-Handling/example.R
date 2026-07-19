# 09-Error-Handling: verified live.

divide <- function(a, b) {
  if (b == 0) stop("cannot divide by zero")
  a / b
}

result <- tryCatch({
  divide(10, 0)
}, error = function(e) {
  cat("Caught an error:", conditionMessage(e), "\n")
  NA
})
cat("result after failed divide:", result, "\n\n")

risky <- function(x) {
  if (x < 0) warning("negative input, results may be meaningless")
  abs(x)
}
value <- withCallingHandlers(
  risky(-5),
  warning = function(w) {
    cat("caught warning:", conditionMessage(w), "\n")
    invokeRestart("muffleWarning")
  }
)
cat("risky(-5) still returned:", value, "(execution continued after the warning)\n\n")

tryCatch({
  stop("boom")
}, error = function(e) {
  cat("handled:", conditionMessage(e), "\n")
}, finally = {
  cat("this always runs, error or not\n")
})
