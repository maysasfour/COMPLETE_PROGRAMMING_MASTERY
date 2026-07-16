# Solution 01 — Closure-Based Bank Account

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `balance` is a plain `let` variable local to `createAccount`, not a property assigned to the returned object — so `acc.balance` is `undefined`, and the only way to read or change it is through the three methods, which close over it.
- Each call to `createAccount(...)` creates a brand-new `balance` variable and a brand-new set of methods closing over that specific variable — `acc` and `acc2` never share state, confirmed by depositing/withdrawing on `acc` and checking `acc2` stays untouched.
- Validation (`amount <= 0`, `amount > balance`) throws rather than silently clamping or ignoring, so calling code can't accidentally proceed with a corrupted balance.

## Verification

Ran with `node Solutions/solution-01.js`; actual output:

```
100
150
120
undefined
acc2 starts at: 0
acc (first account) unaffected: 120
Overdraw correctly rejected: Insufficient funds
```

Matches the exercise's expected output for the first four lines exactly, and confirms independent closures plus correct error handling on an overdraw attempt.
