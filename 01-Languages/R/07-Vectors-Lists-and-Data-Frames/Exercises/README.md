# Exercises — 07 Vectors, Lists, and Data Frames

1. **List unwrap.** Build `book <- list(title = "Dune", pages = 412, read = FALSE)`. Print `book$pages` and compare `class(book["pages"])` vs `class(book[["pages"]])`.

2. **Build and filter a data frame.** Build a data frame of 4 products with columns `name`, `price`, `qty`. Add a computed column `total <- price * qty`. Print only the rows where `total > 50`.

3. **Row and column counts.** Given any data frame `df`, write an expression that prints `"<nrow> rows and <ncol> columns"` using `nrow()`/`ncol()`.

4. **Vector vs list type check.** Write a small script that builds a vector `c(1, "two", TRUE)` and a list `list(1, "two", TRUE)`, then uses `class()` on individual elements of each to show the difference in how they preserve (or coerce) types.
