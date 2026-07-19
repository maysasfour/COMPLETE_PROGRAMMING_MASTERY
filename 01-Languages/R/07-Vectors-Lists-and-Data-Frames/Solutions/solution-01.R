book <- list(title = "Dune", pages = 412, read = FALSE)
cat("book$pages:", book$pages, "\n")
cat("class(book[\"pages\"]):", class(book["pages"]), "\n")
cat("class(book[[\"pages\"]]):", class(book[["pages"]]), "\n")
