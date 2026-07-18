/* Exercise 3: struct-based "object" -- a bank account, using the
   struct-plus-functions-taking-a-pointer-first pattern idiomatic to C
   (the same shape as sqlite3*'s C API). No exceptions (Lesson 09):
   errors are signaled via return codes. */
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>

typedef struct {
    char owner[64];
    double balance;
} Account;

typedef enum {
    ACCOUNT_OK = 0,
    ACCOUNT_INSUFFICIENT_FUNDS = -1
} AccountResult;

static void accountInit(Account* acc, const char* owner, double startingBalance) {
    strncpy(acc->owner, owner, sizeof(acc->owner) - 1);
    acc->owner[sizeof(acc->owner) - 1] = '\0';
    acc->balance = startingBalance;
}

static void accountDeposit(Account* acc, double amount) {
    acc->balance += amount;
}

static AccountResult accountWithdraw(Account* acc, double amount) {
    if (amount > acc->balance) {
        return ACCOUNT_INSUFFICIENT_FUNDS;
    }
    acc->balance -= amount;
    return ACCOUNT_OK;
}

static void accountPrint(const Account* acc) {
    printf("%s: balance = %.2f\n", acc->owner, acc->balance);
}

int main(void) {
    Account acc;
    accountInit(&acc, "Mays", 100.0);
    accountPrint(&acc);

    accountDeposit(&acc, 50.0);
    accountPrint(&acc);

    AccountResult r1 = accountWithdraw(&acc, 30.0);
    printf("withdraw 30.0 -> %s\n", (r1 == ACCOUNT_OK) ? "OK" : "FAILED");
    accountPrint(&acc);

    AccountResult r2 = accountWithdraw(&acc, 1000.0);
    printf("withdraw 1000.0 -> %s\n", (r2 == ACCOUNT_OK) ? "OK" : "FAILED (insufficient funds)");
    accountPrint(&acc);

    return 0;
}
