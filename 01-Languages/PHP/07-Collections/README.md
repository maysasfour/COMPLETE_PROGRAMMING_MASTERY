# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Understand PHP's single `array` type serving as both a list and an ordered map — unlike every other language in this repository, which splits these into distinct types (Python's `list`/`dict`, Go's slice/map, Rust's `Vec`/`HashMap`).
- Use `array_map`/`array_filter`/`array_reduce`, and know that `array_filter` preserves original keys.
- Use array destructuring (`[$a, $b] = $arr`) and the spread operator in array literals.

## Prerequisites

[06-Functions](../06-Functions/README.md)

## Concept

PHP has exactly one array type, internally an **ordered hash map** — it can be used as a sequential list (integer keys, 0-indexed by convention), an associative map (string or arbitrary keys), or a mix of both in the same array. This is a genuine, distinctive design choice: every other language covered in this repository has separate list/array and map/dictionary types with different APIs.

## Lists and Associative Arrays Are the Same Type

```php
$list = [1, 2, 3];                       // sequential int keys
$assoc = ["name" => "Ada", "age" => 30]; // string keys -- same `array` type underneath
$mixed = ["a", "b", 5 => "c", "key" => "d"]; // legal: mixing auto-int and explicit keys
```

## `array_map` / `array_filter` / `array_reduce`

```php
$doubled = array_map(fn($n) => $n * 2, $nums);
$evens = array_filter($nums, fn($n) => $n % 2 === 0);
$total = array_reduce($nums, fn($carry, $n) => $carry + $n, 0);
```

## A Genuine Gotcha: `array_filter` Preserves Original Keys

```php
$nums = [1, 2, 3, 4, 5];
$evens = array_filter($nums, fn($n) => $n % 2 === 0);
var_dump($evens); // keys are [1] and [3] -- the ORIGINAL indices, NOT re-indexed to 0, 1!
$evens = array_values($evens); // re-index from 0 explicitly, if a clean list is needed
```

Verified live: filtering `[1, 2, 3, 4, 5]` down to evens produces `[1 => 2, 3 => 4]`, keeping the original positions of `2` and `4`. Code that assumes the result is a clean, 0-indexed list (e.g., accessing `$evens[0]`) will get a surprise unless `array_values()` is applied afterward.

## Destructuring and Spread

```php
[$first, $second, $third] = $list;                 // positional destructuring
["name" => $n, "age" => $a] = $assoc;                // keyed destructuring
$combined = [...$list, ...[4, 5]];                    // spread operator (PHP 7.4+)
```

## `sort()` Mutates in Place

```php
$unsorted = [3, 1, 4, 1, 5];
sort($unsorted); // mutates $unsorted directly; returns bool, NOT the sorted array
```

Unlike JavaScript's `Array.prototype.sort` (which both mutates and returns the array) or a functional `sorted()` in Python, PHP's `sort()` mutates its argument by reference and returns a plain `bool` success flag — using the return value as if it were the sorted array is a real mistake.

## Detailed Example

See [example.php](example.php) — all of the above, with the `array_filter` key-preservation gotcha demonstrated live via a direct `var_dump` before and after `array_values()`.

## Practice

- [Exercises/exercise.php](Exercises/exercise.php) — filter/map/sum a list of associative-array "products" to compute total in-stock price and re-indexed in-stock names.
- [Solutions/solution.php](Solutions/solution.php) — a worked solution, verified to print `total: 24.98` and `names: Widget, Gizmo`.

## Run It

```bash
cd 01-Languages/PHP/07-Collections
php example.php
php Solutions/solution.php
```

## Expected Output

`example.php` prints the list/assoc contents, the mixed-key array's `var_dump`, `doubled`/`evens`/`total` results, a `var_dump` proving `array_filter` keeps keys `1` and `3` (not re-indexed) followed by the re-indexed version, both destructuring results, the spread-combined array, and the sorted array. `Solutions/solution.php` prints `total: 24.98` and `names: Widget, Gizmo`.

## Common Mistakes

- Assuming `array_filter`'s result is a clean, 0-indexed array — it preserves the original keys, verified live in this lesson; forgetting `array_values()` afterward is a common, real bug source (e.g., `json_encode`-ing a key-gapped array produces a JSON *object* `{"1":2,"3":4}` instead of the intended JSON *array* `[2,4]`).
- Treating `sort()`'s return value as the sorted array — it returns a `bool`; the array itself is mutated in place via its reference parameter.
- Forgetting that PHP arrays are ordered — iteration order follows insertion order (or numeric key order after operations like `sort()`), not an unordered hash the way some other languages' maps behave.

## Best Practices

- Call `array_values()` after `array_filter()` (or any key-gap-introducing operation) whenever a clean, re-indexed list is needed downstream, especially before `json_encode()`.
- Prefer the functional trio (`array_map`/`array_filter`/`array_reduce`) with arrow functions over manual `foreach` loops for straightforward transform/filter/aggregate operations.
- Use `usort()`/`<=>` (Lesson 04) rather than `sort()` when a custom ordering is needed.

## Real-World Usage

The `array_filter`-preserves-keys behavior is one of PHP's most commonly cited "gotchas" in real-world bug reports, particularly around JSON serialization, where an unexpected key gap silently turns an intended JSON array into a JSON object — this lesson's live demonstration mirrors exactly that failure mode.

## Summary

- PHP has one `array` type serving as both list and ordered map — a genuine design difference from every other language in this course.
- `array_filter` preserves original keys; `array_values()` re-indexes explicitly when needed.
- `sort()` mutates in place and returns a `bool`, not the sorted array.
- Destructuring and the spread operator work on PHP arrays much like their equivalents elsewhere in this repository.

## Key Terms

- **Associative array** — a PHP array using non-sequential or string keys, functioning as a map.
- **Key preservation** — `array_filter`'s behavior of keeping each surviving element's original key rather than re-indexing.

## Interview Questions

1. **Why might `json_encode()` of a filtered PHP array produce a JSON object instead of a JSON array unexpectedly?**
   Because `array_filter()` preserves the original keys of surviving elements rather than re-indexing them — if filtering `[1, 2, 3, 4, 5]` down to even numbers leaves keys `1` and `3` (not `0` and `1`), `json_encode()` sees a non-sequential-from-zero array and serializes it as a JSON object (`{"1":2,"3":4}`) instead of a JSON array (`[2,4]`), since PHP's `json_encode` distinguishes list-like from map-like arrays based on key structure. The fix is calling `array_values()` on the filtered result first to force a clean, 0-indexed list.

2. **Why does PHP have only one `array` type instead of separate list/map types like Python or Go?**
   PHP's `array` is internally implemented as an ordered hash map, which can represent a sequential list (auto-incrementing integer keys), an associative map (string or arbitrary keys), or a mix of both, all with the same underlying data structure and API. This is a deliberate simplicity/flexibility trade-off from PHP's original design — one type covers many use cases with a single, large standard-library function set (`array_*`), at the cost of some of the type-level clarity that a dedicated `List<T>`/`Dictionary<K,V>` split would give.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
