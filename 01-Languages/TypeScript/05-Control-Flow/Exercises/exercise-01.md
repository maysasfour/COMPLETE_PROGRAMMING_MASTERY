# Exercise 01 — A Discriminated `PaymentMethod` Union with Exhaustive Handling

[Back to lesson](../README.md)

## Task

Model a payment system with a discriminated union `PaymentMethod`:

- `CreditCard`: `{ kind: "credit_card"; last4: string }`
- `PayPal`: `{ kind: "paypal"; email: string }`
- `BankTransfer`: `{ kind: "bank_transfer"; iban: string }`

Write a function `describePayment(method: PaymentMethod): string` that returns a human-readable description for each variant (e.g., `"Credit card ending in 1234"`), using a `switch` on `kind` with an exhaustiveness check (`never`-typed `default`) so adding a fourth payment method later without updating this function fails to compile.

## Constraints

- The exhaustiveness check must actually be present and must actually be provable to fail if a new variant is added (you don't need to add a fourth variant to this exercise — just structure the `switch` so it would fail to compile if one were added without a matching case).
- No `as`/`!` assertions anywhere in the solution — use narrowing only.

## Starter Code

```ts
interface CreditCard { kind: "credit_card"; last4: string }
interface PayPal { kind: "paypal"; email: string }
interface BankTransfer { kind: "bank_transfer"; iban: string }
type PaymentMethod = CreditCard | PayPal | BankTransfer;

function describePayment(method: PaymentMethod): string {
  switch (method.kind) {
    // your cases here
  }
}
```

## Expected Output

```
Credit card ending in 1234
PayPal account: ada@example.com
Bank transfer to DE00 1234 5678
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.ts](../Solutions/solution-01.ts).
