// Example.java - Adapter (making an incompatible interface usable through the one
// your code expects) and Decorator (adding behavior to an object dynamically,
// without subclass explosion), each shown with a real bug and a fix.

public class Example {

    // ============================================================
    // ADAPTER
    // ============================================================

    // A third-party/legacy API with an INCOMPATIBLE interface: it wants an
    // integer number of CENTS, not a double number of dollars.
    static class LegacyPaymentGateway {
        void makeTransaction(int amountCents) {
            System.out.println("  Legacy gateway charged " + amountCents + " cents");
        }
    }

    // The interface the rest of the codebase actually expects.
    interface PaymentProcessor {
        void pay(double amountDollars);
    }

    // VIOLATION: every call site has to remember to do the dollars->cents
    // conversion itself. One call site does it correctly; another FORGETS,
    // passing dollars directly where cents are expected -- a real, silent,
    // 100x-too-small charge.
    static void checkoutCorrectViolation(LegacyPaymentGateway gateway, double amountDollars) {
        gateway.makeTransaction((int) Math.round(amountDollars * 100)); // correct conversion
    }

    static void checkoutBuggyViolation(LegacyPaymentGateway gateway, double amountDollars) {
        gateway.makeTransaction((int) amountDollars); // BUG: forgot the *100 conversion entirely!
    }

    // FIX: an Adapter implements the interface the codebase expects, and hides
    // the conversion in exactly ONE place. No caller can forget it, because no
    // caller ever sees the legacy API directly.
    static class LegacyPaymentGatewayAdapter implements PaymentProcessor {
        private final LegacyPaymentGateway legacy;
        LegacyPaymentGatewayAdapter(LegacyPaymentGateway legacy) { this.legacy = legacy; }
        public void pay(double amountDollars) {
            legacy.makeTransaction((int) Math.round(amountDollars * 100));
        }
    }

    static void demoAdapter() {
        System.out.println("=== Adapter: making an incompatible interface safe to use ===");
        LegacyPaymentGateway gateway = new LegacyPaymentGateway();

        System.out.println("Violation: two call sites, each doing the dollars->cents conversion themselves:");
        System.out.print("  Correct call site ($19.99): ");
        checkoutCorrectViolation(gateway, 19.99);
        System.out.print("  Buggy call site ($19.99):   ");
        checkoutBuggyViolation(gateway, 19.99);
        System.out.println("  ^ BUG: charged only 19 cents instead of 1999 cents -- the *100 conversion was forgotten!");

        System.out.println("Fixed: every caller goes through the SAME Adapter -- conversion cannot be forgotten:");
        PaymentProcessor processor = new LegacyPaymentGatewayAdapter(gateway);
        System.out.print("  ");
        processor.pay(19.99);
    }

    // ============================================================
    // DECORATOR
    // ============================================================

    interface Coffee {
        double cost();
        String description();
    }

    static class SimpleCoffee implements Coffee {
        public double cost() { return 2.00; }
        public String description() { return "Coffee"; }
    }

    // VIOLATION: subclass explosion. Each add-on combination gets its OWN
    // subclass, each reimplementing the pricing formula -- and the formulas
    // DRIFT apart, since "sugar costs $0.25" is duplicated in two places.
    static class SugarCoffeeViolation extends SimpleCoffee {
        @Override public double cost() { return super.cost() + 0.25; }
        @Override public String description() { return super.description() + ", Sugar"; }
    }

    static class MilkSugarCoffeeViolation extends SimpleCoffee {
        @Override public double cost() { return super.cost() + 0.50 + 0.20; } // BUG: sugar priced at 0.20 here, drifted from 0.25 above!
        @Override public String description() { return super.description() + ", Milk, Sugar"; }
    }

    // FIX: Decorator. Each add-on is a small wrapper defining its OWN price
    // exactly ONCE; combinations are built by composing decorators, not by
    // writing a new subclass (and a new, potentially drifting formula) per combination.
    abstract static class CoffeeDecorator implements Coffee {
        protected final Coffee wrapped;
        CoffeeDecorator(Coffee wrapped) { this.wrapped = wrapped; }
    }

    static class Milk extends CoffeeDecorator {
        Milk(Coffee wrapped) { super(wrapped); }
        public double cost() { return wrapped.cost() + 0.50; }
        public String description() { return wrapped.description() + ", Milk"; }
    }

    static class Sugar extends CoffeeDecorator {
        Sugar(Coffee wrapped) { super(wrapped); }
        public double cost() { return wrapped.cost() + 0.25; } // the ONE, single place sugar's price is defined
        public String description() { return wrapped.description() + ", Sugar"; }
    }

    static void demoDecorator() {
        System.out.println("\n=== Decorator: avoiding subclass explosion and drifted pricing ===");

        System.out.println("Violation: Sugar's price is defined SEPARATELY in two different subclasses:");
        SugarCoffeeViolation sugarOnly = new SugarCoffeeViolation();
        MilkSugarCoffeeViolation milkSugar = new MilkSugarCoffeeViolation();
        System.out.printf("  %s: $%.2f%n", sugarOnly.description(), sugarOnly.cost());
        System.out.printf("  %s: $%.2f  <- BUG: sugar's price drifted (0.20 here vs 0.25 in SugarCoffeeViolation)!%n",
                milkSugar.description(), milkSugar.cost());

        System.out.println("Fixed: Sugar's price is defined ONCE, reused consistently via composition:");
        Coffee sugarFixed = new Sugar(new SimpleCoffee());
        Coffee milkSugarFixed = new Sugar(new Milk(new SimpleCoffee()));
        System.out.printf("  %s: $%.2f%n", sugarFixed.description(), sugarFixed.cost());
        System.out.printf("  %s: $%.2f  <- consistent: same $0.25 sugar price, no drift possible%n",
                milkSugarFixed.description(), milkSugarFixed.cost());
    }

    public static void main(String[] args) {
        demoAdapter();
        demoDecorator();
    }
}
