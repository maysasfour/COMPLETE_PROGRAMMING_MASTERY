// Example.java - polymorphism (overridable by default), interfaces with default methods,
// abstract classes, and record vs plain-class equality.

public class Example {
    static class Animal {
        private final String name;
        public Animal(String name) { this.name = name; }
        public String getName() { return name; }
        public String speak() { return name + " makes a sound"; }
    }

    static class Dog extends Animal {
        public Dog(String name) { super(name); }
        @Override
        public String speak() { return getName() + " says Woof"; }
    }

    interface Shape {
        double area();
        default String describe() { return "Area: " + String.format("%.2f", area()); }
    }

    static abstract class ShapeBase implements Shape {
        public abstract double area();
    }

    static class Circle extends ShapeBase {
        private final double radius;
        public Circle(double radius) { this.radius = radius; }
        public double area() { return Math.PI * radius * radius; }
    }

    record Point(double x, double y) {}

    static class PointClass { double x, y; }

    public static void main(String[] args) {
        System.out.println("--- polymorphism (overridable by default) ---");
        Animal a = new Dog("Rex");
        System.out.println(a.speak());

        System.out.println("\n--- interface default method + abstract class ---");
        ShapeBase circle = new Circle(3);
        System.out.println(circle.describe());

        System.out.println("\n--- record vs plain-class equality ---");
        Point p1 = new Point(1, 2);
        Point p2 = new Point(1, 2);
        System.out.println("p1.equals(p2) (record, value equality): " + p1.equals(p2));
        System.out.println("p1.toString() (auto-generated): " + p1);

        PointClass c1 = new PointClass();
        PointClass c2 = new PointClass();
        System.out.println("c1.equals(c2) (plain class, reference equality): " + c1.equals(c2));
    }
}
