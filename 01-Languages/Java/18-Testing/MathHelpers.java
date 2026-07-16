// MathHelpers.java - the module under test.

public class MathHelpers {
    public static int add(int a, int b) {
        return a + b;
    }

    public static double divide(double a, double b) {
        if (b == 0) throw new ArithmeticException("Cannot divide by zero");
        return a / b;
    }
}
