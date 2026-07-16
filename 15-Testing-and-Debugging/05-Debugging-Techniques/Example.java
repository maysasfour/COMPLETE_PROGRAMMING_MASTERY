// Example.java - Debugging Techniques: reading a real stack trace to pinpoint a
// crash, and using diagnostic logging to bisect a SILENT (non-crashing) logic bug
// down to its actual root cause -- both against real, reproducible bugs.

import java.util.List;

public class Example {

    // ============================================================
    // TECHNIQUE 1: reading a real stack trace
    // ============================================================
    static int sumWithOffByOneBug(int[] numbers) {
        int total = 0;
        for (int i = 0; i <= numbers.length; i++) { // BUG: should be i < numbers.length
            total += numbers[i];
        }
        return total;
    }

    static void demoStackTraceReading() {
        System.out.println("=== Technique 1: reading a real stack trace to find a crash's root cause ===");
        int[] numbers = {10, 20, 30};
        try {
            sumWithOffByOneBug(numbers);
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Caught: " + e);
            System.out.println("Stack trace (read TOP-DOWN -- the top frame is where it actually happened):");
            for (StackTraceElement frame : e.getStackTrace()) {
                System.out.println("  at " + frame);
                if (frame.getClassName().equals("Example")) break; // stop at our own code, skip JVM internals
            }
            System.out.println("Reading this: \"Index 3 out of bounds for length 3\" tells us EXACTLY what happened --");
            System.out.println("index 3 was accessed on a length-3 array (valid indices 0-2). The stack trace's top");
            System.out.println("frame points to sumWithOffByOneBug's loop line -- that's where to look FIRST,");
            System.out.println("not just where the exception was caught.");
        }
    }

    // ============================================================
    // TECHNIQUE 2: bisecting a SILENT logic bug with diagnostic logging
    // ============================================================
    static int sharedAccumulatorBug = 0; // BUG: shared across ALL accounts, never reset per-account

    static int processAccountViolation(String accountName, List<Integer> transactions) {
        System.out.println("  [DEBUG] " + accountName + " starting, accumulator BEFORE processing = " + sharedAccumulatorBug);
        for (int amount : transactions) {
            sharedAccumulatorBug += amount;
        }
        return sharedAccumulatorBug; // returns the TOTAL across ALL accounts ever processed, not just this one!
    }

    static void demoLogBisection() {
        System.out.println("\n=== Technique 2: bisecting a SILENT logic bug with diagnostic logging ===");
        System.out.println("Processing two SEPARATE accounts; each total should reflect ONLY its own transactions:");
        System.out.println("Adding a diagnostic log line to the START of processAccountViolation, BEFORE this run's");
        System.out.println("own transactions are even added, to see what the accumulator looked like walking in:");

        int accountATotal = processAccountViolation("Account A", List.of(100, 50));
        System.out.println("  Account A total: " + accountATotal + " (expected 150)");

        int accountBTotal = processAccountViolation("Account B", List.of(10, 10));
        System.out.println("  Account B total: " + accountBTotal + " (expected 20, but got contamination from Account A!)");

        System.out.println("\n--- Reading the diagnostic log above: Account B's accumulator was 150 BEFORE its own");
        System.out.println("transactions were even added -- it should have started at 0 for a fresh account.");
        System.out.println("ROOT CAUSE FOUND: sharedAccumulatorBug is a STATIC field, shared across every call ---");
        System.out.println("Fix: make the accumulator LOCAL to each call, not shared static state:");

        int fixedAccountA = processAccountFixed(List.of(100, 50));
        int fixedAccountB = processAccountFixed(List.of(10, 10));
        System.out.println("  Account A total (fixed): " + fixedAccountA + " (correct)");
        System.out.println("  Account B total (fixed): " + fixedAccountB + " (correct -- no contamination)");
    }

    static int processAccountFixed(List<Integer> transactions) {
        int total = 0; // LOCAL to this call -- cannot leak into any other account's total
        for (int amount : transactions) {
            total += amount;
        }
        return total;
    }

    public static void main(String[] args) {
        demoStackTraceReading();
        demoLogBisection();
    }
}
