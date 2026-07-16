# Solution 01 — A Typed Inventory with `Record` and `readonly`

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `Record<Category, Product[]>` forces `inventory` to have exactly the three keys `electronics`, `groceries`, `clothing`, each mapping to a `Product[]` — omitting any one of them is a compile error, verified separately against a near-identical `Record` example in this lesson's README.
- `Product.sku` is `readonly` since a SKU identifies a product and should never be reassigned after creation, while `name`/`price` remain mutable (e.g., a price update) — this mirrors the lesson's point that `readonly` is applied per-property, not to the whole object.
- `totalInventoryValue` uses `Object.values(inv)` to get an array of `Product[]` (one per category) without needing to know the category names at all, then reduces over that with `totalValue` — this means adding a fourth category later (if `Category` grew) would automatically be included in the grand total with no changes needed to `totalInventoryValue` itself.

## Verification

Ran with `tsc Solutions/solution-01.ts --strict --target ES2022 --skipLibCheck && node Solutions/solution-01.js`; actual output:

```
electronics total: 79.98
groceries total: 8.5
clothing total: 60
grand total: 148.48000000000002
hand-summed expected total: 148.48000000000002
match: true
```

The grand total matches a hand-summed total of all five products' prices exactly (both computed the same floating-point value, `148.48000000000002`, confirming the reduce-based computation is correct, including the same floating-point representation quirk a manual sum would also produce).
