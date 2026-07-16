// Example.java - Event-Driven Architecture: a component publishes an event and
// moves on; interested subscribers react independently, and one subscriber's
// failure does not block the publisher or other subscribers. Demonstrated with a
// real reliability bug caused by tight synchronous coupling, then a fix.

import java.util.ArrayList;
import java.util.List;

public class Example {

    // ============================================================
    // VIOLATION: OrderService calls every downstream concern SYNCHRONOUSLY and
    // directly. A failure in a NON-CRITICAL concern (analytics) propagates up
    // and prevents the order from ever being marked as fully processed -- even
    // though inventory and email had ALREADY succeeded.
    // ============================================================
    static class InventoryServiceViolation {
        void decrement(String orderId) { System.out.println("  [Inventory] stock decremented for " + orderId); }
    }

    static class EmailServiceViolation {
        void send(String orderId) { System.out.println("  [Email] confirmation sent for " + orderId); }
    }

    static class AnalyticsServiceViolation {
        void log(String orderId) {
            throw new RuntimeException("Analytics service is down!"); // a NON-CRITICAL dependency, but unguarded
        }
    }

    static class OrderServiceViolation {
        private final InventoryServiceViolation inventory = new InventoryServiceViolation();
        private final EmailServiceViolation email = new EmailServiceViolation();
        private final AnalyticsServiceViolation analytics = new AnalyticsServiceViolation();

        void placeOrder(String orderId) {
            System.out.println("Order " + orderId + " placed.");
            inventory.decrement(orderId);
            email.send(orderId);
            analytics.log(orderId); // if this throws, EVERYTHING below never runs
            System.out.println("Order " + orderId + " fully processed."); // never reached!
        }
    }

    static void demoViolation() {
        System.out.println("=== Violation: a non-critical dependency's failure blocks the whole operation ===");
        OrderServiceViolation service = new OrderServiceViolation();
        try {
            service.placeOrder("ORD-1");
        } catch (RuntimeException e) {
            System.out.println("  Caught: " + e.getMessage());
            System.out.println("  BUG: \"Order fully processed\" was NEVER printed -- a failing ANALYTICS call" );
            System.out.println("  blocked the entire order, even though inventory and email had already succeeded!");
        }
    }

    // ============================================================
    // FIX: Event-Driven Architecture. OrderService publishes an event and moves
    // on; each subscriber's failure is isolated -- it cannot block the
    // publisher or any other subscriber.
    // ============================================================
    interface OrderEventListener {
        void onOrderPlaced(String orderId);
    }

    static class EventBus {
        private final List<OrderEventListener> listeners = new ArrayList<>();
        void subscribe(OrderEventListener listener) { listeners.add(listener); }
        void publish(String orderId) {
            for (OrderEventListener listener : listeners) {
                try {
                    listener.onOrderPlaced(orderId);
                } catch (Exception e) {
                    // A subscriber's failure is contained HERE -- it never
                    // reaches the publisher or any other subscriber.
                    System.out.println("  [EventBus] a listener failed, but did NOT block anything else: " + e.getMessage());
                }
            }
        }
    }

    static class OrderService {
        private final EventBus eventBus;
        OrderService(EventBus eventBus) { this.eventBus = eventBus; }

        void placeOrder(String orderId) {
            System.out.println("Order " + orderId + " placed.");
            eventBus.publish(orderId); // fire the event; subscriber failures are isolated
            System.out.println("Order " + orderId + " fully processed."); // ALWAYS reached
        }
    }

    static void demoFixed() {
        System.out.println("\n=== Fixed: Event-Driven Architecture isolates subscriber failures ===");
        EventBus bus = new EventBus();
        bus.subscribe(orderId -> System.out.println("  [Inventory] stock decremented for " + orderId));
        bus.subscribe(orderId -> System.out.println("  [Email] confirmation sent for " + orderId));
        bus.subscribe(orderId -> { throw new RuntimeException("Analytics service is down!"); }); // the SAME failure as before

        OrderService service = new OrderService(bus);
        service.placeOrder("ORD-2");
        System.out.println("  ^ correct: \"fully processed\" WAS printed, even though the analytics listener failed exactly as before");
    }

    public static void main(String[] args) {
        demoViolation();
        demoFixed();
    }
}
