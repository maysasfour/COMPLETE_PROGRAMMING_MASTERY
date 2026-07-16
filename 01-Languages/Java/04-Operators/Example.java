// Example.java - == vs .equals(), string interning, instanceof pattern matching.

public class Example {
    public static void main(String[] args) {
        System.out.println("--- == vs .equals() ---");
        String a = "hello";
        String b = "hello";
        System.out.println("a == b (both literals, interned): " + (a == b));

        String c = new String("hello");
        System.out.println("a == c (c is a new, non-interned object): " + (a == c));
        System.out.println("a.equals(c): " + a.equals(c));

        System.out.println("\n--- instanceof pattern matching ---");
        Object value = "hello";
        if (value instanceof String s) {
            System.out.println("Matched and bound, uppercased: " + s.toUpperCase());
        }

        Object number = 42;
        if (number instanceof Integer n) {
            System.out.println("Matched Integer, doubled: " + (n * 2));
        }
    }
}
