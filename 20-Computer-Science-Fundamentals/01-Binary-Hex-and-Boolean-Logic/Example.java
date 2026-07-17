// Example.java - Binary/hex representation and boolean logic, each demonstrated
// with a real, verified bug: Java's signed byte causing sign-extension
// corruption, arithmetic vs logical right-shift producing different real
// results on negative numbers, and short-circuit vs non-short-circuit boolean
// operators producing genuinely different behavior, not just different style.

public class Example {

    // ============================================================
    // VIOLATION: Java's `byte` is SIGNED (-128 to 127). A byte read from
    // binary data representing the UNSIGNED value 255 (0xFF) is actually
    // stored as -1 -- converting it to int directly sign-extends it, silently
    // corrupting the intended value.
    // ============================================================
    static void demoByteSignExtension() {
        System.out.println("=== Violation: Java's signed byte causes real data corruption ===");
        byte fileByte = (byte) 0xFF; // represents the UNSIGNED byte value 255 in a binary file
        System.out.println("Raw byte value (Java's signed interpretation): " + fileByte);

        int wrongInt = fileByte; // BUG: direct conversion sign-extends
        System.out.println("Direct byte->int conversion: " + wrongInt + "  <- WRONG: should be 255, got " + wrongInt);

        int correctInt = fileByte & 0xFF; // FIX: mask off the sign-extended bits
        System.out.println("Masked with & 0xFF: " + correctInt + "  <- correct: genuinely 255");
    }

    // ============================================================
    // Arithmetic (>>) vs logical (>>>) right shift -- REAL, different results
    // on a negative number.
    // ============================================================
    static void demoShiftOperators() {
        System.out.println("\n=== Arithmetic (>>) vs logical (>>>) shift on a real negative number ===");
        int value = -8; // binary: 11111111 11111111 11111111 11111000
        System.out.println("value = " + value + " (binary: " + toBinary(value) + ")");

        int arithmetic = value >> 1; // sign-extends: fills with the sign bit (1)
        int logical = value >>> 1;   // fills with 0, regardless of sign

        System.out.println("value >>  1 = " + arithmetic + " (binary: " + toBinary(arithmetic) + ")  <- sign-preserving");
        System.out.println("value >>> 1 = " + logical + " (binary: " + toBinary(logical) + ")  <- zero-filling, VERY different real result");
    }

    static String toBinary(int n) {
        String bits = Integer.toBinaryString(n);
        return "0".repeat(Math.max(0, 32 - bits.length())) + bits;
    }

    // ============================================================
    // Short-circuit (&&) vs non-short-circuit (&) boolean operators -- a
    // REAL difference in behavior, not just style, verified with a genuine
    // NullPointerException.
    // ============================================================
    static void demoShortCircuit() {
        System.out.println("\n=== Short-circuit (&&) vs non-short-circuit (&) -- a REAL behavioral difference ===");
        String maybeNull = null;

        System.out.println("Using short-circuit && (correctly avoids evaluating the right side when the left is false):");
        if (maybeNull != null && maybeNull.length() > 0) {
            System.out.println("  (unreachable)");
        } else {
            System.out.println("  Correctly skipped calling .length() on null -- no exception");
        }

        System.out.println("Using non-short-circuit & (evaluates BOTH sides regardless):");
        try {
            if (maybeNull != null & maybeNull.length() > 0) {
                System.out.println("  (unreachable)");
            }
        } catch (NullPointerException e) {
            System.out.println("  Caught a REAL NullPointerException: & evaluated maybeNull.length() even though the left side was already false!");
        }
    }

    public static void main(String[] args) {
        demoByteSignExtension();
        demoShiftOperators();
        demoShortCircuit();
    }
}
