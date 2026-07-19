# 01-Setup: confirm the R environment works and show basic session info.

cat("R version string:", R.version.string, "\n")
cat("Platform:", R.version$platform, "\n")

# A first vectorized expression - proof the interpreter is alive.
x <- c(1, 2, 3)
cat("A length-3 vector:", x, "\n")
cat("Sum of x:", sum(x), "\n")

# sessionInfo() is the standard "what's going on in my R session" command,
# useful for debugging package/version mismatches in real projects.
cat("\n--- sessionInfo() (trimmed) ---\n")
info <- sessionInfo()
cat("R version:", info$R.version$version.string, "\n")
