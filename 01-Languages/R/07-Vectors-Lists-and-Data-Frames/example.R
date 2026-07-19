# 07-Vectors-Lists-and-Data-Frames: verified live.

nums <- c(10, 20, 30)
cat("nums[2]:", nums[2], "  length:", length(nums), "\n\n")

person <- list(name = "Ada", age = 36, active = TRUE)
cat("person$name:", person$name, "\n")
cat("person[[\"age\"]]:", person[["age"]], " class:", class(person[["age"]]), "\n")
cat("person[\"age\"] class:", class(person["age"]), "(a list, NOT the raw value!)\n\n")

df <- data.frame(
  name = c("Ann", "Bob", "Cid"),
  age  = c(28, 34, 41),
  active = c(TRUE, FALSE, TRUE)
)
cat("--- data frame ---\n")
print(df)

cat("\ndf$age:", df$age, "\n")
cat("df[[\"age\"]]:", df[["age"]], "\n")
cat("df[, \"age\"]:", df[, "age"], "\n\n")

cat("--- first row df[1, ] ---\n")
print(df[1, ])

cat("\n--- rows where age > 30 ---\n")
print(df[df$age > 30, ])

df$is_senior <- df$age >= 35
cat("\n--- after adding computed column is_senior ---\n")
print(df)
cat("\nnrow:", nrow(df), " ncol:", ncol(df), "\n\n")

cat("--- str(df) ---\n")
str(df)
