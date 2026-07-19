# Solution 3: count negatives with next.
nums <- c(3, -1, 4, -1, 5, -9, 2, -6)
negative_count <- 0
for (n in nums) {
  if (n >= 0) next
  negative_count <- negative_count + 1
}
cat("negative count:", negative_count, "\n")
