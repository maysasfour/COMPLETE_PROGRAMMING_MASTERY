# Exercise 01 — A Typed Inventory with `Record` and `readonly`

[Back to lesson](../README.md)

## Task

Model a small shop inventory:

- An interface `Product` with `readonly sku: string`, `name: string`, and `price: number`.
- A literal union `Category = "electronics" | "groceries" | "clothing"`.
- A `Record<Category, Product[]>` named `inventory`, with at least one product in each category.
- A function `totalValue(products: Product[]): number` returning the sum of `price` across all products, using `.reduce()`.
- A function `totalInventoryValue(inventory: Record<Category, Product[]>): number` that sums `totalValue(...)` across every category, using `Object.values(inventory)`.

## Constraints

- `inventory` must genuinely be typed `Record<Category, Product[]>` — omitting a category should be a compile error (you don't need to demonstrate the failure in your solution file, just structure it so it would occur).
- No `as` assertions.

## Starter Code

```ts
interface Product {
  readonly sku: string;
  name: string;
  price: number;
}

type Category = "electronics" | "groceries" | "clothing";

const inventory: Record<Category, Product[]> = {
  // fill in all three categories
};

function totalValue(products: Product[]): number {
  return products.reduce((sum, p) => sum + p.price, 0);
}

function totalInventoryValue(inv: Record<Category, Product[]>): number {
  return Object.values(inv).reduce((sum, products) => sum + totalValue(products), 0);
}
```

## Expected Output

For a reasonable inventory (a few products per category, prices summing to some total), `totalInventoryValue(inventory)` should equal the sum of every individual product's `price` across all three categories — verify by hand-summing your chosen prices and comparing.

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.ts](../Solutions/solution-01.ts).
