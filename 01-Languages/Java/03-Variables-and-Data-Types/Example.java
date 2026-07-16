// Example.java - primitives vs objects, var/final, and the autoboxing equality gotcha.

public class Example {
    public static void main(String[] args) {
        System.out.println("--- primitives vs objects ---");
        int a = 5;
        Integer b = 5;
        String name = "Ada";
        int[] numbers = {1, 2, 3};
        System.out.println("a=" + a + ", b=" + b + ", name=" + name + ", numbers.length=" + numbers.length);

        System.out.println("\n--- var and final ---");
        var city = "Berlin";
        final int maxRetries = 3;
        System.out.println("city=" + city + ", maxRetries=" + maxRetries);

        System.out.println("\n--- autoboxing equality gotcha ---");
        Integer x = 200;
        Integer y = 200;
        System.out.println("x == y (200, outside cache): " + (x == y));
        System.out.println("x.equals(y): " + x.equals(y));

        Integer p = 100;
        Integer q = 100;
        System.out.println("p == q (100, inside cache -128..127): " + (p == q));
    }
}
