# 05 — Hash Tables

[Back to module overview](../README.md) | [Previous: Stacks and Queues](../04-Stacks-and-Queues/README.md)

## Beginner: What a Hash Table Is

A **hash table** (also called a hash map) stores key-value pairs and gives you near-instant lookup, insertion, and deletion by key — instead of scanning every element like a list, you jump almost straight to where the value lives. The mechanism that makes this possible is a **hash function**: it takes a key (a string, a number, anything hashable) and converts it into an integer, which is then reduced to a valid index into a fixed-size internal array (the array of **buckets**).

```
key "language" --hash()--> big integer --% bucket_count--> bucket index 3
                                                              |
                                                              v
                                                    buckets[3] = [("language", "Python")]
```

`implementation.py` builds this from scratch as a `HashTable` class, then shows the same ideas using Python's built-in `dict` — which is the production-grade version of exactly this concept.

## Beginner: Why Hashing Beats Scanning

A linked list or unsorted array needs O(n) time to find a value by key — every element might need checking. A hash table sidesteps that by computing *where* the value should be, rather than searching for it. As long as the hash function spreads keys evenly across buckets, each bucket stays short, and checking a short bucket is effectively O(1) regardless of how many total keys are stored.

| Operation | Unsorted Array/List | Hash Table (average case) |
|---|---|---|
| Insert | O(1) (append) or O(n) (if uniqueness must be checked) | O(1) |
| Lookup by key | O(n) | O(1) |
| Delete by key | O(n) | O(1) |
| Search by value (not key) | O(n) | O(n) — hashing only helps when you have the key |

## Intermediate: Collisions and Chaining

Two different keys can hash to the same bucket index — this is a **collision**, and it is not a bug, it is a mathematical certainty once you have more possible keys than buckets (the pigeonhole principle). A hash table must have a strategy for handling it. `implementation.py` uses **separate chaining**: each bucket holds a *list* of `(key, value)` pairs, so if two keys collide, they simply both live in the same bucket's list, and `get`/`put`/`delete` scan that short list to find the exact key they want (checking `key ==`, not just relying on the hash matching).

`demonstrate_collisions()` in `implementation.py` deliberately uses a tiny `bucket_count=3` with 5 keys, forcing visible collisions — with only 3 buckets and 5 keys, at least one bucket *must* hold 2+ keys. This is the direct, hands-on version of the pigeonhole principle rather than an abstract claim about it.

The alternative collision strategy (not implemented here) is **open addressing** — instead of storing a list per bucket, you probe forward to the next empty slot when your first-choice bucket is taken. Python's real `dict` uses open addressing internally, not chaining, but chaining is easier to learn from because it makes the collision itself directly visible as "there's more than one item in this bucket."

## Advanced: Average Case O(1) vs. Worst Case O(n)

The O(1) claim for hash table operations is an *average case*, not a guarantee — this is why the complexity table above says "average case." If the hash function is bad (or if an attacker deliberately chooses keys designed to collide), every key could land in the same bucket, degrading every operation to O(n) because now every lookup has to scan one giant chain. This is precisely why:

