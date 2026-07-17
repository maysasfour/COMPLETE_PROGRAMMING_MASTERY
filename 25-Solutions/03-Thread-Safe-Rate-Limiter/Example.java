import java.util.concurrent.atomic.AtomicInteger;

public class Example {

    static class RateLimiterViolation {
        private int count = 0;
        private final int max;
        RateLimiterViolation(int max) { this.max = max; }
        boolean allow() {
            // A deliberate, tiny delay between the check and the increment widens
            // the real race window so the bug reproduces reliably in this demo,
            // rather than depending on luck -- the same technique used to reliably
            // reproduce the naive Singleton race condition in 12-Design-Patterns/01.
            if (count < max) {
                try { Thread.sleep(0, 100); } catch (InterruptedException ignored) {}
                count++;
                return true;
            }
            return false;
        }
    }

    static class RateLimiterFixed {
        private final AtomicInteger count = new AtomicInteger(0);
        private final int max;
        RateLimiterFixed(int max) { this.max = max; }
        boolean allow() {
            return count.getAndUpdate(c -> c < max ? c + 1 : c) < max; // atomic compare-and-increment
        }
    }

    public static void main(String[] args) throws InterruptedException {
        int max = 100;
        int threadCount = 8;
        int attemptsPerThread = 1000;

        System.out.println("=== Violation: naive int-based rate limiter under concurrent load ===");
        RateLimiterViolation violation = new RateLimiterViolation(max);
        AtomicInteger allowedCountViolation = new AtomicInteger(0);
        Thread[] threadsV = new Thread[threadCount];
        for (int i = 0; i < threadCount; i++) {
            threadsV[i] = new Thread(() -> {
                for (int j = 0; j < attemptsPerThread; j++) {
                    if (violation.allow()) allowedCountViolation.incrementAndGet();
                }
            });
            threadsV[i].start();
        }
        for (Thread t : threadsV) t.join();
        System.out.println("Max allowed: " + max + ", actually allowed: " + allowedCountViolation.get() +
                (allowedCountViolation.get() > max ? "  <- BUG: allowed MORE than max under concurrent load!" : ""));

        System.out.println("\n=== Fixed: AtomicInteger-based rate limiter, verified across 3 runs ===");
        for (int run = 1; run <= 3; run++) {
            RateLimiterFixed fixed = new RateLimiterFixed(max);
            AtomicInteger allowedCountFixed = new AtomicInteger(0);
            Thread[] threadsF = new Thread[threadCount];
            for (int i = 0; i < threadCount; i++) {
                threadsF[i] = new Thread(() -> {
                    for (int j = 0; j < attemptsPerThread; j++) {
                        if (fixed.allow()) allowedCountFixed.incrementAndGet();
                    }
                });
                threadsF[i].start();
            }
            for (Thread t : threadsF) t.join();
            System.out.println("Run " + run + ": max allowed: " + max + ", actually allowed: " + allowedCountFixed.get() +
                    (allowedCountFixed.get() == max ? "  <- correct" : "  <- UNEXPECTED"));
        }
    }
}
