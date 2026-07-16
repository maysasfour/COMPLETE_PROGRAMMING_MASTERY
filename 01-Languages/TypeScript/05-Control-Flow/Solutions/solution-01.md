# Solution 01 — A Discriminated `PaymentMethod` Union

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- Each interface shares the literal-typed `kind` field, making `PaymentMethod` a discriminated union — the `switch (method.kind)` lets TypeScript narrow `method` to the exact matching interface inside each `case`, so `method.last4`/`method.email`/`method.iban` are all accessed without any assertion.
- The `default` branch assigns `method` to a variable explicitly typed `never`. Since every real member of `PaymentMethod` is already handled by an earlier `case`, `method` has nothing left to be inside `default` — compatible with `never`. Adding a fourth payment method to the union without a matching `case` would leave that new variant unhandled, making `method` in `default` no longer assignable to `never`, and the file would fail to compile.
- No `as`/`!` were used anywhere — every narrowing came from the `switch` on the discriminant field alone.

## Verification

Ran with `tsc Solutions/solution-01.ts --strict --target ES2022 --skipLibCheck && node Solutions/solution-01.js`; actual output:

```
Credit card ending in 1234
PayPal account: ada@example.com
Bank transfer to DE00 1234 5678
```

Matches the exercise's expected output exactly. The exhaustiveness check's real effect was separately confirmed (not just claimed) by adding a fourth `Triangle`-style variant to a throwaway copy of a similar union without updating its switch, which reproducibly failed to compile with `error TS2322: Type '...' is not assignable to type 'never'`.
