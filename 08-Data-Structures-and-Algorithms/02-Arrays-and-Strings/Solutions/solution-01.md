# Solution 01 — Array Operation Complexity in Practice

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

`solution-01.py` empirically demonstrates the Snippet 2 vs. Snippet 3 gap by timing both approaches at growing sizes. One verified run:

```
--- Snippet 2 style: build via append() ---
n=  500:    0.189 ms
n= 1000:    0.059 ms
n= 2000:    0.118 ms
n= 4000:    0.204 ms

--- Snippet 3 style: build via insert(0, i) ---
n=  500:    0.117 ms
n= 1000:    0.441 ms
n= 2000:    1.364 ms
n= 4000:    5.912 ms

Input grew 8x.
append()-based build time grew 1.1x (expected: close to linear, ~8x)
insert(0,_)-based build time grew 50.7x (expected: much larger, quadratic-ish growth)
OK: front-insertion scales markedly worse than append, as O(n^2) vs O(n) predicts.
```

Note the append() timings don't grow smoothly (0.189 -> 0.059 -> 0.118 -> 0.204 ms) — at this scale the work is small enough that measurement noise and interpreter warm-up dominate, which is itself a useful lesson: O(n) is a guarantee about the trend, not a promise that every individual measurement will be monotonically increasing. The insert(0, _) timings, by contrast, grow unmistakably and consistently, because the underlying cost really is quadratic and large enough to dominate the noise floor.

## Classifications

**Snippet 1 — O(1).**
Both `data[0]` and `data[-1]` are direct index calculations regardless of list length — two O(1) operations in sequence is still O(1) (Big O drops the constant "2").

**Snippet 2 — O(n).**
`data.append(i)` is amortized O(1) per call. Running it `n` times gives `n * O(1) = O(n)` total — this is the standard, expected cost of building a list by appending.

**Snippet 3 — O(n^2).**
`data.insert(0, i)` is O(k) where `k` is the current length of `data` (every existing element shifts right by one). On the first call `data` is empty (O(0)), on the second it has 1 element (O(1)), ... on the 1000th call it has 999 elements (O(999)). Summing `0 + 1 + 2 + ... + 999` is a triangular number, which is `O(n^2)` — the loop count (n calls) times the average shift cost (which itself grows linearly with n) multiplies out to quadratic.

**Snippet 4 — O(n).**
`in` on an unsorted list performs a linear scan in the worst case. Even though `target = 999` happens to be the last element checked here, the *code* is still O(n) — Big O describes what the algorithm guarantees, not what happens to be true of one specific input (see Lesson 01, "best/average/worst case").

## Reflection Answers

1. Snippet 2 is O(n) because `append` only ever writes to the end (amortized O(1) per call, so `n` calls give O(n) total). Snippet 3 is O(n^2) because `insert(0, i)` must shift every *already-present* element one slot to the right every single time — and the number of already-present elements grows with every iteration, so the total shifting work across all `n` calls sums to a quadratic amount, not a linear one. The difference is entirely about *where* the insertion happens: the end requires no shifting, the front requires shifting everything.

2. **`collections.deque`** (covered in `04-Stacks-and-Queues`). A `deque` (double-ended queue) is implemented so that both `appendleft()` and `append()` are O(1), because it's structured internally to support efficient insertion/removal at both ends — unlike a plain `list`, which is optimized for the end only. Repeatedly inserting at the front of a `deque` stays O(n) overall (n calls x O(1) each), avoiding Snippet 3's O(n^2) blowup entirely.

## Common Pitfalls

- Assuming all four snippets are "just a loop over n items so they're all O(n)" — the complexity of each iteration's *body* matters just as much as the number of iterations; Snippet 3's body is not O(1).
- Missing that Snippet 4's O(n) classification holds even though `target` happens to be found on the very last comparison in this specific example — the classification describes the algorithm's guarantee across all possible inputs, not the lucky/unlucky outcome of one run.
- Forgetting that "O(1) k times is O(k)", i.e., not immediately recognizing why append-1000-times gives O(n) rather than staying "O(1) because each individual call is O(1)" — total complexity accumulates across the loop, one call's complexity does not describe the whole snippet.
