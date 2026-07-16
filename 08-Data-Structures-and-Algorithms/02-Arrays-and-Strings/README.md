# 02 — Arrays and Strings

[Back to module overview](../README.md) | [Previous: Complexity Analysis](../01-Complexity-Analysis/README.md)

## Beginner: What an Array Actually Is

An **array** is a block of contiguous memory holding elements of a fixed layout, indexed by position. Because the memory is contiguous and each element takes the same amount of space, the computer can calculate the exact memory address of `array[i]` directly (`base_address + i * element_size`) — no searching required. That's why indexed access is O(1).

Python's `list` is technically a **dynamic array**: under the hood it's a contiguous array of pointers (to objects, since Python is dynamically typed — see `00-Programming-Fundamentals/02-Variables-and-Types`), and it automatically grows its underlying storage when you append past its current capacity. This lesson uses "array" and "Python list" somewhat interchangeably, but keep in mind that in lower-level languages (C, Java), "array" usually means a fixed-size block you must explicitly resize yourself.

## Beginner: Array Operations and Their Complexity

| Operation | Complexity | Why |
|---|---|---|
| Access by index (`data[i]`) | O(1) | Direct address calculation |
| Append to end (`data.append(x)`) | O(1) amortized | Usually just writes to pre-allocated space (see note below) |
| Insert at front/middle (`data.insert(i, x)`) | O(n) | Every element after position `i` must shift right |
| Delete from front/middle (`data.pop(0)`) | O(n) | Every remaining element must shift left |
| Delete from end (`data.pop()`) | O(1) | Nothing shifts — it's the last slot |
| Search (unsorted, `x in data`) | O(n) | No shortcut — may have to check every element |

**"Amortized O(1)" for append** means: most appends are a simple O(1) write, but occasionally the underlying array runs out of room and Python must allocate a bigger block and copy every existing element over (an O(n) operation). Python over-allocates generously when it resizes, so these expensive resizes happen rarely enough that the *average* cost per append, over a long sequence of appends, still works out to O(1). This is the same idea named explicitly in Lesson 01's Key Terms.

## Intermediate: Strings Are (Mostly) Arrays of Characters

A string can be thought of as an array of characters, which is why array techniques (two-pointer scans, in-place-style manipulation) apply directly to string problems. The one crucial Python-specific wrinkle: **Python strings are immutable** — you cannot do `text[0] = "x"`. Any "modification" actually builds a new string. `implementation.py`'s `reverse_string` function works around this by converting to a `list` (mutable), reversing in place, then joining back into a string — this is the standard pattern for string manipulation in Python.

## Intermediate: The Two-Pointer Technique

Both `reverse_string` and `is_palindrome` in `implementation.py` use the **two-pointer technique**: one pointer starts at the beginning, one at the end, and they move toward each other until they meet. This turns what might look like it needs nested loops into a single O(n) pass, because each pointer only ever moves forward (or backward) — neither pointer revisits a position, so the total number of steps is bounded by the length of the input, not its square.

## Advanced: Why Anagram Checking Uses Counting Instead of Sorting

A common first instinct for anagram checking is: sort both strings, then compare — if the sorted results are equal, they're anagrams. That works, but it's O(n log n) because of the sort. `implementation.py`'s `is_anagram` instead builds a character-frequency count (a small dictionary — previewing Lesson 05's hash tables): O(n) to build the count from the first string, O(n) to subtract using the second, giving a total of O(n) — strictly better than the sort-based approach, at the cost of O(n) extra space for the count table (versus sorting, which can often be done with O(1) extra space using an in-place sort). This is a direct, concrete instance of the time/space trade-off introduced in Lesson 01.

## How to Run

```bash
cd 08-Data-Structures-and-Algorithms/02-Arrays-and-Strings
python implementation.py
```

## Verified Output

