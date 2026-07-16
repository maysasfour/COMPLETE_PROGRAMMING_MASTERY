// Example.java - Builder: constructs complex objects step by step, with named
// methods instead of long, ambiguous positional constructor arguments. Demonstrated
// with a real bug caused by the "telescoping constructor" problem -- two same-typed
// arguments silently swapped, compiling fine but producing a wrong object -- then
// a fix that makes this class of bug structurally impossible.

public class Example {

    // ============================================================
    // VIOLATION: a constructor with several same-typed parameters (int size,
    // int quantity) in a specific, easy-to-forget order. Swapping them is a
    // silent, compiling, WRONG result -- the compiler cannot catch it, because
    // both are just "int".
    // ============================================================
    static class PizzaViolation {
        final int sizeInches;
        final boolean cheese;
        final boolean pepperoni;
        final int quantity;

        PizzaViolation(int sizeInches, boolean cheese, boolean pepperoni, int quantity) {
            this.sizeInches = sizeInches;
            this.cheese = cheese;
            this.pepperoni = pepperoni;
            this.quantity = quantity;
        }

        @Override public String toString() {
            return quantity + "x " + sizeInches + "-inch pizza (cheese=" + cheese + ", pepperoni=" + pepperoni + ")";
        }
    }

    // ============================================================
    // FIX: Builder. Every value is set through a named method -- there is no
    // positional ambiguity left for two same-typed arguments to be silently
    // swapped; the code reads as documentation of what it's actually doing.
    // ============================================================
    static class Pizza {
        final int sizeInches;
        final boolean cheese;
        final boolean pepperoni;
        final int quantity;

        private Pizza(Builder b) {
            this.sizeInches = b.sizeInches;
            this.cheese = b.cheese;
            this.pepperoni = b.pepperoni;
            this.quantity = b.quantity;
        }

        @Override public String toString() {
            return quantity + "x " + sizeInches + "-inch pizza (cheese=" + cheese + ", pepperoni=" + pepperoni + ")";
        }

        static class Builder {
            private int sizeInches = 12; // sensible defaults -- optional parameters don't all need to be specified
            private boolean cheese = false;
            private boolean pepperoni = false;
            private int quantity = 1;

            Builder sizeInches(int sizeInches) { this.sizeInches = sizeInches; return this; }
            Builder cheese(boolean cheese) { this.cheese = cheese; return this; }
            Builder pepperoni(boolean pepperoni) { this.pepperoni = pepperoni; return this; }
            Builder quantity(int quantity) { this.quantity = quantity; return this; }

            Pizza build() { return new Pizza(this); }
        }
    }

    public static void main(String[] args) {
        System.out.println("=== Builder: fixing the telescoping-constructor swapped-argument bug ===");

        System.out.println("Violation: caller MEANT '2 pizzas, size 12', but accidentally swapped the two int arguments:");
        PizzaViolation intended = new PizzaViolation(12, true, false, 2); // correct order
        PizzaViolation swapped = new PizzaViolation(2, true, false, 12); // sizeInches and quantity SWAPPED
        System.out.println("  Intended:      " + intended);
        System.out.println("  Actually built: " + swapped + "  <- BUG: compiles fine, but this is nonsense (2-inch pizza x12)!");

        System.out.println("\nFixed: named builder methods make the swap structurally impossible to make silently:");
        Pizza correct = new Pizza.Builder()
                .sizeInches(12)
                .cheese(true)
                .quantity(2)
                .build();
        System.out.println("  " + correct + "  <- correct, and self-documenting regardless of call order");

        Pizza reordered = new Pizza.Builder()
                .quantity(2)      // methods can be called in ANY order --
                .sizeInches(12)   // there is no positional ambiguity to get wrong
                .cheese(true)
                .build();
        System.out.println("  " + reordered + "  <- same result, even with methods called in a different order");
    }
}
