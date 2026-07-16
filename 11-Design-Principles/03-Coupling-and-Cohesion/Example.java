// Example.java - Coupling (how much classes depend on each other's internals) and
// Cohesion (how strongly a class's own responsibilities belong together), each shown
// as a real, verified bug caused by tight coupling / low cohesion, then a fix.

public class Example {

    // ============================================================
    // COUPLING — tight coupling to another class's internal representation
    // ============================================================

    // VIOLATION: Display reaches directly into Thermometer's internal field, and
    // WRONGLY ASSUMES it's already in Celsius -- because nothing hides the internal
    // representation (Fahrenheit) or forces a proper conversion.
    static class ThermometerViolation {
        public double tempFahrenheit; // internal representation exposed directly
        ThermometerViolation(double f) { this.tempFahrenheit = f; }
    }

    static class DisplayViolation {
        String show(ThermometerViolation t) {
            // BUG: prints the raw Fahrenheit number, mislabeled as Celsius --
            // this coupling to the internal field, with no abstraction in between,
            // is exactly what let this unit-mislabeling bug happen.
            return "Temp: " + t.tempFahrenheit + "C";
        }
    }

    // FIX: Thermometer hides its internal representation entirely and exposes only
    // a proper, correctly-converting accessor. Display is now decoupled from HOW
    // the temperature is actually stored internally.
    static class Thermometer {
        private final double fahrenheit; // private -- no longer directly reachable
        Thermometer(double fahrenheit) { this.fahrenheit = fahrenheit; }
        double getCelsius() { return (fahrenheit - 32) * 5 / 9.0; }
    }

    static class Display {
        String show(Thermometer t) {
            return String.format("Temp: %.1fC", t.getCelsius());
        }
    }

    static void demoCoupling() {
        System.out.println("=== Coupling: tight coupling to internal representation ===");
        ThermometerViolation tv = new ThermometerViolation(98.6); // 98.6F = 37.0C
        System.out.println("Violation (Display reads the raw internal field directly):");
        System.out.println("  " + new DisplayViolation().show(tv) + "  <- WRONG: this is 98.6, mislabeled as Celsius!");

        Thermometer t = new Thermometer(98.6);
        System.out.println("Fixed (Display only calls Thermometer's own, correctly-converting accessor):");
        System.out.println("  " + new Display().show(t) + "  <- correct: 98.6F really is 37.0C");
    }

    // ============================================================
    // COHESION — unrelated responsibilities crammed into one class, sharing state
    // ============================================================

    // VIOLATION: ReportGenerator mixes two UNRELATED responsibilities (formatting
    // a header, and calculating a discount) and, because they were never meant to
    // coexist, they end up sharing the same mutable field -- one operation
    // clobbers the other's state.
    static class ReportGeneratorViolation {
        private String cache; // used for TWO unrelated purposes -- a low-cohesion smell

        String formatHeader(String title) {
            cache = title.toUpperCase();
            return "=== " + cache + " ===";
        }

        double applyDiscount(double amount, double rate) {
            cache = "discount-op"; // unrelated concern clobbers the SAME shared field
            return amount - (amount * rate);
        }

        String getLastHeaderCache() { return cache; } // meant to remember the header...
    }

    // FIX: split into two classes, each with its OWN state, so unrelated
    // responsibilities can no longer clobber each other.
    static class HeaderFormatter {
        private String lastHeader;
        String format(String title) {
            lastHeader = title.toUpperCase();
            return "=== " + lastHeader + " ===";
        }
        String getLastHeader() { return lastHeader; }
    }

    static class DiscountCalculator {
        double apply(double amount, double rate) {
            return amount - (amount * rate);
        }
    }

    static void demoCohesion() {
        System.out.println("\n=== Cohesion: unrelated responsibilities sharing state ===");
        ReportGeneratorViolation rg = new ReportGeneratorViolation();
        System.out.println("Violation: format a header, THEN apply an unrelated discount...");
        rg.formatHeader("Sales Report");
        rg.applyDiscount(100, 0.10);
        System.out.println("  getLastHeaderCache() = \"" + rg.getLastHeaderCache() +
                "\"  <- BUG: should still be \"SALES REPORT\", but the unrelated discount call clobbered it!");

        System.out.println("Fixed: each responsibility has its OWN state, so nothing can clobber the other:");
        HeaderFormatter hf = new HeaderFormatter();
        DiscountCalculator dc = new DiscountCalculator();
        hf.format("Sales Report");
        dc.apply(100, 0.10);
        System.out.println("  getLastHeader() = \"" + hf.getLastHeader() + "\"  <- correct, untouched by the unrelated discount call");
    }

    public static void main(String[] args) {
        demoCoupling();
        demoCohesion();
    }
}