```
=== Array (list) operations and their complexity ===
Initial list: [10, 20, 30, 40, 50]
data[2] -> 30  (O(1): index math, not a search)
After append(60): [10, 20, 30, 40, 50, 60]  (O(1) amortized)
After insert(0, 5): [5, 10, 20, 30, 40, 50, 60]  (O(n): every existing element shifts)
After pop(0): [10, 20, 30, 40, 50, 60]  (O(n): every remaining element shifts)
After pop(): [10, 20, 30, 40, 50]  (O(1): no shifting needed, it's the last slot)
30 in data -> True  (O(n): unsorted, so a full scan may be needed)

=== String reversal ===
reverse_string('hello') -> 'olleh'
reverse_string('Python') -> 'nohtyP'
reverse_string('a') -> 'a'

=== Palindrome check ===
is_palindrome('racecar') -> True
is_palindrome('hello') -> False
is_palindrome('A man, a plan, a canal: Panama') -> True
is_palindrome('') -> True

=== Anagram check ===
is_anagram('listen', 'silent') -> True
is_anagram('hello', 'world') -> False
is_anagram('Dormitory', 'Dirty Room') -> True
is_anagram('aabbcc', 'abcabc') -> True
```

## Summary

- Arrays give O(1) indexed access because elements are contiguous in memory and addresses can be calculated directly.
- Insert/delete at the front or middle is O(n) because remaining elements must shift; at the end it's O(1) (or amortized O(1) for append).
- Python strings are immutable — manipulation typically means building a new string or a `list` of characters.
- The two-pointer technique turns many array/string problems into a single O(n) pass instead of nested loops.
- Counting (hash-table-style) beats sorting for anagram checks: O(n) versus O(n log n), at the cost of O(n) extra space.

## Key Terms

- **Array / list** — contiguous, indexable collection of elements.
- **Dynamic array** — an array that automatically resizes its underlying storage as needed (Python's `list`).
- **Amortized complexity** — average cost per operation across a sequence, smoothing out occasional expensive operations.
- **Two-pointer technique** — using two index variables that move toward or away from each other to solve array/string problems in one pass.
- **In-place** — an algorithm that modifies its input using O(1) extra space, rather than allocating a new structure.

## Common Mistakes

- Assuming `data.insert(0, x)` and `data.append(x)` have the same complexity — they don't; front insertion is O(n), append is amortized O(1).
- Trying to mutate a Python string directly (`text[0] = "x"`) — strings are immutable; convert to a list first, or build a new string.
- Forgetting to normalize input (case, whitespace, punctuation) before palindrome/anagram checks, then getting "wrong" answers on realistic input like sentences.
- Reaching for `sorted(a) == sorted(b)` as the *only* way to check anagrams without realizing it's O(n log n) when an O(n) counting approach exists.
- Off-by-one errors in two-pointer loops — the loop condition (`left < right` vs `left <= right`) determines whether the middle element of an odd-length sequence is compared against itself, which matters for correctness at boundary cases.

## Interview Questions

1. **Why is indexing into an array O(1) but inserting at the front O(n)?**
   Indexing is a direct address calculation (`base + i * size`) that doesn't depend on how many elements exist. Inserting at the front requires shifting every existing element one position to the right to make room, so the work scales with the number of elements already present.

2. **What does "amortized O(1)" mean for `list.append()`, and why isn't it simply "O(1)"?**
   Most appends just write into pre-allocated space and are truly O(1). Occasionally the array is full and Python must allocate a larger block and copy every existing element (O(n)). Because Python over-allocates when resizing, these expensive events become rare enough that the *average* cost per append across many appends is still O(1) — but any single append could, in the worst case, trigger that O(n) copy.

3. **Why are Python strings immutable, and what's the practical consequence?**
   It's a language design choice that enables safe string sharing/interning and hashability (strings can be dictionary keys). The practical consequence is that any "modification" of a string actually creates a new string object — repeated concatenation in a loop (`result += char`) can silently become O(n^2) because each `+=` may build an entirely new string.

4. **Why does the anagram-check function reject strings of different lengths before doing any counting?**
   It's a cheap O(1) check that eliminates the vast majority of non-anagram pairs instantly, avoiding wasted O(n) counting work when the answer is already obviously "no" — a classic short-circuit / fail-fast optimization.

5. **What's the two-pointer technique, and why does it produce O(n) instead of O(n^2)?**
   Two index variables scan toward each other (or in some variants, in the same direction at different speeds) so that each position in the input is visited a constant number of times total across the whole algorithm, rather than being re-scanned by an inner loop for every outer iteration. Because total work is bounded by a constant multiple of `n`, it's O(n), not O(n^2).

## Suggested Next Lesson

[03 — Linked Lists](../03-Linked-Lists/README.md)