- Production hash tables (like Python's `dict`) use hash functions carefully designed to spread real-world keys evenly, and add randomization (`PYTHONHASHSEED`) specifically to prevent attackers from crafting collision-heavy input against a public-facing service (a real, documented attack class called "hash flooding").
- Production hash tables **resize**: as more keys are added, the bucket count grows (typically doubling), keeping the average chain length short. `implementation.py`'s `HashTable` does *not* implement resizing — its `bucket_count` is fixed at construction — which is a deliberate simplification to keep the collision mechanism visible; see Common Mistakes below.

## How to Run

```bash
cd 08-Data-Structures-and-Algorithms/05-Hash-Tables
python implementation.py
```

## Verified Output

```
=== Hash table from scratch: put, get, delete, contains ===
get('name') -> Ada
get('language') -> Python
contains('year') -> True
contains('missing') -> False
size -> 3
After put('name', 'Grace') [update]: get('name') -> Grace, size -> 3
After delete('year'): contains('year') -> False, size -> 2
get('year') after delete raises KeyError: 'year'

=== Demonstrating collisions with a deliberately small bucket count ===
Inserted keys: ['apple', 'banana', 'cherry', 'date', 'elderberry']
bucket_count = 3, so collisions are likely with 5 keys.
  bucket[0] -> ['banana', 'date', 'elderberry']
  bucket[1] -> ['cherry']
  bucket[2] -> ['apple']

=== Equivalent task using Python's built-in dict ===
Word frequency count: {'the': 3, 'quick': 1, 'fox': 2, 'lazy': 1}
```

Note: the exact bucket assignment in the collision demo depends on Python's `hash()` for strings, which is randomized per-process by default (via `PYTHONHASHSEED`) — the bucket *indices* your run shows may differ from the ones above, but the key fact being demonstrated (multiple keys landing in the same bucket with only 3 buckets for 5 keys) will always hold.

## Summary

- A hash table converts a key into a bucket index via a hash function, giving average-case O(1) insert/lookup/delete by key.
- Collisions (different keys, same bucket index) are mathematically guaranteed once keys outnumber buckets, and must be handled — this implementation uses separate chaining (a list per bucket).
- The O(1) average case degrades to O(n) worst case if the hash function distributes keys poorly or an attacker deliberately engineers collisions.
- Python's built-in `dict` is the production-grade version of this exact idea: same concept, open addressing instead of chaining, written in C, with dynamic resizing.

## Key Terms

- **Hash function** — a function that converts a key into an integer, used to compute a bucket index.
- **Bucket** — one slot in the hash table's internal array; may hold zero, one, or (after a collision) multiple key-value pairs.
- **Collision** — when two different keys hash to the same bucket index.
- **Separate chaining** — a collision-handling strategy where each bucket holds a list of all key-value pairs that hashed to it.
- **Open addressing** — an alternative collision-handling strategy (used by Python's real `dict`) that probes for the next empty slot instead of storing a list per bucket.
- **Load factor** — the ratio of stored items to bucket count; production hash tables resize (grow buckets) once this ratio crosses a threshold, to keep chains short.

## Common Mistakes

- Assuming hash table operations are O(1) *always* — they are O(1) *on average*, given a reasonably distributed hash function and low load factor; a bad hash function or adversarial input collapses this to O(n).
- Forgetting to check key equality (`existing_key == key`) when scanning a bucket — matching hash values only tells you two keys landed in the *same bucket*, not that they're the *same key*; every lookup in `implementation.py` explicitly re-checks equality for exactly this reason.
- Using a mutable object as a dictionary key (e.g., a list) — Python's real `dict` explicitly disallows this because if the key's contents changed after insertion, its hash would change too, and the entry would become unreachable at its original bucket forever. This is why Python only allows *hashable* (effectively immutable) types as dict keys.
- Assuming this implementation resizes as it grows — it doesn't; `bucket_count` is fixed at construction, so heavy insertion into a small `HashTable` here will degrade toward O(n) per operation as chains grow, unlike Python's real `dict`, which resizes automatically.

## Interview Questions

1. **Why is hash table lookup O(1) on average but O(n) in the worst case?**
   Average case assumes the hash function spreads keys roughly evenly across buckets, keeping each bucket's chain short and roughly constant-length regardless of total table size. Worst case happens when many/all keys collide into the same bucket (due to a poor hash function, a tiny bucket count relative to key count, or deliberately adversarial input) — then a lookup degenerates into scanning one long chain, which is O(n).

2. **What is a collision, and why is it unavoidable in general?**
   A collision is when two different keys hash to the same bucket index. It's unavoidable once there are more possible keys than buckets, by the pigeonhole principle: if you have more items than containers, at least one container must hold more than one item.

3. **Explain separate chaining as a collision resolution strategy.**
   Each bucket holds a list ("chain") of all `(key, value)` pairs that hashed to that index, rather than a single value. Insertion appends to the appropriate bucket's list (after checking whether the key already exists, to update rather than duplicate); lookup hashes to find the right bucket, then linearly scans that bucket's (usually short) list checking for an exact key match.

4. **Why can't you use a list (mutable) as a dictionary key in Python?**
   Because a key's hash value is computed once when it's inserted and used to determine its bucket; if the key were mutable and its contents changed afterward, its hash would change too, but the entry would still be sitting in the *old* bucket — making it permanently unfindable via the new hash. Python enforces this by only allowing hashable types (which are, by convention, immutable) as dict keys.

5. **How would you improve this `HashTable` implementation to keep it fast as it grows?**
   Add dynamic resizing: track the load factor (`size / bucket_count`), and once it crosses a threshold (commonly ~0.7), allocate a new, larger bucket array (often double the size) and re-insert every existing key-value pair into it (a process called rehashing). This keeps average chain length — and therefore average operation cost — roughly constant even as the table grows, which is exactly what Python's real `dict` does automatically.

## Suggested Next Lesson

[06 — Sorting Algorithms](../06-Sorting-Algorithms/README.md)
