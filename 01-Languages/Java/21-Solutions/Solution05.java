class DivisionByZeroCustomException extends RuntimeException {
    public DivisionByZeroCustomException(String message) {
        super(message);
    }
}

class InvalidNumberFormatException extends RuntimeException {
    public InvalidNumberFormatException(String message, Throwable cause) {
        super(message, cause); // preserves the original exception as getCause()
    }
}

public class Solution05 {

    static double safeDivide(double a, double b) {
        if (b == 0) {
            throw new DivisionByZeroCustomException("Cannot divide " + a + " by zero");
        }
        return a / b;
    }

    static double safeDivide(String aStr, String bStr) {
        try {
            double a = Double.parseDouble(aStr);
            double b = Double.parseDouble(bStr);
            return safeDivide(a, b);
        } catch (NumberFormatException e) {
            throw new InvalidNumberFormatException(
                    "Cannot divide '" + aStr + "' and '" + bStr + "' - invalid number format", e);
        }
    }

    public static void main(String[] args) {
        // First, confirm what plain floating-point division by zero ACTUALLY does
        // in Java, before adding a custom check on top of it -- it does NOT throw:
        System.out.println("Plain 5.0 / 0.0 (no custom check) = " + (5.0 / 0.0) + " (Infinity, not an exception)");

        String[][] pairs = { {"10", "2"}, {"5", "0"}, {"10", "abc"}, {"8", "4"} };
        for (String[] pair : pairs) {
            try {
                double result = safeDivide(pair[0], pair[1]);
                System.out.println(pair[0] + " / " + pair[1] + " = " + result);
            } catch (DivisionByZeroCustomException e) {
                System.out.println("Custom error caught: " + e.getMessage());
            } catch (InvalidNumberFormatException e) {
                System.out.println("Custom error caught: " + e.getMessage()
                        + " (caused by: " + e.getCause().getClass().getSimpleName() + ")");
            }
        }
    }
}
