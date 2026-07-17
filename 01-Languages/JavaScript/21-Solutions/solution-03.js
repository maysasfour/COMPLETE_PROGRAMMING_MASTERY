// solution-03.js - Validated Bank Account Class
// See: ../20-Exercises/README.md#exercise-03--validated-bank-account-class-intermediate
//
// Run with:
//   node solution-03.js

class InsufficientFundsError extends Error {
  constructor(message) {
    super(message);
    // Without this, `err.name` would read "Error", not the subclass name -
    // instanceof still works without it, but logs/messages are clearer with it.
    this.name = "InsufficientFundsError";
  }
}

class BankAccount {
  // A real private field (Lesson 11) - unlike a "_balance" convention,
  // #balance is genuinely inaccessible from outside the class, even via
  // account["#balance"] or Object.keys().
  #balance;

  constructor(owner, balance = 0) {
    this.owner = owner;
    this.#balance = balance;
  }

  get balance() {
    return this.#balance;
  }

  deposit(amount) {
    if (amount <= 0) throw new RangeError("Deposit amount must be positive");
    this.#balance += amount;
  }

  withdraw(amount) {
    if (amount <= 0) throw new RangeError("Withdrawal amount must be positive");
    if (amount > this.#balance) {
      throw new InsufficientFundsError(
        `Cannot withdraw ${amount} - balance is only ${this.#balance}`
      );
    }
    this.#balance -= amount;
  }

  toString() {
    return `BankAccount(owner=${this.owner}, balance=${this.#balance.toFixed(2)})`;
  }
}

const account = new BankAccount("Ada", 100);
account.deposit(50);
console.log(account.toString());

try {
  account.deposit(-5);
} catch (err) {
  console.log(`Deposit of -5 rejected: ${err.message}`);
}

try {
  account.withdraw(500);
} catch (err) {
  console.log(`Withdrawal blocked: ${err.message}`);
}

account.withdraw(50);
console.log(account.toString());

// Confirms balance really is read-only from outside: this line does NOT
// throw (assigning to an object without a setter for that property is a
// silent no-op in non-strict mode / a plain property shadow attempt), but
// the getter still returns the real #balance afterward, proving the
// private field itself was never touched.
account.balance = 999999;
console.log(`After attempted external overwrite, balance getter still reports: ${account.balance}`);
