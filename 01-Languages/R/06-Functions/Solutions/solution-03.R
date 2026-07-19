loud_paste <- function(...) {
  toupper(paste(...))
}
cat(loud_paste("hello", "world"), "\n")
cat(loud_paste("r", "is", "fun"), "\n")
