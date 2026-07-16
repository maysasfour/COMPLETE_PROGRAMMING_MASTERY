// MathHelpers.cs - the module under test.

public class MathHelpers {
    public static int Add(int a, int b) => a + b;

    public static double Divide(double a, double b) {
        if (b == 0) throw new ArgumentException("Cannot divide by zero");
        return a / b;
    }
}
