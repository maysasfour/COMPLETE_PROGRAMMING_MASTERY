// Example.java - Observer: lets a subject notify any number of interested parties
// of a change, without hard-coding who those parties are. Demonstrated with a real
// "stale data" bug caused by hard-coded notification calls, then a fix.

import java.util.ArrayList;
import java.util.List;

public class Example {

    // ============================================================
    // VIOLATION: StockPrice directly calls specific, hard-coded display update
    // methods. Adding a NEW display means editing setPrice() itself -- and here,
    // a real developer added a new display's field but FORGOT to add the call
    // to notify it, so it silently never updates.
    // ============================================================
    static class EmailDisplayViolation {
        void update(String symbol, double price) {
            System.out.println("  [Email] " + symbol + " is now $" + price);
        }
    }

    static class MobileAppDisplayViolation {
        void update(String symbol, double price) {
            System.out.println("  [MobileApp] " + symbol + " is now $" + price);
        }
    }

    static class StockPriceViolation {
        private double price;
        private final EmailDisplayViolation emailDisplay = new EmailDisplayViolation();
        private final MobileAppDisplayViolation mobileDisplay = new MobileAppDisplayViolation(); // added later...

        void setPrice(String symbol, double price) {
            this.price = price;
            emailDisplay.update(symbol, price);
            // BUG: mobileDisplay was added as a field, but the call to notify it
            // here was forgotten -- it silently never receives updates.
        }

        double getStaleMobileDisplayCheck(String symbol) {
            // Simulates checking what the mobile display last showed, to prove it's stale.
            return -1; // never actually updated -- there's no stored "last shown" value at all
        }
    }

    // ============================================================
    // FIX: Observer pattern. StockPrice notifies a LIST of observers uniformly.
    // Adding a new observer means registering it -- ZERO changes to setPrice().
    // ============================================================
    interface StockObserver {
        void update(String symbol, double price);
    }

    static class EmailDisplay implements StockObserver {
        public void update(String symbol, double price) {
            System.out.println("  [Email] " + symbol + " is now $" + price);
        }
    }

    static class MobileAppDisplay implements StockObserver {
        double lastShownPrice = -1;
        public void update(String symbol, double price) {
            this.lastShownPrice = price;
            System.out.println("  [MobileApp] " + symbol + " is now $" + price);
        }
    }

    static class StockPrice {
        private final List<StockObserver> observers = new ArrayList<>();

        void addObserver(StockObserver observer) { observers.add(observer); }

        void setPrice(String symbol, double price) {
            for (StockObserver observer : observers) {
                observer.update(symbol, price); // EVERY registered observer is notified, uniformly
            }
        }
    }

    public static void main(String[] args) {
        System.out.println("=== Observer: fixing a real stale-data bug from hard-coded notifications ===");

        System.out.println("Violation: MobileAppDisplay was added as a field, but never wired into setPrice():");
        StockPriceViolation stockViolation = new StockPriceViolation();
        stockViolation.setPrice("ACME", 101.50);
        System.out.println("  MobileApp's last known price: " + stockViolation.getStaleMobileDisplayCheck("ACME") +
                "  <- BUG: -1 means it was NEVER actually notified, despite existing as a field!");

        System.out.println("\nFixed: StockPrice notifies EVERY registered observer -- adding one requires zero changes to setPrice():");
        StockPrice stock = new StockPrice();
        EmailDisplay email = new EmailDisplay();
        MobileAppDisplay mobile = new MobileAppDisplay();
        stock.addObserver(email);
        stock.addObserver(mobile);
        stock.setPrice("ACME", 101.50);
        System.out.println("  MobileApp's last known price: " + mobile.lastShownPrice + "  <- correct, actually received the update");

        System.out.println("\nAdding a THIRD observer requires ZERO changes to StockPrice itself:");
        class SmsDisplay implements StockObserver {
            public void update(String symbol, double price) {
                System.out.println("  [SMS] " + symbol + " is now $" + price);
            }
        }
        stock.addObserver(new SmsDisplay());
        stock.setPrice("ACME", 102.75);
    }
}
