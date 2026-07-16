// Example.java - checked vs unchecked exceptions, custom exceptions, try-with-resources.

import java.io.IOException;
import java.io.StringReader;
import java.io.BufferedReader;

public class Example {
    static void readFile() throws IOException {
        throw new IOException("simulated failure");
    }

    static int divide(int a, int b) {
        if (b == 0) throw new ArithmeticException("Cannot divide by zero");
        return a / b;
    }

    static class ValidationException extends RuntimeException {
        private final String field;
        public ValidationException(String message, String field) {
            super(message);
            this.field = field;
        }
        public String getField() { return field; }
    }

    static int validateAge(int age) {
        if (age < 0) throw new ValidationException("Age cannot be negative", "age");
        return age;
    }

    public static void main(String[] args) {
        System.out.println("--- checked exception ---");
        try {
            readFile();
        } catch (IOException e) {
            System.out.println("Caught checked: " + e.getMessage());
        }

        System.out.println("\n--- unchecked exception ---");
        try {
            divide(10, 0);
        } catch (ArithmeticException e) {
            System.out.println("Caught unchecked: " + e.getMessage());
        }

        System.out.println("\n--- custom exception ---");
        try {
            validateAge(-5);
        } catch (ValidationException e) {
            System.out.println("Validation failed on \"" + e.getField() + "\": " + e.getMessage());
        }

        System.out.println("\n--- try-with-resources ---");
        try (BufferedReader reader = new BufferedReader(new StringReader("hello from a resource"))) {
            System.out.println("Read: " + reader.readLine());
        } catch (IOException e) {
            System.out.println("Error: " + e.getMessage());
        }
        System.out.println("Resource closed automatically after the try block.");
    }
}
