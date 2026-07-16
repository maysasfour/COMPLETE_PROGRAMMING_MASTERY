// Example.java - Strategy (swapping an algorithm at runtime, avoiding fragile
// order-dependent if/else chains) and Command (encapsulating an action as an object
// so it can be properly undone), each shown with a real bug and a fix.

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Map;

public class Example {

    // ============================================================
    // STRATEGY
    // ============================================================

    // VIOLATION: tax rate chosen via an ORDER-DEPENDENT if/else chain. A later
    // developer added Canada's rate but, by copy-paste mistake, placed it AFTER
    // the "is this an EU country" check -- and Canada was accidentally left in
    // the EU country list too. The result: Canada gets the WRONG rate, because
    // the EU branch runs first and matches before the Canada-specific branch
    // is ever reached.
    static boolean isEuCountryViolation(String country) {
        return country.equals("DE") || country.equals("FR") || country.equals("CA"); // BUG: "CA" doesn't belong here!
    }

    static double taxRateViolation(String country) {
        if (country.equals("US")) return 0.08;
        else if (isEuCountryViolation(country)) return 0.20; // this runs BEFORE the Canada check below
        else if (country.equals("CA")) return 0.13; // unreachable for "CA" -- the EU check already matched it!
        return 0.0;
    }

    // FIX: Strategy pattern. Each country's rate is looked up directly, with no
    // order-dependent branching at all -- there's no way for one entry to
    // accidentally shadow another.
    interface TaxStrategy {
        double rate();
    }

    static final Map<String, TaxStrategy> TAX_STRATEGIES = Map.of(
            "US", () -> 0.08,
            "DE", () -> 0.20,
            "FR", () -> 0.20,
            "CA", () -> 0.13
    );

    static double taxRate(String country) {
        TaxStrategy strategy = TAX_STRATEGIES.get(country);
        return strategy == null ? 0.0 : strategy.rate();
    }

    static void demoStrategy() {
        System.out.println("=== Strategy: fixing an order-dependent if/else tax bug ===");
        System.out.println("Violation: Canada was accidentally added to the EU-country check, AND has its own branch:");
        System.out.printf("  Canada's tax rate: %.0f%%  <- BUG: should be 13%%, but the EU check matches first!%n",
                taxRateViolation("CA") * 100);

        System.out.println("Fixed: each country's strategy is looked up directly -- no branch order to get wrong:");
        System.out.printf("  Canada's tax rate: %.0f%%  <- correct%n", taxRate("CA") * 100);
        System.out.printf("  Germany's tax rate: %.0f%%  <- correct, unaffected by Canada's entry%n", taxRate("DE") * 100);
    }

    // ============================================================
    // COMMAND
    // ============================================================

    static class LightViolation {
        boolean on = false;
        int brightness = 50;
    }

    // VIOLATION: undo is implemented naively by remembering only WHAT KIND of
    // action happened, not the actual PREVIOUS state -- so undoing a brightness
    // change resets to a hard-coded default, not the real previous value.
    static class RemoteControlViolation {
        private final LightViolation light;
        private String lastAction;
        RemoteControlViolation(LightViolation light) { this.light = light; }

        void pressOn() { lastAction = "on"; light.on = true; }
        void pressSetBrightness(int newBrightness) {
            lastAction = "brightness";
            light.brightness = newBrightness; // the OLD value is never recorded anywhere!
        }
        void pressUndo() {
            if ("on".equals(lastAction)) light.on = false;
            else if ("brightness".equals(lastAction)) light.brightness = 50; // BUG: hardcoded default, not the real previous value!
        }
    }

    // FIX: Command pattern. Each command captures its OWN previous state before
    // executing, so undo restores exactly what was there before -- correctly,
    // no matter what the previous value actually was.
    static class LightCmd {
        boolean on = false;
        int brightness = 50;
    }

    interface Command {
        void execute();
        void undo();
    }

    static class SetBrightnessCommand implements Command {
        private final LightCmd light;
        private final int newBrightness;
        private int previousBrightness;

        SetBrightnessCommand(LightCmd light, int newBrightness) {
            this.light = light;
            this.newBrightness = newBrightness;
        }

        public void execute() {
            previousBrightness = light.brightness; // captured BEFORE changing anything
            light.brightness = newBrightness;
        }

        public void undo() {
            light.brightness = previousBrightness; // restores the ACTUAL previous value
        }
    }

    static class RemoteControl {
        private final Deque<Command> history = new ArrayDeque<>();
        void execute(Command command) {
            command.execute();
            history.push(command);
        }
        void pressUndo() {
            if (!history.isEmpty()) history.pop().undo();
        }
    }

    static void demoCommand() {
        System.out.println("\n=== Command: fixing a real undo bug from not tracking real previous state ===");

        LightViolation lightV = new LightViolation();
        lightV.brightness = 80; // starts at 80
        RemoteControlViolation remoteV = new RemoteControlViolation(lightV);
        System.out.println("Violation: light starts at brightness 80, then set to 30, then undo:");
        remoteV.pressSetBrightness(30);
        remoteV.pressUndo();
        System.out.println("  Brightness after undo: " + lightV.brightness +
                "  <- BUG: should be 80 (the real previous value), but it's hardcoded to 50!");

        LightCmd lightC = new LightCmd();
        lightC.brightness = 80; // starts at 80
        RemoteControl remote = new RemoteControl();
        System.out.println("Fixed: the SAME scenario, using Command to properly capture previous state:");
        remote.execute(new SetBrightnessCommand(lightC, 30));
        remote.pressUndo();
        System.out.println("  Brightness after undo: " + lightC.brightness + "  <- correct: restored to the REAL previous value, 80");
    }

    public static void main(String[] args) {
        demoStrategy();
        demoCommand();
    }
}
