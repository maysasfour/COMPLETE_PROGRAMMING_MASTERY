# Solution 2: safe last element - use length(v), never hardcode an index.
v <- c("x", "y", "z", "w")
last_element <- v[length(v)]
cat("last element:", last_element, "\n")

# works correctly even for a length-1 vector
v1 <- c("only")
cat("length-1 case:", v1[length(v1)], "\n")
