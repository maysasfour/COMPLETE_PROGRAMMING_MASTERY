// Example.java - traditional switch, switch expressions, pattern-matching switch, enhanced for.

public class Example {
    public static void main(String[] args) {
        System.out.println("--- traditional switch statement ---");
        int day = 6;
        switch (day) {
            case 6:
            case 7:
                System.out.println("Weekend");
                break;
            default:
                System.out.println("Weekday");
                break;
        }

        System.out.println("\n--- switch expression ---");
        String description = switch (day) {
            case 6, 7 -> "Weekend";
            default -> "Weekday";
        };
        System.out.println(description);

        System.out.println("\n--- pattern-matching switch ---");
        System.out.println(describe(-5));
        System.out.println(describe(42));
        System.out.println(describe("hello"));
        System.out.println(describe(null));

        System.out.println("\n--- enhanced for ---");
        for (String fruit : new String[]{"apple", "banana"}) {
            System.out.println("fruit: " + fruit);
        }
    }

    static String describe(Object value) {
        return switch (value) {
            case Integer i when i < 0 -> "negative number";
            case Integer i -> "non-negative number: " + i;
            case String s -> "a string of length " + s.length();
            case null -> "null value";
            default -> "something else";
        };
    }
}
