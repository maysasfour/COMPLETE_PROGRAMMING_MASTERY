// Example.java - OS Fundamentals: processes, threads, and scheduling. The OS
// scheduler interleaves threads' execution in ways a program cannot fully
// predict or control -- demonstrated with a REAL, measured race condition
// caused by that interleaving, then fixed with proper synchronization.

import java.util.concurrent.atomic.AtomicInteger;

public class Example {

    // ============================================================
    // VIOLATION: multiple threads incrementing a SHARED counter with no
    // synchronization. "counter++" is NOT atomic -- it's really three steps
    // (read, add 1, write back), and the OS scheduler can interleave threads
    // between those steps, causing lost updates.
    // ============================================================
    static int sharedCounterViolation = 0;

    static void incrementManyTimesViolation() {
        for (int i = 0; i < 100_000; i++) {
            sharedCounterViolation++; // read-modify-write: NOT atomic
        }
    }

    static void demoRaceCondition() throws InterruptedException {
        System.out.println("=== Violation: a real race condition from unsynchronized shared state ===");
        int threadCount = 4;
        int incrementsPerThread = 100_000;
        int expected = threadCount * incrementsPerThread;

        Thread[] threads = new Thread[threadCount];
        for (int i = 0; i < threadCount; i++) {
            threads[i] = new Thread(Example::incrementManyTimesViolation);
            threads[i].start();
        }
        for (Thread t : threads) t.join();

        System.out.println("Expected final count: " + expected);
        System.out.println("ACTUAL final count:   " + sharedCounterViolation +
                (sharedCounterViolation != expected ? "  <- BUG: lost updates from unsynchronized concurrent access!" : "  (no race hit this run -- rerun to see it)"));
    }

    // ============================================================
    // FIX: AtomicInteger performs the read-modify-write as one indivisible
    // operation, immune to scheduler interleaving.
    // ============================================================
    static AtomicInteger sharedCounterFixed = new AtomicInteger(0);

    static void incrementManyTimesFixed() {
        for (int i = 0; i < 100_000; i++) {
            sharedCounterFixed.incrementAndGet(); // atomic -- cannot be interleaved
        }
    }

    static void demoFixedWithAtomic() throws InterruptedException {
        System.out.println("\n=== Fixed: AtomicInteger makes the increment genuinely indivisible ===");
        int threadCount = 4;
        int incrementsPerThread = 100_000;
        int expected = threadCount * incrementsPerThread;

        Thread[] threads = new Thread[threadCount];
        for (int i = 0; i < threadCount; i++) {
            threads[i] = new Thread(Example::incrementManyTimesFixed);
            threads[i].start();
        }
        for (Thread t : threads) t.join();

        System.out.println("Expected final count: " + expected);
        System.out.println("ACTUAL final count:   " + sharedCounterFixed.get() +
                (sharedCounterFixed.get() == expected ? "  <- correct: no lost updates" : "  <- unexpected!"));
    }

    // ============================================================
    // A real, observable illustration of scheduling: multiple threads running
    // "simultaneously" on however many CPU cores are actually available.
    // ============================================================
    static void demoAvailableProcessors() {
        System.out.println("\n=== Scheduling context: how many CPU cores does the OS report? ===");
        int cores = Runtime.getRuntime().availableProcessors();
        System.out.println("Runtime.getRuntime().availableProcessors() = " + cores);
        System.out.println("With " + cores + " real core(s), the OS scheduler is genuinely time-slicing" +
                " and/or parallelizing the 4 threads used above across them.");
    }

    public static void main(String[] args) throws InterruptedException {
        demoAvailableProcessors();
        demoRaceCondition();
        demoFixedWithAtomic();
    }
}
