v <- c(1, "two", TRUE)
l <- list(1, "two", TRUE)

cat("--- vector: everything coerced to character ---\n")
for (item in v) cat(" ", item, "-", class(item), "\n")

cat("\n--- list: each element keeps its own type ---\n")
for (item in l) cat(" ", as.character(item), "-", class(item), "\n")
