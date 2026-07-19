# 11 — OOP Systems

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## R Has Three Parallel OOP Systems — A Genuinely Unusual Situation

Most languages have one object system. R has **three**, coexisting in the same ecosystem, because R's OOP capabilities grew organically over decades rather than being designed up front:

1. **S3** — informal, the oldest, and by far the most common in base R and everyday packages. No formal class definition; "classes" are just a `class` attribute on an object, and behavior comes from writing functions named `generic.classname`.
2. **S4** — a formal system with declared classes, typed slots, and validity checking, used heavily in Bioconductor and some statistical packages where rigor matters more than convenience.
3. **R5 / Reference Classes (`setRefClass`)** — R's closest analogue to conventional mutable, reference-semantics OOP (like Java/Python classes), added later; `R6` (a CRAN package, not base R) is the more commonly used modern alternative for this style in practice.

This course covers **S3 in depth** (verified live, since it's what you'll actually encounter most) and describes S4/R5 honestly at a conceptual level without building full working examples of all three — S3 alone genuinely covers the great majority of real-world base-R object-oriented code you'll read.

## S3 In Depth: Informal Classes and Generic Dispatch

An S3 object is just a regular R object (often a list) with a `class` attribute attached:

```r
new_animal <- function(name, sound) {
  obj <- list(name = name, sound = sound)
  class(obj) <- "animal"
  obj
}

rex <- new_animal("Rex", "Woof")
class(rex)   # "animal"
```

A **generic function** dispatches to a different implementation based on the object's class. `print()`, `summary()`, and `+` are all generics in R. You make your own class participate by defining a method named `genericname.classname`:

```r
speak <- function(x) UseMethod("speak")     # declares `speak` as a generic
speak.animal <- function(x) cat(x$name, "says", x$sound, "\n")   # method for class "animal"
speak.default <- function(x) cat("(no speak method for this type)\n")  # fallback

speak(rex)        # "Rex says Woof" - dispatches to speak.animal
speak(42)         # falls back to speak.default - 42 has no "animal" class
```

`UseMethod("speak")` is the dispatch mechanism: when you call `speak(x)`, R looks at `class(x)`, looks for a function literally named `speak.<that class>`, and calls it — falling back to `speak.default` if no exact match exists. This is verified live in `example.R`.

## S3 Inheritance

An object can have multiple classes (a character vector), and dispatch tries them in order — this is how S3 "inheritance" works:

```r
new_dog <- function(name) {
  obj <- new_animal(name, "Woof")
  class(obj) <- c("dog", "animal")   # "dog" first, "animal" as a fallback
  obj
}

speak.dog <- function(x) cat(x$name, "barks enthusiastically!\n")

rex2 <- new_dog("Rex")
speak(rex2)   # dispatches to speak.dog first (more specific), not speak.animal
```

## S4 and R5 — Honest, Brief Coverage

**S4** requires explicit class definitions with `setClass()`, typed slots (`representation()`/`slots =`), and generics/methods declared with `setGeneric()`/`setMethod()`. It is considerably more ceremony than S3 in exchange for compile-time-like validity checking and multiple dispatch (a method can depend on the classes of more than one argument, unlike S3). It shows up heavily in Bioconductor (genomics) packages and some core R internals (e.g. Matrix package), but is rare in everyday application code.

**R5 / Reference Classes** (`setRefClass()`) give you mutable objects with reference semantics — methods can modify an object's fields in place, unlike S3/S4's copy-on-modify value semantics. In practice, most R programmers who want this style reach for the third-party **R6** package instead, since it has a more ergonomic syntax and better performance characteristics; base R's `setRefClass` is less commonly seen in the wild.

We describe both honestly here rather than building full working examples of each — for a course budget, S3 is the system that pays off the most to actually practice, since it's what you'll read in nearly every base-R function's source and in most CRAN packages' public APIs.

## Real-World Usage

- `print()`, `summary()`, `format()`, `as.character()`, and arithmetic operators (`+`, `==`) are all S3 generics under the hood — when you call `print(my_lm_model)` after fitting a linear model with `lm()`, R dispatches to `print.lm`, a method that knows how to format model output specifically.
- S3's simplicity (any object + a class attribute + a same-named function) is precisely why it remains the default choice for most package authors — it requires no ceremony to get useful dispatch behavior.

## Summary

- R has three OOP systems: **S3** (informal, class = attribute + `generic.class` functions, by far the most common), **S4** (formal, `setClass`/`setGeneric`, used where rigor/multiple dispatch matter), and **R5/Reference Classes** (mutable, reference semantics; R6 package is the more common modern choice for this style).
- S3 dispatch: `UseMethod("name")` in a generic function, then `name.classname` methods, with `name.default` as the fallback; a class attribute can be a vector for S3-style "inheritance," tried in order.
- This course covers S3 in depth with working, verified code and describes S4/R5 honestly at a conceptual level rather than building full parallel examples of all three.

## Key Terms

- **S3** — R's informal object system: a class attribute plus generic-dispatch functions named `generic.classname`.
- **S4** — R's formal object system with declared classes, typed slots, and multiple dispatch.
- **R5 / Reference Classes** — R's base mutable, reference-semantics object system (`setRefClass`); R6 (CRAN) is the more common modern alternative.
- **Generic function** — a function (like `print` or a custom `speak`) that dispatches to different implementations based on an object's class.
- **`UseMethod()`** — declares a function as an S3 generic, triggering dispatch based on `class(x)`.

## Common Mistakes

- Assuming R has one unified class system, then being confused when a package uses S4 syntax (`setClass`) that looks nothing like S3.
- Forgetting to define a `.default` method, so an unexpected input type produces a confusing "could not find function" error instead of a graceful fallback.
- Naming a method incorrectly (e.g. a typo in `speak.animal`) — since dispatch is purely by naming convention, a typo silently fails to register the method rather than raising an error at definition time.

## Best Practices

- Default to S3 for your own simple classes; reach for S4 only when you specifically need multiple dispatch or strict validity checking.
- Always define a `.default` method for your generics so unexpected input types fail gracefully rather than with an opaque error.
- Keep the class attribute ordered from most-specific to least-specific when using multiple classes, since S3 dispatch tries them left to right.

## Interview Questions

1. **How many object systems does R have, and which is most common?**
   Three: S3, S4, and R5/Reference Classes. S3 is by far the most common in base R and typical CRAN packages, because it requires the least ceremony.

2. **How does S3 method dispatch actually work?**
   A generic function calls `UseMethod("name")`; R then looks at the object's `class` attribute and searches for a function literally named `name.<class>`, calling the first match (trying multiple classes in order if the class attribute has more than one), falling back to `name.default` if none match.

3. **What's the key practical difference between S3/S4 and R5/Reference Classes?**
   S3 and S4 use copy-on-modify value semantics — calling a method doesn't mutate the original object. R5 (and the more commonly used R6 package) provide reference semantics, where methods can mutate an object's fields in place, closer to how classes work in Java or Python.

## Suggested Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
