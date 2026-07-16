// Example.java - the five SOLID principles, each shown as a real violation followed
// by a real fix. Every section is runnable and printed, not just described in prose.

import java.util.List;
import java.util.ArrayList;

public class Example {

    // ============================================================
    // S — Single Responsibility Principle
    // A class should have exactly one reason to change.
    // ============================================================

    // VIOLATION: Invoice mixes business logic (total calculation) with a completely
    // unrelated responsibility (formatting/printing). A change to the PRINT FORMAT
    // now requires touching the same class as a change to PRICING LOGIC.
    static class InvoiceViolation {
        private final List<Double> itemPrices = new ArrayList<>();

        void addItem(double price) { itemPrices.add(price); }

        double calculateTotal() {
            return itemPrices.stream().mapToDouble(Double::doubleValue).sum();
        }

        // A reason to change this class that has NOTHING to do with pricing logic:
        void printInvoice() {
            System.out.println("  Invoice total: $" + calculateTotal());
        }
    }

    // FIX: split into two classes, each with exactly one reason to change.
    static class Invoice {
        private final List<Double> itemPrices = new ArrayList<>();
        void addItem(double price) { itemPrices.add(price); }
        double calculateTotal() {
            return itemPrices.stream().mapToDouble(Double::doubleValue).sum();
        }
    }

    static class InvoicePrinter {
        void print(Invoice invoice) {
            System.out.println("  Invoice total: $" + invoice.calculateTotal());
        }
    }

    static void demoSingleResponsibility() {
        System.out.println("=== S: Single Responsibility Principle ===");
        InvoiceViolation v = new InvoiceViolation();
        v.addItem(10.0);
        v.addItem(25.0);
        System.out.println("Violation (Invoice does pricing AND printing):");
        v.printInvoice();

        Invoice invoice = new Invoice();
        invoice.addItem(10.0);
        invoice.addItem(25.0);
        InvoicePrinter printer = new InvoicePrinter();
        System.out.println("Fixed (Invoice only calculates; InvoicePrinter only prints):");
        printer.print(invoice);
    }

    // ============================================================
    // O — Open/Closed Principle
    // Open for extension, closed for modification.
    // ============================================================

    // VIOLATION: adding a new shape means editing this method's if/else chain --
    // modifying EXISTING, already-working code every time a new shape is added.
    static double areaViolation(Object shape) {
        if (shape instanceof double[] circle) {
            return Math.PI * circle[0] * circle[0]; // [radius]
        } else if (shape instanceof int[] rectangle) {
            return rectangle[0] * rectangle[1]; // [width, height]
        }
        throw new IllegalArgumentException("Unknown shape");
    }

    // FIX: new shapes are added by writing a NEW class implementing Shape --
    // zero existing code is touched.
    interface Shape {
        double area();
    }

    static class Circle implements Shape {
        final double radius;
        Circle(double radius) { this.radius = radius; }
        public double area() { return Math.PI * radius * radius; }
    }

    static class Rectangle implements Shape {
        final double width, height;
        Rectangle(double width, double height) { this.width = width; this.height = height; }
        public double area() { return width * height; }
    }

    // Adding Triangle requires NO changes to any code above -- just a new class.
    static class Triangle implements Shape {
        final double base, height;
        Triangle(double base, double height) { this.base = base; this.height = height; }
        public double area() { return 0.5 * base * height; }
    }

    static void demoOpenClosed() {
        System.out.println("\n=== O: Open/Closed Principle ===");
        System.out.println("Violation (if/else chain, must be edited for each new shape):");
        System.out.printf("  Circle area: %.2f%n", areaViolation(new double[]{2.0}));
        System.out.printf("  Rectangle area: %.2f%n", areaViolation(new int[]{3, 4}));

        System.out.println("Fixed (new Triangle added with ZERO changes to existing code):");
        List<Shape> shapes = List.of(new Circle(2.0), new Rectangle(3, 4), new Triangle(6, 4));
        for (Shape s : shapes) {
            System.out.printf("  %s area: %.2f%n", s.getClass().getSimpleName(), s.area());
        }
    }

    // ============================================================
    // L — Liskov Substitution Principle
    // Subtypes must be substitutable for their base type without breaking correctness.
    // ============================================================

    // VIOLATION: the classic Rectangle/Square problem. Square "is-a" Rectangle
    // geometrically, but forcing that inheritance breaks Rectangle's contract
    // (setWidth should not silently change height too).
    static class RectangleViolation {
        protected int width, height;
        void setWidth(int w) { this.width = w; }
        void setHeight(int h) { this.height = h; }
        int area() { return width * height; }
    }

    static class SquareViolation extends RectangleViolation {
        @Override void setWidth(int w) { this.width = w; this.height = w; } // surprising side effect
        @Override void setHeight(int h) { this.width = h; this.height = h; } // surprising side effect
    }

    static void resizeAndCheck(RectangleViolation r) {
        r.setWidth(5);
        r.setHeight(10);
        // Any caller relying on RectangleViolation's contract expects area == 50 here.
        System.out.println("  Expected area 50, got: " + r.area());
    }

