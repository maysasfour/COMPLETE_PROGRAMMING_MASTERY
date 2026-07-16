// Example.java - generic methods, bounded type parameters, wildcards.

import java.util.List;

public class Example {
    static <T> T first(List<T> items) {
        return items.get(0);
    }

    static <T extends Comparable<T>> T max(List<T> items) {
        T result = items.get(0);
        for (T item : items) {
            if (item.compareTo(result) > 0) result = item;
        }
        return result;
    }

    static double sumOfList(List<? extends Number> list) {
        double total = 0;
        for (Number n : list) total += n.doubleValue();
        return total;
    }

    public static void main(String[] args) {
        System.out.println("--- generic method with inference ---");
        System.out.println(first(List.of(1, 2, 3)));
        System.out.println(first(List.of("a", "b")));

        System.out.println("\n--- bounded type parameter ---");
        System.out.println("max of ints: " + max(List.of(3, 7, 2, 9, 4)));
        System.out.println("max of strings: " + max(List.of("banana", "apple", "cherry")));

        System.out.println("\n--- wildcard accepting List<? extends Number> ---");
        System.out.println("sumOfList(List<Integer>): " + sumOfList(List.of(1, 2, 3)));
        System.out.println("sumOfList(List<Double>): " + sumOfList(List.of(1.5, 2.5)));

        System.out.println("\n--- type erasure: instanceof List<?> is allowed, List<String> is not ---");
        List<String> strings = List.of("a", "b");
        System.out.println("strings instanceof List<?>: " + (strings instanceof List<?>));
    }
}
