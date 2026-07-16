// example.ts - private/protected (compile-time only), interfaces, abstract classes.

console.log("--- private is compile-time only ---");
class BankAccount {
  private balance: number;

  constructor(initialBalance: number) {
    this.balance = initialBalance;
  }

  deposit(amount: number): void {
    this.balance += amount;
  }

  getBalance(): number {
    return this.balance;
  }
}

const account = new BankAccount(100);
account.deposit(50);
console.log("getBalance():", account.getBalance());
// account.balance; // would fail to COMPILE

// Deliberately proving `private` has NO runtime enforcement, via an explicit `as any` bypass:
console.log(
  "Bypassed via `as any` (proves private is compile-time only):",
  (account as any).balance
);

console.log("\n--- interface implemented by a class ---");
interface Shape {
  area(): number;
  perimeter(): number;
}

class Rectangle implements Shape {
  constructor(private width: number, private height: number) {}

  area(): number {
    return this.width * this.height;
  }

  perimeter(): number {
    return 2 * (this.width + this.height);
  }
}

const rect = new Rectangle(4, 5);
console.log("rect.area():", rect.area());
console.log("rect.perimeter():", rect.perimeter());

console.log("\n--- abstract class with a concrete subclass ---");
abstract class Employee {
  constructor(protected name: string) {}

  abstract calculatePay(): number;

  describe(): string {
    return `${this.name} earns ${this.calculatePay()}`;
  }
}

class SalariedEmployee extends Employee {
  constructor(name: string, private annualSalary: number) {
    super(name);
  }
  calculatePay(): number {
    return this.annualSalary / 12;
  }
}

const employee = new SalariedEmployee("Ada", 120000);
console.log(employee.describe());
// new Employee("Someone"); // would fail to COMPILE -- cannot instantiate an abstract class
