// Example.java - Layered (N-tier) Architecture: separates a system into layers
// (presentation, business/service, data access), where each layer only talks to
// the one directly beneath it. Demonstrated with a real data-integrity bug caused
// by a layer skipping past the layer that owns validation, then a fix.

import java.util.ArrayList;
import java.util.List;

public class Example {

    static class Order {
        final String product;
        final int quantity;
        Order(String product, int quantity) { this.product = product; this.quantity = quantity; }
        @Override public String toString() { return quantity + "x " + product; }
    }

    // ============================================================
    // Data access layer
    // ============================================================
    static class OrderRepository {
        private final List<Order> savedOrders = new ArrayList<>();
        void save(Order order) { savedOrders.add(order); }
        List<Order> findAll() { return savedOrders; }
    }

    // ============================================================
    // Business/service layer -- this is where validation belongs
    // ============================================================
    static class OrderService {
        private final OrderRepository repository;
        OrderService(OrderRepository repository) { this.repository = repository; }

        void placeOrder(String product, int quantity) {
            if (quantity <= 0) {
                throw new IllegalArgumentException("Quantity must be positive, got: " + quantity);
            }
            repository.save(new Order(product, quantity));
        }
    }

    // ============================================================
    // VIOLATION: the "presentation layer" reaches past the service layer and
    // calls the repository DIRECTLY -- skipping the validation that only the
    // service layer actually implements.
    // ============================================================
    static void presentationLayerViolation(OrderRepository repository) {
        System.out.println("Violation: presentation layer calls OrderRepository DIRECTLY, skipping OrderService:");
        repository.save(new Order("Widget", -5)); // no validation ever runs -- straight to storage!
        System.out.println("  Orders now in the repository: " + repository.findAll() +
                "  <- BUG: a NEGATIVE quantity order was saved, because validation was bypassed!");
    }

    // ============================================================
    // FIX: the presentation layer only ever talks to the service layer. The
    // service layer's validation cannot be bypassed, because there is no other
    // path to the repository available to the presentation layer.
    // ============================================================
    static void presentationLayerFixed(OrderService service, OrderRepository repository) {
        System.out.println("Fixed: presentation layer only talks to OrderService -- validation cannot be skipped:");
        try {
            service.placeOrder("Widget", -5);
            System.out.println("  (should not reach here)");
        } catch (IllegalArgumentException e) {
            System.out.println("  Rejected: " + e.getMessage());
        }
        System.out.println("  Orders now in the repository: " + repository.findAll() +
                "  <- correct: the invalid order was never saved");

        service.placeOrder("Widget", 3); // a genuinely valid order
        System.out.println("  Orders now in the repository: " + repository.findAll() + "  <- the valid order WAS saved");
    }

    public static void main(String[] args) {
        System.out.println("=== Layered Architecture: a real bug from skipping the validation layer ===");
        OrderRepository repository = new OrderRepository();
        presentationLayerViolation(repository);

        System.out.println();
        OrderRepository repository2 = new OrderRepository();
        OrderService service = new OrderService(repository2);
        presentationLayerFixed(service, repository2);
    }
}
