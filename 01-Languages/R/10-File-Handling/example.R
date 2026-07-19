# 10-File-Handling: real CSV round-trip and jsonlite, verified live.
library(jsonlite)

df <- data.frame(name = c("Ann", "Bob"), score = c(91, 78))

# The gotcha: WITHOUT row.names = FALSE, we get an extra X column on read-back.
write.csv(df, "scores_bad.csv")
df_bad <- read.csv("scores_bad.csv")
cat("--- WITHOUT row.names = FALSE ---\n")
print(df_bad)
cat("columns:", paste(names(df_bad), collapse = ", "), "(note the spurious X column!)\n\n")

# The correct way.
write.csv(df, "scores.csv", row.names = FALSE)
df2 <- read.csv("scores.csv")
cat("--- WITH row.names = FALSE ---\n")
print(df2)
cat("identical(df, df2):", identical(df, df2), "\n")
cat("Gotcha found by actually running this: identical() is FALSE even here!\n")
cat("str(df)  (original):\n"); str(df)
cat("str(df2) (round-tripped):\n"); str(df2)
cat("The 'score' column is 'num' (double) before, 'int' after - CSV has no type\n")
cat("metadata, so read.csv() re-infers integer for a whole-number column.\n\n")

# JSON round trip with jsonlite
data <- list(name = "Ada", age = 36, langs = c("R", "Python"))

json_no_unbox <- toJSON(data)
cat("toJSON without auto_unbox:", json_no_unbox, "\n")

json_unboxed <- toJSON(data, auto_unbox = TRUE)
cat("toJSON with auto_unbox=TRUE:", json_unboxed, "\n")

parsed <- fromJSON(json_unboxed)
cat("parsed$name:", parsed$name, " parsed$age:", parsed$age, "\n\n")

# Plain text
writeLines(c("line one", "line two"), "notes.txt")
lines <- readLines("notes.txt")
cat("readLines result:", lines, "\n")

# Cleanup - these are demo files created only for this run
file.remove("scores_bad.csv", "scores.csv", "notes.txt")
