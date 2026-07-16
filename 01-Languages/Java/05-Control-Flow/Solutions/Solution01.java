// Solution01.java - FizzBuzz as a switch expression with when guards.

public class Solution01 {
    static String fizzBuzz(int n) {
        // Switching on the boxed Integer (not the primitive int) is what allows
        // reference-type patterns like `Integer i when ...` below without needing
        // the still-preview "primitive patterns" feature.
        Integer boxed = n;
        return switch (boxed) {
            case Integer i when i % 15 == 0 -> "FizzBuzz";
            case Integer i when i % 3 == 0 -> "Fizz";
            case Integer i when i % 5 == 0 -> "Buzz";
            default -> String.valueOf(n);
        };
    }

    public static void main(String[] args) {
        for (int i = 1; i <= 15; i++) {
            System.out.println(fizzBuzz(i));
        }
    }
}
