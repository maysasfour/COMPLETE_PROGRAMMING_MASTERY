// solution-01.js - closure-based bank account with private balance.

function createAccount(initialBalance = 0) {
  let balance = initialBalance; // private: lives only in this closure, never exposed as a property

  return {
    deposit(amount) {
      if (amount <= 0) throw new Error("Deposit amount must be positive");
      balance += amount;
      return balance;
    },
    withdraw(amount) {
      if (amount <= 0) throw new Error("Withdrawal amount must be positive");
      if (amount > balance) throw new Error("Insufficient funds");
      balance -= amount;
      return balance;
    },
    getBalance() {
      return balance;
    },
  };
}

const acc = createAccount(100);
console.log(acc.getBalance()); // 100
acc.deposit(50);
console.log(acc.getBalance()); // 150
acc.withdraw(30);
console.log(acc.getBalance()); // 120
console.log(acc.balance);      // undefined -- not a real property on the returned object

// Independent state per account:
const acc2 = createAccount(0);
console.log("acc2 starts at:", acc2.getBalance());
console.log("acc (first account) unaffected:", acc.getBalance());

try {
  acc.withdraw(1000);
} catch (err) {
  console.log("Overdraw correctly rejected:", err.message);
}
