// Example.java - a "before" (bad-practice) and "after" (best-practice) contrast.

public class Example {
    static class PointClassBad {
        double x, y;
    }
    record PointGood(double x, double y) {}

    static int getDiscountedPriceBad(int price, Integer discountPercent) {
        int discount = (discountPercent != null) ? discountPercent : 10; // still misses intentional 0
        return price - (price * discount) / 100;
    }

    static int getDiscountedPrice(int price, int discountPercent) {
        return price - (price * discountPercent) / 100;
    }

    public static void main(String[] args) {
        System.out.println("=== BEFORE: == instead of .equals(), reference-equality mistake ===");
        String a = "hello";
        String b = new String("hello");
        System.out.println("a == b (BUG: expected content equality): " + (a == b));

        PointClassBad c1 = new PointClassBad();
        c1.x = 1; c1.y = 2;
        PointClassBad c2 = new PointClassBad();
        c2.x = 1; c2.y = 2;
        System.out.println("c1.equals(c2) (BUG: default Object equality is reference-based): " + c1.equals(c2));

        System.out.println("\n=== AFTER: .equals() for content, record for value equality ===");
        System.out.println("a.equals(b) (correct): " + a.equals(b));

        PointGood p1 = new PointGood(1, 2);
        PointGood p2 = new PointGood(1, 2);
        System.out.println("p1.equals(p2) (record, correct out of the box): " + p1.equals(p2));

        System.out.println("\n=== boxed Integer caching gotcha, one more time for emphasis ===");
        Integer x = 200, y = 200;
        System.out.println("x == y (200, BUG if relied upon): " + (x == y));
        System.out.println("x.equals(y) (correct): " + x.equals(y));

        System.out.println("\n=== discounted price: 0% must be honored, not treated as missing ===");
        System.out.println("getDiscountedPrice(100, 0) (correct, using a primitive int, no ambiguity): "
            + getDiscountedPrice(100, 0));
    }
}
