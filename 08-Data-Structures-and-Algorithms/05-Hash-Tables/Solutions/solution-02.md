# Solution 02 — Group Anagrams

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-02.md)

Runnable code lives in `solution-02.py`. Verified output:

```
group_anagrams(['eat', 'tea', 'tan', 'ate', 'nat', 'bat'])
  'aet' -> ['eat', 'tea', 'ate']
  'ant' -> ['tan', 'nat']
  'abt' -> ['bat']
```

## Explanation

`group_anagrams` computes a **signature** for each word by sorting its letters into a canonical string (`"".join(sorted(word))`) — anagrams, by definition, contain exactly the same letters, so sorting always produces an identical string for every word in the same anagram group, and a different string for words that aren't anagrams of each other. That signature is used as a dictionary key; `groups.setdefault(signature, []).append(word)` either creates a new empty list for a signature seen for the first time, or appends to the existing list if the signature has already appeared. One pass over the input words builds every group.

## Reflection Answers

1. **Why sorted letters, not length, detect anagrams.** Sorting reduces a word to a canonical form where every anagram of it produces the *identical* string — `"eat"`, `"tea"`, and `"ate"` all sort to `"aet"`. Length alone is far too weak a signature: `"eat"` (an anagram group) and `"tax"` (not an anagram of "eat") are both length 3 and would be wrongly grouped together, since many unrelated words share the same length without sharing the same letters.

2. **Overall complexity.** For each of the `n` words, sorting its letters costs O(k log k) where `k` is the word's length, so building all signatures costs O(n · k log k) total. The hash table (`dict`) part contributes O(1) average-case work per word for the `setdefault`/`append` — that's where the "one pass over n words" O(n) comes from. The sorting is the more expensive part per word; the hash table is what makes assembling the *groups* themselves cheap instead of requiring a comparison against every previously seen group.

3. **Order guarantees.** Yes to the first question: within a single group's list, words are appended in the exact order they're encountered while iterating the input, since `.append()` always adds to the end — so a group's list is a subsequence of the input in original order. Not fully guaranteed by "same order as input" for the *groups* dictionary as a whole in a way you should rely on for correctness, but in practice: since Python 3.7 dicts preserve *insertion* order, groups appear in the returned dict in the order their signature was *first* encountered while scanning — so it does happen to be deterministic and input-order-derived, but that's an implementation detail of dict ordering, not a property of "anagram grouping" as a concept, so don't design logic elsewhere that depends on group order having intrinsic meaning.

## Common Pitfalls

- Using an unsorted representation (like a `set` of letters) as the signature instead of a sorted string — a set collapses duplicate letters, so `"aab"` and `"ab"` would incorrectly get the same signature even though they aren't anagrams of each other (different letter counts).
- Comparing words pairwise (nested loops) instead of grouping by signature — correct, but O(n^2) instead of O(n · k log k), throwing away the entire benefit of hashing.
- Forgetting `setdefault`'s default only gets created the first time a key appears — using `groups[signature] = [word]` unconditionally would overwrite (not extend) any existing group every time.
