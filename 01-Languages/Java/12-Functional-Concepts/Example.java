// Example.java - built-in functional interfaces, a higher-order wrapper, Stream filter/map/reduce.

import java.util.List;
import java.util.function.*;

public class Example {
    static Function<Integer, Integer> withLogging(Function<Integer, Integer> fn) {
        return n -> {
            System.out.println("  Calling with " + n);
            int result = fn.apply(n);
            System.out.println("  Returned " + result);
            return result;
        };
    }

    public static void main(String[] args) {
        System.out.println("--- built-in functional interfaces ---");
        Function<Integer, Integer> square = n -> n * n;
        Predicate<Integer> isEven = n -> n % 2 == 0;
        Consumer<String> log = message -> System.out.println("LOG: " + message);
        Supplier<String> getGreeting = () -> "Hello!";

        System.out.println("square.apply(5): " + square.apply(5));
        System.out.println("isEven.test(4): " + isEven.test(4));
        log.accept("hello");
        System.out.println("getGreeting.get(): " + getGreeting.get());

        System.out.println("\n--- higher-order function wrapping a Function ---");
        var loggedSquare = withLogging(square);
        loggedSquare.apply(5);

        System.out.println("\n--- Stream: filter, map, reduce with a method reference ---");
        List<Integer> numbers = List.of(1, 2, 3, 4, 5);
        int result = numbers.stream()
            .filter(n -> n % 2 == 0)
            .map(n -> n * n)
            .reduce(0, Integer::sum);
        System.out.println("sum of squares of evens: " + result);
    }
}
