// Example.java - CompletableFuture, allOf for concurrency (with real timing), virtual threads.

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executors;

public class Example {
    static void sleep(long ms) {
        try { Thread.sleep(ms); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
    }

    static String delayedGreet(long ms, String name) {
        sleep(ms);
        return "Hello, " + name;
    }

    public static void main(String[] args) throws InterruptedException {
        System.out.println("--- basic CompletableFuture ---");
        CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> delayedGreet(50, "Ada"));
        System.out.println(future.join());

        System.out.println("\n--- chained .thenApply ---");
        CompletableFuture<String> chained = CompletableFuture
            .supplyAsync(() -> "Hello")
            .thenApply(s -> s + ", Ada");
        System.out.println(chained.join());

        System.out.println("\n--- sequential joins vs CompletableFuture.allOf (real timing) ---");
        long seqStart = System.currentTimeMillis();
        delayedGreet(80, "a");
        delayedGreet(80, "b");
        delayedGreet(80, "c");
        long seqElapsed = System.currentTimeMillis() - seqStart;
        System.out.println("Sequential 3x80ms calls took ~" + seqElapsed + "ms");

        long concStart = System.currentTimeMillis();
        CompletableFuture<String> f1 = CompletableFuture.supplyAsync(() -> delayedGreet(80, "Ada"));
        CompletableFuture<String> f2 = CompletableFuture.supplyAsync(() -> delayedGreet(80, "Lin"));
        CompletableFuture<String> f3 = CompletableFuture.supplyAsync(() -> delayedGreet(80, "Kai"));
        CompletableFuture.allOf(f1, f2, f3).join();
        long concElapsed = System.currentTimeMillis() - concStart;
        System.out.println("CompletableFuture.allOf of the same 3x80ms tasks took ~" + concElapsed + "ms");
        System.out.println(f1.join() + " | " + f2.join() + " | " + f3.join());

        System.out.println("\n--- virtual threads (Java 21+) ---");
        try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
            var task = executor.submit(() -> {
                sleep(50);
                System.out.println("Ran on: " + Thread.currentThread());
            });
            task.get();
        } catch (Exception e) {
            System.out.println("Virtual thread task error: " + e.getMessage());
        }
    }
}
