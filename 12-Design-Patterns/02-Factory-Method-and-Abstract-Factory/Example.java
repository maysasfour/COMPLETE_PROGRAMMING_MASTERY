// Example.java - Factory Method (centralizing HOW a single object is created) and
// Abstract Factory (centralizing how a whole FAMILY of related objects is created
// consistently), each shown with a real bug caused by scattered/independent object
// creation, then a fix.

public class Example {

    // ============================================================
    // FACTORY METHOD
    // ============================================================

    interface Notification { void send(String message); }

    static class EmailNotification implements Notification {
        public void send(String message) { System.out.println("  [Email] " + message); }
    }

    static class SmsNotification implements Notification {
        public void send(String message) { System.out.println("  [SMS] " + message); }
    }

    // VIOLATION: object-creation logic is scattered and duplicated across every
    // call site. When SMS support was added, the branch was updated in
    // confirmOrder() but the SAME edit was forgotten in cancelOrder() -- a real,
    // classic copy-paste drift bug (the same failure mode as DRY violations).
    static class OrderServiceViolation {
        void confirmOrder(String method) {
            Notification n = method.equals("email") ? new EmailNotification() : new SmsNotification();
            n.send("Order confirmed");
        }

        void cancelOrder(String method) {
            // BUG: this branch was never updated to handle "sms" -- it always
            // falls through to Email, even when the caller asked for "sms".
            Notification n = method.equals("email") ? new EmailNotification() : new EmailNotification();
            n.send("Order cancelled");
        }
    }

    // FIX: all creation logic lives in exactly ONE place. Every caller asks the
    // factory for what it needs; there is no second copy of the creation logic
    // left to drift out of sync.
    static class NotificationFactory {
        static Notification create(String method) {
            return method.equals("email") ? new EmailNotification() : new SmsNotification();
        }
    }

    static class OrderService {
        void confirmOrder(String method) { NotificationFactory.create(method).send("Order confirmed"); }
        void cancelOrder(String method) { NotificationFactory.create(method).send("Order cancelled"); }
    }

    static void demoFactoryMethod() {
        System.out.println("=== Factory Method: centralizing scattered creation logic ===");
        OrderServiceViolation violationService = new OrderServiceViolation();
        System.out.println("Violation: cancelOrder(\"sms\") should send an SMS, but the branch was never updated:");
        violationService.cancelOrder("sms");
        System.out.println("  ^ BUG: that was actually sent as an Email, not SMS!");

        OrderService service = new OrderService();
        System.out.println("Fixed: both confirmOrder and cancelOrder use the SAME NotificationFactory:");
        service.confirmOrder("sms");
        service.cancelOrder("sms");
    }

    // ============================================================
    // ABSTRACT FACTORY
    // ============================================================

    interface Button { String render(); }
    interface Checkbox { String render(); }

    static class LightButton implements Button { public String render() { return "[Light Button]"; } }
    static class DarkButton implements Button { public String render() { return "[Dark Button]"; } }
    static class LightCheckbox implements Checkbox { public String render() { return "[Light Checkbox]"; } }
    static class DarkCheckbox implements Checkbox { public String render() { return "[Dark Checkbox]"; } }

    // VIOLATION: button and checkbox are chosen by two INDEPENDENT flags. Nothing
    // enforces they stay in the same "family" -- a real config mistake mixes them.
    static class ScreenViolation {
        final Button button;
        final Checkbox checkbox;
        ScreenViolation(boolean darkButton, boolean darkCheckbox) {
            this.button = darkButton ? new DarkButton() : new LightButton();
            this.checkbox = darkCheckbox ? new DarkCheckbox() : new LightCheckbox();
        }
    }

    // FIX: an Abstract Factory produces a WHOLE matched family from one object,
    // so it's structurally impossible to end up with mismatched components.
    interface UIFactory {
        Button createButton();
        Checkbox createCheckbox();
    }

    static class LightUIFactory implements UIFactory {
        public Button createButton() { return new LightButton(); }
        public Checkbox createCheckbox() { return new LightCheckbox(); }
    }

    static class DarkUIFactory implements UIFactory {
        public Button createButton() { return new DarkButton(); }
        public Checkbox createCheckbox() { return new DarkCheckbox(); }
    }

    static class Screen {
        final Button button;
        final Checkbox checkbox;
        Screen(UIFactory factory) {
            this.button = factory.createButton();
            this.checkbox = factory.createCheckbox();
        }
    }

    static void demoAbstractFactory() {
        System.out.println("\n=== Abstract Factory: guaranteeing a consistent family of related objects ===");
        System.out.println("Violation: two INDEPENDENT flags -- a real config mistake mixes themes:");
        ScreenViolation mismatched = new ScreenViolation(true, false); // meant dark+dark, config bug gave dark+light
        System.out.println("  " + mismatched.button.render() + " + " + mismatched.checkbox.render() +
                "  <- BUG: mismatched theme, should have been both Dark or both Light!");

        System.out.println("Fixed: ONE factory produces the WHOLE matched family -- mismatching is impossible:");
        Screen darkScreen = new Screen(new DarkUIFactory());
        Screen lightScreen = new Screen(new LightUIFactory());
        System.out.println("  " + darkScreen.button.render() + " + " + darkScreen.checkbox.render() + "  <- consistent");
        System.out.println("  " + lightScreen.button.render() + " + " + lightScreen.checkbox.render() + "  <- consistent");
    }

    public static void main(String[] args) {
        demoFactoryMethod();
        demoAbstractFactory();
    }
}
