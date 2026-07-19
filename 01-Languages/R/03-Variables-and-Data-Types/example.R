# 03-Variables-and-Data-Types: verified live.

x <- 42
cat("is.vector(x):", is.vector(x), "\n")
cat("length(x):", length(x), "\n")
cat("class(x):", class(x), "\n\n")

cat("class(42):", class(42), "\n")
cat("class(42L):", class(42L), "\n")
cat("class(\"hi\"):", class("hi"), "\n")
cat("class(TRUE):", class(TRUE), "\n\n")

cat("typeof(42):", typeof(42), "\n")
cat("typeof(42L):", typeof(42L), "\n\n")

v <- c(1, 2, NA, 4)
cat("sum(v):", sum(v), "\n")
cat("sum(v, na.rm = TRUE):", sum(v, na.rm = TRUE), "\n")
cat("is.na(v):", is.na(v), "\n\n")

cat("length(NA):", length(NA), "\n")
cat("length(NULL):", length(NULL), "\n")

x_with_na <- c(1, 2, NA, 4)
y_with_null <- c(1, 2, NULL, 4)
cat("length(c(1,2,NA,4)):", length(x_with_na), "\n")
cat("length(c(1,2,NULL,4)):", length(y_with_null), "- NULL vanished!\n\n")

cat("c(1, \"two\", TRUE):", c(1, "two", TRUE), "\n")
cat("c(1, TRUE):", c(1, TRUE), "\n")
