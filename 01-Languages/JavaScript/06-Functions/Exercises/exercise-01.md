# Exercise 01 — A Closure-Based Bank Account

[Back to lesson](../README.md)

## Task

Write a factory function `createAccount(initialBalance = 0)` that returns an object with three methods, using a closure to keep the balance private (not directly accessible from outside):

- `deposit(amount)` — adds `amount` to the balance (throws if `amount <= 0`), returns the new balance.
- `withdraw(amount)` — subtracts `amount` from the balance (throws if `amount <= 0` or if it would make the balance negative), returns the new balance.
- `getBalance()` — returns the current balance without allowing external code to modify it directly.

## Constraints

- The balance itself must **not** be a property on the returned object (e.g. no `account.balance`) — it must live only in the closure, accessible solely through the three methods.
- Use regular `function` or arrow functions for the methods as you see fit, but the factory itself must be a plain function that can be called multiple times to produce independent accounts.

## Starter Code

```js
function createAccount(initialBalance = 0) {
  let balance = initialBalance;
  return {
    deposit(amount) { /* ... */ },
    withdraw(amount) { /* ... */ },
    getBalance() { /* ... */ },
  };
}
```

## Expected Output

```js
const acc = createAccount(100);
console.log(acc.getBalance()); // 100
acc.deposit(50);
console.log(acc.getBalance()); // 150
acc.withdraw(30);
console.log(acc.getBalance()); // 120
console.log(acc.balance);      // undefined -- not directly accessible
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.js](../Solutions/solution-01.js).
