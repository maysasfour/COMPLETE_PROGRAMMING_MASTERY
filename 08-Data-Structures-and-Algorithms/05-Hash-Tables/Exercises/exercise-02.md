# Exercise 02 — Group Anagrams

[Back to lesson](../README.md)

## Task

Write a function `group_anagrams(words)` that groups words that are anagrams of each other, returning a dictionary where each key is a "signature" for a group and each value is the list of original words sharing that signature.

```python
group_anagrams(["eat", "tea", "tan", "ate", "nat", "bat"])
# -> {
#      "aet": ["eat", "tea", "ate"],
#      "ant": ["tan", "nat"],
#      "abt": ["bat"],
#    }
```

Hint: two words are anagrams of each other if and only if their letters, sorted, produce the same string (this is the same core idea as `is_anagram` from Lesson 02's `implementation.py`, applied here as a *grouping key* instead of a pairwise check). Use the sorted-letters string as a dictionary key, and `dict.setdefault(key, []).append(word)` (or `.get(key, [])` plus reassignment) to build up each group in a single O(n) pass over the word list — each word does O(k log k) work to sort its own letters (k = word length), but no word is ever compared directly against another word.

## Reflection Questions

1. Why is sorting each word's letters a valid way to detect anagrams? What would go wrong if you used the word's *length* alone as the key instead?
2. What is the overall time complexity of `group_anagrams` in terms of `n` (number of words) and `k` (max word length)? Which part of the work is the hash table doing, and which part is the sorting doing?
3. Dictionary insertion order in modern Python (3.7+) is preserved. Does that guarantee the *order of words within each group's list* matches their order in the input? Does it guarantee the order in which *groups* appear in the returned dictionary?

## Deliverable

A working `group_anagrams` function plus answers to the three reflection questions.
