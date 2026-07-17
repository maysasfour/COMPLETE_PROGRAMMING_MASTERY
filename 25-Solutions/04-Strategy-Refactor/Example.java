import java.util.Map;

public class Example {

    // VIOLATION: adding "international" requires EDITING this existing method.
    static class ShippingCostCalculatorViolation {
        double calculate(String method, double weightKg) {
            if (method.equals("standard")) return weightKg * 2.0;
            else if (method.equals("express")) return weightKg * 5.0;
            else if (method.equals("overnight")) return weightKg * 10.0;
            // To add "international" here, this method's source MUST be edited.
            throw new IllegalArgumentException("Unknown method");
        }
    }

    // FIX: Strategy pattern.
    interface ShippingStrategy {
        double calculate(double weightKg);
    }
    static class StandardShipping implements ShippingStrategy {
        public double calculate(double weightKg) { return weightKg * 2.0; }
    }
    static class ExpressShipping implements ShippingStrategy {
        public double calculate(double weightKg) { return weightKg * 5.0; }
    }
    static class OvernightShipping implements ShippingStrategy {
        public double calculate(double weightKg) { return weightKg * 10.0; }
    }
    // NEW requirement: added as a NEW class, zero changes to anything above.
    static class InternationalShipping implements ShippingStrategy {
        public double calculate(double weightKg) { return weightKg * 15.0 + 20.0; }
    }

    static class ShippingCostCalculator {
        private final Map<String, ShippingStrategy> strategies = Map.of(
                "standard", new StandardShipping(),
                "express", new ExpressShipping(),
                "overnight", new OvernightShipping(),
                "international", new InternationalShipping() // just a new map entry
        );

        double calculate(String method, double weightKg) {
            ShippingStrategy strategy = strategies.get(method);
            if (strategy == null) throw new IllegalArgumentException("Unknown method");
            return strategy.calculate(weightKg);
        }
    }

    public static void main(String[] args) {
        ShippingCostCalculatorViolation violation = new ShippingCostCalculatorViolation();
        System.out.println("=== Violation: original if/else chain (no 'international' support without editing it) ===");
        System.out.printf("  standard, 2kg: $%.2f%n", violation.calculate("standard", 2));
        System.out.printf("  express, 2kg:  $%.2f%n", violation.calculate("express", 2));
        try {
            violation.calculate("international", 2);
        } catch (IllegalArgumentException e) {
            System.out.println("  international, 2kg: " + e.getMessage() + "  <- would require editing the existing method");
        }

        ShippingCostCalculator fixed = new ShippingCostCalculator();
        System.out.println("\n=== Fixed: Strategy pattern -- all methods, including the NEW one, work correctly ===");
        System.out.printf("  standard, 2kg:      $%.2f (matches original)%n", fixed.calculate("standard", 2));
        System.out.printf("  express, 2kg:       $%.2f (matches original)%n", fixed.calculate("express", 2));
        System.out.printf("  overnight, 2kg:     $%.2f (matches original)%n", fixed.calculate("overnight", 2));
        System.out.printf("  international, 2kg: $%.2f  <- NEW, added via a new class + one map entry, zero edits elsewhere%n",
                fixed.calculate("international", 2));
    }
}
