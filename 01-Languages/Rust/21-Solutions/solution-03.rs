// solution-03.rs - Traits With Default Methods
// See: ../20-Exercises/README.md#exercise-03--traits-with-default-methods-intermediate
//
// Run with:
//     rustc solution-03.rs -o solution-03 && ./solution-03

trait Employee {
    fn name(&self) -> &str;
    fn base_salary(&self) -> f64;

    // Default method -- most employees get a 1.0x multiplier unless a
    // specific impl overrides it (Manager does, below).
    fn bonus_multiplier(&self) -> f64 {
        1.0
    }

    // A default method that calls BOTH a required method (base_salary) and
    // another default method (bonus_multiplier) -- proving default methods
    // compose with each other, not just with required ones. Overriding
    // bonus_multiplier changes what total_pay() computes even though
    // total_pay() itself is never redefined for Manager.
    fn total_pay(&self) -> f64 {
        self.base_salary() * self.bonus_multiplier()
    }
}

struct Engineer {
    name: String,
    base: f64,
}

impl Employee for Engineer {
    fn name(&self) -> &str {
        &self.name
    }
    fn base_salary(&self) -> f64 {
        self.base
    }
    // Accepts both defaults as-is: bonus_multiplier() == 1.0, total_pay()
    // == base_salary().
}

struct Manager {
    name: String,
    base: f64,
}

impl Employee for Manager {
    fn name(&self) -> &str {
        &self.name
    }
    fn base_salary(&self) -> f64 {
        self.base
    }
    // Overrides just the multiplier -- total_pay()'s default implementation
    // picks up this override automatically with zero changes to total_pay
    // itself, the same "override one piece, reuse the rest" trait default
    // methods are for.
    fn bonus_multiplier(&self) -> f64 {
        1.2
    }
}

fn main() {
    let eng = Engineer {
        name: "Ada".to_string(),
        base: 90_000.0,
    };
    let mgr = Manager {
        name: "Grace".to_string(),
        base: 110_000.0,
    };

    println!(
        "{}: base={:.2}, multiplier={:.2}, total_pay={:.2}",
        eng.name(),
        eng.base_salary(),
        eng.bonus_multiplier(),
        eng.total_pay()
    );
    println!(
        "{}: base={:.2}, multiplier={:.2}, total_pay={:.2}",
        mgr.name(),
        mgr.base_salary(),
        mgr.bonus_multiplier(),
        mgr.total_pay()
    );
}
