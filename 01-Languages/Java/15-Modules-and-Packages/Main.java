// Main.java - the entry point, importing a class from a DIFFERENT file, in a DIFFERENT package,
// which must live in a matching com/example/utils/ subdirectory or this fails to compile.

import com.example.utils.MathHelpers;

public class Main {
    public static void main(String[] args) {
        System.out.println("MathHelpers.add(2, 3): " + MathHelpers.add(2, 3));
        System.out.println("MathHelpers.multiply(4, 5): " + MathHelpers.multiply(4, 5));
    }
}
