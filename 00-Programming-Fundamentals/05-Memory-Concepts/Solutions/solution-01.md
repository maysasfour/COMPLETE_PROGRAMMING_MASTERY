# Solution 01 — Predict the Caller's View

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Full runnable code is in `solution-01.py`. Verified output:

```
a() mutates in place -> record: {'status': 'updated'}
b() rebinds the local name -> record: {'status': 'new'}
c() surprisingly ALSO mutates in place -> values: [1, 2, 3, 4]
d() mutates in place -> values: [1, 2, 3, 4]
```

## Explanations

**a() — `record: {'status': 'updated'}`.**
`data["status"] = "updated"` mutates the dict object in place. `data` and `record` are two names bound to the same heap-allocated dict, so the change is visible through either.

**b() — `record: {'status': 'new'}`.**
`data = {"status": "updated"}` does not mutate anything — it rebinds the *local* name `data` to point at a brand-new dict object. `record` was never touched; it still points at the original object.

**c() — `values: [1, 2, 3, 4]` (the trap).**
This is the subtle one. For lists, `+=` is not plain reassignment — Python calls `list.__iadd__`, which mutates the list **in place** (equivalent to `.extend()`) and then rebinds `data` to that same, now-mutated object. So even though `+=` looks structurally identical to the rebinding in `b()`, the actual behavior depends on whether the type implements in-place mutation (`__iadd__`). Lists do; plain ints and strings don't, which is why `n += 1` on an int parameter (see `example.py`'s `modify_number`) does *not* affect the caller — ints have no `__iadd__`, so `+=` on an int falls back to `n = n + 1`, a pure rebind.

**d() — `values: [1, 2, 3, 4]`.**
`.extend()` is unambiguously an in-place mutation method with no reassignment ambiguity at all — the clearest and least surprising way to grow a list you received as a parameter.

## Common Pitfalls

- Assuming `+=` always behaves like plain reassignment (as it does for immutable types) — for mutable types with `__iadd__`, it mutates in place, which surprises people who reason about it purely from the "assignment operator" name.
- Concluding from `b()` that dicts/lists are "safe" from being changed by functions — they're not; only *rebinding* the parameter is safe. Any in-place method call or item assignment on the same object still mutates the caller's data.
- Using `+=` on a mutable default argument, compounding two pitfalls from this module at once (see Lesson 04's mutable default argument mistake) — always be explicit about whether you intend a mutation or a fresh object.
