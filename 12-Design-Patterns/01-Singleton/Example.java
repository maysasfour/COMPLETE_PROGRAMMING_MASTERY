// Example.java - Singleton: ensures a class has exactly one instance. Demonstrated
// with a REAL concurrency bug in a naive implementation (verified by actually running
// multiple threads and counting distinct instances created), then a correct,
// thread-safe fix.

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class Example {

    // ============================================================
    // VIOLATION: naive, non-thread-safe lazy singleton. The check-then-act
    // ("if instance == null, create it") is NOT atomic -- multiple threads can
    // all see instance == null and each create their OWN instance.
    // ============================================================
    static class NaiveSingleton {
        private static NaiveSingleton instance;
        private NaiveSingleton() {}

        static NaiveSingleton getInstance() {
            if (instance == null) {
                // A deliberate small delay widens the race window so the bug
                // reproduces reliably in this demo, rather than depending on luck.
                try { Thread.sleep(1); } catch (InterruptedException ignored) {}
                instance = new NaiveSingleton();
            }
            return instance;
        }

        static void reset() { instance = null; } // test-only helper to rerun the demo
    }

    // ============================================================
    // FIX: the initialization-on-demand holder idiom. The JVM guarantees a class
    // (Holder) is initialized lazily, exactly once, in a thread-safe way -- no
    // manual locking needed, and no race window at all.
    // ============================================================
    static class Singleton {
        private Singleton() {}
        private static class Holder {
            static final Singleton INSTANCE = new Singleton();
        }
        static Singleton getInstance() {
            return Holder.INSTANCE;
        }
    }

    static Set<Integer> callFromManyThreads(int threadCount, Runnable warmup, java.util.function.Supplier<Object> getInstance)
            throws InterruptedException {
        warmup.run();
        Set<Integer> identityHashes = ConcurrentHashMap.newKeySet();
        CountDownLatch startLatch = new CountDownLatch(1);
        CountDownLatch doneLatch = new CountDownLatch(threadCount);
        ExecutorService pool = Executors.newFixedThreadPool(threadCount);

        for (int i = 0; i < threadCount; i++) {
            pool.submit(() -> {
                try {
                    startLatch.await(); // all threads race to call getInstance() at the same moment
                    Object instance = getInstance.get();
                    identityHashes.add(System.identityHashCode(instance));
                } catch (InterruptedException ignored) {
                } finally {
                    doneLatch.countDown();
                }
            });
        }
        startLatch.countDown(); // release all threads simultaneously
        doneLatch.await(5, TimeUnit.SECONDS);
        pool.shutdown();
        return identityHashes;
    }

    public static void main(String[] args) throws InterruptedException {
        System.out.println("=== Singleton: a real race condition, verified with actual threads ===");

        int threadCount = 10;
        Set<Integer> naiveInstances = callFromManyThreads(threadCount, NaiveSingleton::reset, NaiveSingleton::getInstance);
        System.out.println("Violation: " + threadCount + " threads called NaiveSingleton.getInstance() concurrently.");
        System.out.println("  Distinct instances actually created: " + naiveInstances.size() +
                (naiveInstances.size() > 1 ? "  <- BUG: should be 1, the race condition created multiple instances!" : " (no race hit this run)"));

        Set<Integer> fixedInstances = callFromManyThreads(threadCount, () -> {}, Singleton::getInstance);
        System.out.println("\nFixed: " + threadCount + " threads called Singleton.getInstance() (holder idiom) concurrently.");
        System.out.println("  Distinct instances actually created: " + fixedInstances.size() +
                (fixedInstances.size() == 1 ? "  <- correct: exactly one instance, guaranteed by the JVM's class-init lock" : ""));
    }
}
