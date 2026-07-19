# 11-OOP-Systems: S3 classes and generic dispatch, verified live.

new_animal <- function(name, sound) {
  obj <- list(name = name, sound = sound)
  class(obj) <- "animal"
  obj
}

rex <- new_animal("Rex", "Woof")
cat("class(rex):", class(rex), "\n\n")

speak <- function(x) UseMethod("speak")
speak.animal <- function(x) cat(x$name, "says", x$sound, "\n")
speak.default <- function(x) cat("(no speak method for this type)\n")

speak(rex)
speak(42)
cat("\n")

new_dog <- function(name) {
  obj <- new_animal(name, "Woof")
  class(obj) <- c("dog", "animal")
  obj
}

speak.dog <- function(x) cat(x$name, "barks enthusiastically!\n")

rex2 <- new_dog("Rex")
cat("class(rex2):", class(rex2), "\n")
speak(rex2)  # dispatches to speak.dog, the more specific class, not speak.animal

# Show what happens if speak.dog didn't exist - it would fall back to speak.animal
class(rex2) <- "animal"  # strip the dog class to prove fallback ordering
cat("\nafter removing 'dog' from class vector:\n")
speak(rex2)  # now dispatches to speak.animal since only that class remains
