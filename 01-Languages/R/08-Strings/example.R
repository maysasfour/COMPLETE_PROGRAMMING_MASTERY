# 08-Strings: verified live.

cat(paste("Hello", "World"), "\n")
cat(paste("Hello", "World", sep = "-"), "\n")
cat(paste0("Hello", "World"), "\n")
cat(paste0("item_", 1:3), "\n")
cat(paste(c("a", "b", "c"), collapse = ", "), "\n\n")

cat(sprintf("Name: %s, Age: %d", "Ada", 36), "\n")
cat(sprintf("Pi is %.2f", pi), "\n\n")

cat("nchar(\"hello\"):", nchar("hello"), "\n")
cat("toupper(\"hello\"):", toupper("hello"), "\n")
cat("substr(\"hello world\", 1, 5):", substr("hello world", 1, 5), "\n\n")

split_result <- strsplit("a,b,c", ",")
cat("class(strsplit(...)):", class(split_result), "\n")
cat("strsplit(...)[[1]]:", split_result[[1]], "\n")
cat("trimws(\"  padded  \"):", trimws("  padded  "), "\n")
cat("gsub replace all:", gsub(" ", "_", "hello world"), "\n")
cat("sub replace first:", sub("o", "0", "hello world"), "\n\n")

cat("grepl starts-with-uppercase:", grepl("^[A-Z]", c("Apple", "banana", "Cherry")), "\n")
cat("gsub remove vowels:", gsub("[aeiou]", "*", "hello world"), "\n")
