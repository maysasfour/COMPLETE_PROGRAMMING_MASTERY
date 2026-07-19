classify <- function(x) {
  if (x %% 2 == 0) "even" else "odd"
}

# Calling directly on a vector fails: if() needs a length-1 logical (R 4.3+ errors).
direct_result <- tryCatch({
  classify(c(1, 2, 3, 4))
}, error = function(e) paste("ERROR:", conditionMessage(e)))
cat("classify(c(1,2,3,4)) directly:", direct_result, "\n")

# Fixed with sapply - calls classify() once per element.
fixed_result <- sapply(c(1, 2, 3, 4), classify)
cat("sapply(c(1,2,3,4), classify):", fixed_result, "\n")
