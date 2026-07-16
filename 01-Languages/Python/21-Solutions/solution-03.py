"""
Solution 03 - Validated Bank Account Class
See: ../20-Exercises/README.md#exercise-03--validated-bank-account-class-intermediate

Run with:
    python solution-03.py

Expected output:
    BankAccount(owner=Ada, balance=150.00)
    Deposit of -5 rejected: Deposit amount must be positive
    Withdrawal blocked: Cannot withdraw 500 - balance is only 150.0
    BankAccount(owner=Ada, balance=100.00)
"""


class InsufficientFundsError(Exception):
    pass


class BankAccount:
    def __init__(self, owner: str, balance: float = 0.0):
        self.owner = owner
        # Stored as "private" (_balance) so external code goes through the
        # deposit/withdraw methods instead of mutating balance directly and
        # skipping validation.
        self._balance = balance

    def deposit(self, amount: float) -> None:
        if amount <= 0:
            raise ValueError("Deposit amount must be positive")
        self._balance += amount

    def withdraw(self, amount: float) -> None:
        if amount <= 0:
            raise ValueError("Withdrawal amount must be positive")
        if amount > self._balance:
            raise InsufficientFundsError(
                f"Cannot withdraw {amount} - balance is only {self._balance}"
            )
        self._balance -= amount

    @property
    def balance(self) -> float:
        # Read-only from the outside: there is no balance.setter, so
        # `account.balance = 1000` raises AttributeError rather than
        # silently bypassing deposit/withdraw's validation.
        return self._balance

    def __str__(self) -> str:
        return f"BankAccount(owner={self.owner}, balance={self._balance:.2f})"


if __name__ == "__main__":
    account = BankAccount("Ada", 100.0)
    account.deposit(50.0)
    print(account)

    try:
        account.deposit(-5)
    except ValueError as e:
        print(f"Deposit of -5 rejected: {e}")

    try:
        account.withdraw(500)
    except InsufficientFundsError as e:
        print(f"Withdrawal blocked: {e}")

    account.withdraw(50.0)
    print(account)
