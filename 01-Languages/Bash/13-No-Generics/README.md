# 13 — No Generics

[Back to Bash course](../README.md)

## Why Generics Don't Apply Here at All

Generics (as in Java's `List<T>`, C#'s `List<T>`, Rust's `Vec<T>`) exist to let a **statically-typed** language write one implementation of a container or algorithm that works safely across many concrete types, while still catching type mismatches at compile time.

Bash has:

- **No compiler and no compile-time type checking whatsoever** (Lesson 03) — there's nothing for a generic type parameter to be checked against.
- **No type system to parameterize.** Every variable is a string; every array element is a string (or, in an associative array, a string value under a string key). A Bash array is already "generic" in the trivial sense that it holds strings regardless of what those strings represent — the same way a Python `list` needs no `List[T]` annotation to hold mixed content, except Bash doesn't even have the *concept* of the contained type to reason about.
- **No user-defined types at all** (no classes/structs — see Lesson 11's note on this) to be generic *over* in the first place.

So this isn't a missing feature to work around, the way it might be in a language that has real types but skipped generics (e.g., early Go before 1.18) — it's a category error to ask for generics in a shell scripting language where every value is already untyped text. Whatever "generic" behavior Bash needs (a function working on any array of strings, e.g.) it already has for free, since everything is a string already.

## What Bash Does Instead

If you need a function that operates uniformly over any array of values regardless of "type" (there is no type to vary over anyway):

```bash
print_all() {
  local -n arr_ref="$1"   # nameref: refer to a caller's array by name
  for item in "${arr_ref[@]}"; do
    echo "$item"
  done
}
nums=(1 2 3)
words=(foo bar baz)
print_all nums
print_all words
```

`declare -n` (nameref) lets a function operate on an array passed by *name*, which is the closest Bash gets to "generic over container contents" — but it's still just operating on strings, not a parameterized type.

## Interview Questions

1. Why is it a category error, rather than a missing feature, to ask "how does Bash implement generics"?
2. What does a Bash nameref (`declare -n`) let you do that's structurally similar to (but not the same as) generic programming?
