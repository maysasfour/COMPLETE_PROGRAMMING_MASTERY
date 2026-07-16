// Solution01.java - overloaded describe methods.

public class Solution01 {
    static String describe(int n) {
        return "int: " + n;
    }
    static String describe(String s) {
        return "String: " + s;
    }
    static String describe(int n, String unit) {
        return n + " " + unit;
    }

    public static void main(String[] args) {
        System.out.println(describe(42));
        System.out.println(describe("hello"));
        System.out.println(describe(5, "km"));
    }
}
