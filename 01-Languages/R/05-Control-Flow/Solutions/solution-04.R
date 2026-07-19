# Solution 4: first match with break.
words <- c("cat", "dog", "elephant", "fox")
found <- NULL
for (w in words) {
  if (nchar(w) > 5) {
    found <- w
    break
  }
}
if (is.null(found)) {
  print("no match")
} else {
  print(found)
}
