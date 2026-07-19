# 05-Control-Flow: if/for/while, 1-based indexing, and the seq_along gotcha - verified live.

temperature <- 15
if (temperature > 30) {
  print("hot")
} else if (temperature > 15) {
  print("warm")
} else {
  print("cool")
}

for (i in 1:3) cat(i, " ")
cat("\n1:3 is inclusive of both ends (unlike Python range(3))\n\n")

v <- c("a", "b", "c")
cat("v[1]:", v[1], "\n")
cat("v[0]:", v[0], "- length:", length(v[0]), "(empty, not an error, not the last element)\n")
cat("v[3]:", v[3], "\n")
cat("v[-1]:", v[-1], "(everything EXCEPT the first element)\n")
cat("v[-c(1,2)]:", v[-c(1,2)], "\n\n")

for (i in 1:5) {
  if (i == 3) next
  if (i == 5) break
  print(i)
}
cat("(prints 1, 2, 4 - 3 skipped via next, loop stopped before 5 via break)\n\n")

count <- 1
repeat {
  print(count)
  count <- count + 1
  if (count > 3) break
}

# The seq_along gotcha with an empty vector
empty_vec <- c()
cat("\nlength(empty_vec):", length(empty_vec), "\n")
cat("1:length(empty_vec):", 1:length(empty_vec), "(nonsensical - counts DOWN from 1 to 0!)\n")
cat("seq_along(empty_vec):", seq_along(empty_vec), "(correctly empty)\n")
for (i in seq_along(empty_vec)) {
  cat("this should never print:", i, "\n")
}
cat("(seq_along loop over empty vector correctly ran zero times)\n")
