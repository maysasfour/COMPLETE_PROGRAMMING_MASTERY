// Example.java - statements/expressions, and a Javadoc-documented method.

public class Example {
    /**
     * Greets a person by name.
     * @param name the name to greet
     * @return a greeting string
     */
    static String greet(String name) {
        return "Hello, " + name;
    }

    public static void main(String[] args) {
        int x = 5;
        int y = x + 1;
        System.out.println("y = " + y);
        System.out.println(greet("Ada"));
    }
}
