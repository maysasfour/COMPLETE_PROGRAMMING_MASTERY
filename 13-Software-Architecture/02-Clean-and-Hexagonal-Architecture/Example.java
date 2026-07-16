// Example.java - Clean/Hexagonal Architecture: the domain (business logic) layer
// depends only on abstractions ("ports") it defines itself; concrete infrastructure
// ("adapters") implement those ports, never the other way around. Demonstrated with
// a real, verified limitation caused by the domain depending directly on a concrete
// infrastructure class, then a fix.

public class Example {

    // ============================================================
    // VIOLATION: the domain's DiscountService is hard-wired directly to a
    // CONCRETE infrastructure class. This is the reverse of Dependency
    // Inversion (see 11-Design-Principles) applied at the architecture level:
    // business logic now depends on infrastructure, not the other way around.
    // ============================================================
    static class MySQLDatabaseViolation {
        // Pretend this represents a real, concrete database connection --
        // its rate is fixed by whatever is actually stored in "the real database."
        double fetchDiscountRate() { return 0.10; }
    }

    static class DiscountServiceViolation {
        // Hard-wired: DiscountService cannot be exercised with any rate other
        // than whatever MySQLDatabaseViolation happens to return, because it
        // instantiates and depends on that CONCRETE class directly.
        private final MySQLDatabaseViolation db = new MySQLDatabaseViolation();

        double applyDiscount(double amount) {
            return amount - (amount * db.fetchDiscountRate());
        }
    }

    // ============================================================
    // FIX: the domain defines a PORT (an interface) expressing exactly what it
    // needs. Infrastructure (MySQLDiscountRateAdapter) implements that port;
    // the domain never references the concrete infrastructure class at all.
    // ============================================================

    // The PORT -- defined by and for the domain layer.
    interface DiscountRatePort {
        double fetchDiscountRate();
    }

    // A real infrastructure ADAPTER implementing the port.
    static class MySQLDiscountRateAdapter implements DiscountRatePort {
        public double fetchDiscountRate() { return 0.10; }
    }

    // A SECOND adapter -- e.g., representing a promotional-rate scenario, or a
    // fake used for testing. Notice: this required ZERO changes to the domain.
    static class PromotionalDiscountRateAdapter implements DiscountRatePort {
        public double fetchDiscountRate() { return 0.20; }
    }

    static class DiscountService {
        private final DiscountRatePort ratePort; // depends ONLY on the port -- an abstraction the domain itself defines
        DiscountService(DiscountRatePort ratePort) { this.ratePort = ratePort; }

        double applyDiscount(double amount) {
            return amount - (amount * ratePort.fetchDiscountRate());
        }
    }

    public static void main(String[] args) {
        System.out.println("=== Clean/Hexagonal Architecture: domain depending on infrastructure vs. a port ===");

        System.out.println("Violation: DiscountServiceViolation is hard-wired to a concrete database class.");
        DiscountServiceViolation violationService = new DiscountServiceViolation();
        System.out.printf("  $100 order with the standard rate: $%.2f%n", violationService.applyDiscount(100));
        System.out.println("  LIMITATION: to test/exercise a promotional 20% rate scenario, you would have to");
        System.out.println("  actually MODIFY MySQLDatabaseViolation itself -- there is no other way in, because");
        System.out.println("  DiscountServiceViolation has a hard, compiled-in dependency on that ONE concrete class.");

        System.out.println("\nFixed: DiscountService depends only on the DiscountRatePort abstraction.");
        DiscountService standardService = new DiscountService(new MySQLDiscountRateAdapter());
        DiscountService promoService = new DiscountService(new PromotionalDiscountRateAdapter());
        System.out.printf("  $100 order with the standard rate:     $%.2f%n", standardService.applyDiscount(100));
        System.out.printf("  $100 order with the promotional rate:  $%.2f  <- exercised with ZERO changes to DiscountService or MySQLDiscountRateAdapter%n",
                promoService.applyDiscount(100));
    }
}
