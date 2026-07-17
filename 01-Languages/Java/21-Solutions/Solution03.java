class InsufficientFundsException extends Exception {
    public InsufficientFundsException(String message) {
        super(message);
    }
}

class BankAccount {
    private final String owner;
    private double balance;

    public BankAccount(String owner, double balance) {
        this.owner = owner;
        this.balance = balance;
    }

    public void deposit(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Deposit amount must be positive");
        }
        balance += amount;
    }

    public void withdraw(double amount) throws InsufficientFundsException {
        if (amount <= 0) {
            throw new IllegalArgumentException("Withdrawal amount must be positive");
        }
        if (amount > balance) {
            throw new InsufficientFundsException(
                    "Cannot withdraw " + amount + " - balance is only " + balance);
        }
        balance -= amount;
    }

    public double getBalance() {
        return balance;
    }

    @Override
    public String toString() {
        return String.format("BankAccount(owner=%s, balance=%.2f)", owner, balance);
    }
}

public class Solution03 {
    public static void main(String[] args) {
        BankAccount account = new BankAccount("Ada", 100.0);
        account.deposit(50.0);
        System.out.println(account);

        try {
            account.deposit(-5);
        } catch (IllegalArgumentException e) {
            System.out.println("Deposit of -5 rejected: " + e.getMessage());
        }

        try {
            account.withdraw(500);
        } catch (InsufficientFundsException e) {
            System.out.println("Withdrawal blocked: " + e.getMessage());
        }

        try {
            account.withdraw(50);
        } catch (InsufficientFundsException e) {
            System.out.println("Unexpected: " + e.getMessage());
        }
        System.out.println(account);
    }
}
