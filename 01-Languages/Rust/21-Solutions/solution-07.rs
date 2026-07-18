// solution-07.rs - Capstone: Bank Account With Result, a Custom Error, and Closures
// See: ../20-Exercises/README.md#exercise-07--capstone-bank-account-with-result-a-custom-error-and-closures-advanced
//
// Run with:
//     rustc solution-07.rs -o solution-07 && ./solution-07

use std::fmt;

#[derive(Debug)]
enum AccountError {
    InvalidAmount(f64),
    InsufficientFunds { requested: f64, available: f64 },
}

impl fmt::Display for AccountError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            AccountError::InvalidAmount(amt) => {
                write!(f, "invalid amount: {amt:.2} (must be positive)")
            }
            AccountError::InsufficientFunds { requested, available } => write!(
                f,
                "insufficient funds: requested {requested:.2}, available {available:.2}"
            ),
        }
    }
}

impl std::error::Error for AccountError {}

struct Account {
    balance: f64,
    history: Vec<String>,
}

impl Account {
    fn new() -> Self {
        Account { balance: 0.0, history: Vec::new() }
    }

    fn deposit(&mut self, amount: f64) -> Result<(), AccountError> {
        if amount <= 0.0 {
            return Err(AccountError::InvalidAmount(amount));
        }
        self.balance += amount;
        self.history
            .push(format!("deposit +{amount:.2} -> balance {:.2}", self.balance));
        Ok(())
    }

    fn withdraw(&mut self, amount: f64) -> Result<(), AccountError> {
        if amount <= 0.0 {
            return Err(AccountError::InvalidAmount(amount));
        }
        if amount > self.balance {
            return Err(AccountError::InsufficientFunds {
                requested: amount,
                available: self.balance,
            });
        }
        self.balance -= amount;
        self.history
            .push(format!("withdraw -{amount:.2} -> balance {:.2}", self.balance));
        Ok(())
    }

    // `?` propagates the FIRST failing operation immediately -- the loop
    // stops there, so anything after the failing entry in `ops` genuinely
    // never runs (proven in main() by checking history.len() and balance
    // after a deliberately-failing sequence).
    fn run_transactions(&mut self, ops: &[(&str, f64)]) -> Result<(), AccountError> {
        for (kind, amount) in ops {
            match *kind {
                "deposit" => self.deposit(*amount)?,
                "withdraw" => self.withdraw(*amount)?,
                other => panic!("unknown transaction kind in test data: {}", other),
            }
        }
        Ok(())
    }

    // A generic Fn(&str) -> bool predicate lets the caller define "what
    // counts" without total_by needing to know about deposits/withdrawals
    // specifically -- the same closure-as-parameter pattern as Exercise 06's
    // filter_items, applied to report-building instead of filtering.
    fn total_by<F: Fn(&str) -> bool>(&self, predicate: F) -> usize {
        self.history.iter().filter(|entry| predicate(entry)).count()
    }
}

fn main() {
    // --- successful sequence ---
    let mut acct = Account::new();
    let ops = [("deposit", 100.0), ("deposit", 50.0), ("withdraw", 30.0)];
    match acct.run_transactions(&ops) {
        Ok(()) => println!("Transactions succeeded. Balance: {:.2}", acct.balance),
        Err(e) => println!("Unexpected error: {e}"),
    }
    for line in &acct.history {
        println!("  {line}");
    }

    // --- sequence that fails partway through ---
    let mut acct2 = Account::new();
    let failing_ops = [
        ("deposit", 40.0),
        ("withdraw", 1000.0), // fails here: insufficient funds
        ("deposit", 999.0),   // must NOT run
    ];
    match acct2.run_transactions(&failing_ops) {
        Ok(()) => println!("Unexpected success"),
        Err(e) => println!("Expected failure partway through: {e}"),
    }
    println!(
        "acct2 after partial failure: balance={:.2}, history.len()={} (proves the trailing deposit never ran)",
        acct2.balance,
        acct2.history.len()
    );

    // --- closure-based reporting ---
    let deposits = acct.total_by(|entry| entry.starts_with("deposit"));
    let withdrawals = acct.total_by(|entry| entry.starts_with("withdraw"));
    println!("acct: {deposits} deposit(s), {withdrawals} withdrawal(s)");
}