    // FIX: Square and Rectangle are NOT forced into an is-a relationship. Both
    // simply implement a common Shape-like interface with no shared mutable state
    // whose contract can be violated.
    interface Quadrilateral {
        int area();
    }

    static class RectangleShape implements Quadrilateral {
        final int width, height;
        RectangleShape(int w, int h) { this.width = w; this.height = h; }
        public int area() { return width * height; }
    }

    static class SquareShape implements Quadrilateral {
        final int side;
        SquareShape(int side) { this.side = side; }
        public int area() { return side * side; }
    }

    static void demoLiskovSubstitution() {
        System.out.println("\n=== L: Liskov Substitution Principle ===");
        System.out.println("Violation (Square extends Rectangle, breaks caller's expectations):");
        resizeAndCheck(new RectangleViolation());
        System.out.print("Substituting a Square where a Rectangle is expected: ");
        resizeAndCheck(new SquareViolation()); // area is NOT 50 -- contract broken by substitution

        System.out.println("Fixed (no forced inheritance; both just implement Quadrilateral):");
        List<Quadrilateral> shapes = List.of(new RectangleShape(5, 10), new SquareShape(6));
        for (Quadrilateral q : shapes) {
            System.out.println("  " + q.getClass().getSimpleName() + " area: " + q.area());
        }
    }

    // ============================================================
    // I — Interface Segregation Principle
    // Clients shouldn't be forced to depend on methods they don't use.
    // ============================================================

    // VIOLATION: a single fat interface forces EVERY worker to implement EVERY
    // method, even ones that make no sense for that worker (a Robot can't eat()).
    interface WorkerViolation {
        void work();
        void eat();
    }

    static class HumanWorkerViolation implements WorkerViolation {
        public void work() { System.out.println("  Human working"); }
        public void eat() { System.out.println("  Human eating lunch"); }
    }

    static class RobotWorkerViolation implements WorkerViolation {
        public void work() { System.out.println("  Robot working"); }
        public void eat() { throw new UnsupportedOperationException("Robots don't eat!"); } // forced, meaningless
    }

    // FIX: segregate into smaller, focused interfaces. Implement only what applies.
    interface Workable { void work(); }
    interface Eatable { void eat(); }

    static class HumanWorker implements Workable, Eatable {
        public void work() { System.out.println("  Human working"); }
        public void eat() { System.out.println("  Human eating lunch"); }
    }

    static class RobotWorker implements Workable { // no forced, meaningless eat()
        public void work() { System.out.println("  Robot working"); }
    }

    static void demoInterfaceSegregation() {
        System.out.println("\n=== I: Interface Segregation Principle ===");
        System.out.println("Violation (Robot forced to implement eat(), throws at runtime):");
        RobotWorkerViolation robot = new RobotWorkerViolation();
        robot.work();
        try {
            robot.eat();
        } catch (UnsupportedOperationException e) {
            System.out.println("  Called eat() on a Robot -> " + e.getMessage());
        }

        System.out.println("Fixed (Robot only implements Workable; no meaningless eat() to call):");
        Workable robotFixed = new RobotWorker();
        robotFixed.work();
        Eatable humanFixed = new HumanWorker();
        humanFixed.eat();
    }

    // ============================================================
    // D — Dependency Inversion Principle
    // Depend on abstractions, not concrete implementations.
    // ============================================================

    // VIOLATION: NotificationService is hard-wired to EmailSender -- switching to
    // SMS later means editing NotificationService's source code directly.
    static class EmailSender {
        void send(String message) { System.out.println("  Email sent: " + message); }
    }

    static class NotificationServiceViolation {
        private final EmailSender sender = new EmailSender(); // concrete dependency
        void notify(String message) { sender.send(message); }
    }

    // FIX: NotificationService depends on an abstraction (MessageSender); any
    // concrete sender can be substituted without changing NotificationService at all.
    interface MessageSender {
        void send(String message);
    }

    static class EmailMessageSender implements MessageSender {
        public void send(String message) { System.out.println("  Email sent: " + message); }
    }

    static class SmsMessageSender implements MessageSender {
        public void send(String message) { System.out.println("  SMS sent: " + message); }
    }

    static class NotificationService {
        private final MessageSender sender;
        NotificationService(MessageSender sender) { this.sender = sender; } // injected abstraction
        void notify(String message) { sender.send(message); }
    }

    static void demoDependencyInversion() {
        System.out.println("\n=== D: Dependency Inversion Principle ===");
        System.out.println("Violation (NotificationService hard-wired to EmailSender):");
        new NotificationServiceViolation().notify("Order shipped");

        System.out.println("Fixed (NotificationService depends on the MessageSender abstraction):");
        new NotificationService(new EmailMessageSender()).notify("Order shipped");
        new NotificationService(new SmsMessageSender()).notify("Order shipped"); // swapped with ZERO changes to NotificationService
    }

    public static void main(String[] args) {
        demoSingleResponsibility();
        demoOpenClosed();
        demoLiskovSubstitution();
        demoInterfaceSegregation();
        demoDependencyInversion();
    }
}
