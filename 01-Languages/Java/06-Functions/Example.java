// Example.java - static methods, overloading (simulating default params), varargs.

public class Example {
    static String greet() {
        return greet("World");
    }
    static String greet(String name) {
        return "Hello, " + name;
    }

    static int sum(int... numbers) {
        int total = 0;
        for (int n : numbers) total += n;
        return total;
    }

    public static void main(String[] args) {
        System.out.println(greet());
        System.out.println(greet("Ada"));

        System.out.println("sum(1,2,3,4): " + sum(1, 2, 3, 4));
        System.out.println("sum(): " + sum());
    }
}
