// Example.java - DRY, KISS, and YAGNI, each shown with a real bug caused by
// violating the principle, then a fix that makes the bug structurally impossible
// (DRY, matching the same discipline used for SOLID) or simply removes needless
// complexity/unused code (KISS, YAGNI).

import java.util.function.Function;

public class Example {

    // ============================================================
    // DRY — Don't Repeat Yourself
    // ============================================================

    // VIOLATION: the same 10% discount rule is duplicated in two places.
    static double orderTotalViolation(double subtotal, boolean isMember) {
        double discount = isMember ? subtotal * 0.10 : 0.0; // rule copy #1
        return subtotal - discount;
    }

    static double invoiceTotalViolation(double subtotal, boolean isMember) {
        double discount = isMember ? subtotal * 0.15 : 0.0; // rule copy #2 -- DRIFTED! now 15%, not 10%
        return subtotal - discount;
    }

    // FIX: the discount rule exists in exactly ONE place; both callers use it,
    // so it is structurally impossible for them to drift apart.
    static double memberDiscountRate() { return 0.10; }

    static double orderTotal(double subtotal, boolean isMember) {
        double discount = isMember ? subtotal * memberDiscountRate() : 0.0;
        return subtotal - discount;
    }

    static double invoiceTotal(double subtotal, boolean isMember) {
        double discount = isMember ? subtotal * memberDiscountRate() : 0.0;
        return subtotal - discount;
    }

    static void demoDRY() {
        System.out.println("=== DRY: Don't Repeat Yourself ===");
        System.out.println("Violation: the SAME 'member discount' rule was copy-pasted and DRIFTED:");
        System.out.printf("  Order total (member, $100 subtotal):   $%.2f (10%% discount)%n",
                orderTotalViolation(100, true));
        System.out.printf("  Invoice total (member, $100 subtotal): $%.2f (should ALSO be 10%%, but copy #2 drifted to 15%%!)%n",
                invoiceTotalViolation(100, true));

        System.out.println("Fixed: both callers use the SAME memberDiscountRate() -- cannot drift apart:");
        System.out.printf("  Order total (member, $100 subtotal):   $%.2f%n", orderTotal(100, true));
        System.out.printf("  Invoice total (member, $100 subtotal): $%.2f%n", invoiceTotal(100, true));
    }

    // ============================================================
    // KISS — Keep It Simple, Stupid
    // ============================================================

    // VIOLATION: an unnecessarily "clever" bit-trick to check if a number is a
    // power of two -- correct in isolation, but fails silently for negative inputs
    // because the author never had to think through what "simple" code makes obvious.
    static boolean isPowerOfTwoViolation(int n) {
        return (n & (n - 1)) == 0; // clever, but WRONG for n=0 and silently wrong-looking for negatives
    }

    // FIX: a simple, obviously-correct version that explicitly handles the edge case
    // a reader would naturally think of first.
    static boolean isPowerOfTwo(int n) {
        if (n <= 0) return false; // the edge case KISS forces you to notice and handle explicitly
        return (n & (n - 1)) == 0;
    }

    static void demoKISS() {
        System.out.println("\n=== KISS: Keep It Simple, Stupid ===");
        System.out.println("Violation: the 'clever' one-liner gives a WRONG answer for n=0:");
        System.out.println("  isPowerOfTwoViolation(0) = " + isPowerOfTwoViolation(0) + "  (0 is NOT a power of two!)");
        System.out.println("  isPowerOfTwoViolation(8) = " + isPowerOfTwoViolation(8) + "  (correct, by luck of the bit trick)");

        System.out.println("Fixed: the simple version explicitly handles the edge case, and is correct:");
        System.out.println("  isPowerOfTwo(0) = " + isPowerOfTwo(0));
        System.out.println("  isPowerOfTwo(8) = " + isPowerOfTwo(8));
    }

    // ============================================================
    // YAGNI — You Aren't Gonna Need It
    // ============================================================

    // VIOLATION: speculative "flexibility" for tax calculation strategies that were
    // never actually requested -- a Function-based strategy registry supporting
    // "future" tax regimes that don't exist yet. The unused, speculative branch
    // has a real, unnoticed bug because nobody has ever actually exercised it.
    static class TaxCalculatorViolation {
        private final java.util.Map<String, Function<Double, Double>> strategies = new java.util.HashMap<>();

        TaxCalculatorViolation() {
            strategies.put("US", amount -> amount * 1.08);
            // Speculative: nobody asked for this yet, added "just in case."
            // Bug: uses 0.20 as a multiplier meant to ADD 20%, but multiplies
            // instead of adding 1 + rate -- nobody caught it because it's never used.
            strategies.put("EU_SPECULATIVE", amount -> amount * 0.20);
        }

        double calculate(String region, double amount) {
            return strategies.get(region).apply(amount);
        }
    }

    // FIX: only the ACTUALLY-needed case is implemented. Simpler, and has no
    // unused, unverified, buggy speculative code sitting in the codebase.
    static class TaxCalculator {
        double calculate(double amount) {
            return amount * 1.08; // US only -- the only case ever actually requested
        }
    }

    static void demoYAGNI() {
        System.out.println("\n=== YAGNI: You Aren't Gonna Need It ===");
        System.out.println("Violation: a speculative 'future' tax strategy was added unused, and is BUGGY:");
        TaxCalculatorViolation calc = new TaxCalculatorViolation();
        System.out.printf("  US tax on $100: $%.2f (correct)%n", calc.calculate("US", 100));
        System.out.printf("  EU_SPECULATIVE tax on $100: $%.2f (BUG: should probably be $120, not $20 -- nobody ever noticed, because nobody ever used it)%n",
                calc.calculate("EU_SPECULATIVE", 100));

        System.out.println("Fixed: only the ACTUALLY-needed case exists -- nothing unused, nothing unverified:");
        TaxCalculator fixedCalc = new TaxCalculator();
        System.out.printf("  US tax on $100: $%.2f%n", fixedCalc.calculate(100));
    }

    public static void main(String[] args) {
        demoDRY();
        demoKISS();
        demoYAGNI();
    }
}
