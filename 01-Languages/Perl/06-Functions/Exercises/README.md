# Exercises — Functions

1. Write `sub max_of(@list)` that returns the largest number in `@_` (no `List::Util`).
2. Write `sub greet` that takes a name and an optional greeting word (default `"Hello"` if not given), returning `"$greeting, $name!"`.
3. Write `sub stats` that returns a *different* value depending on context: in list context return `(min, max, avg)`, in scalar context return just the count of elements. Use `wantarray`.
