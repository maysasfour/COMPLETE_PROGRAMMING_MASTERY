// Example.java - Composition over Inheritance: a real "fragile base class" bug
// caused by blind inheritance, then a fix using composition (a has-a relationship
// with an injected, swappable behavior) instead of forced is-a inheritance.

import java.util.List;

public class Example {

    // ============================================================
    // VIOLATION: inheritance forces EVERY subclass to inherit startEngine(),
    // even ones for which "starting an engine" makes no real sense.
    // ============================================================

    static class VehicleViolation {
        String startEngine() {
            return "Vroom! Engine started.";
        }
    }

    static class GasCarViolation extends VehicleViolation {
        // Inherits startEngine() unchanged -- correct for a gas car.
    }

    static class ElectricCarViolation extends VehicleViolation {
        // BUG: inherits the SAME startEngine() from VehicleViolation --
        // an electric car has no combustion engine, so "Vroom! Engine started."
        // is a real, nonsensical, wrong behavior forced onto it purely by inheritance.
    }

    // ============================================================
    // FIX: composition. Vehicle HAS-A PowerSource (an injected, swappable
    // behavior), rather than inheriting a single, hard-coded implementation.
    // ============================================================

    interface PowerSource {
        String start();
    }

    static class CombustionEngine implements PowerSource {
        public String start() { return "Vroom! Engine started."; }
    }

    static class ElectricMotor implements PowerSource {
        public String start() { return "Hummm... electric motor engaged silently."; }
    }

    static class Vehicle {
        private final PowerSource powerSource; // composition: a HAS-A relationship
        Vehicle(PowerSource powerSource) { this.powerSource = powerSource; }
        String start() { return powerSource.start(); }
    }

    static void demoCompositionOverInheritance() {
        System.out.println("=== Composition over Inheritance: a real fragile-base-class bug ===");

        System.out.println("Violation: ElectricCar inherits startEngine() from Vehicle unchanged:");
        System.out.println("  GasCar:      " + new GasCarViolation().startEngine());
        System.out.println("  ElectricCar: " + new ElectricCarViolation().startEngine() +
                "  <- WRONG: an electric car has no engine that \"vrooms\"!");

        System.out.println("\nFixed: Vehicle is composed with an injected, swappable PowerSource:");
        Vehicle gasCar = new Vehicle(new CombustionEngine());
        Vehicle electricCar = new Vehicle(new ElectricMotor());
        System.out.println("  GasCar:      " + gasCar.start());
        System.out.println("  ElectricCar: " + electricCar.start() + "  <- correct, distinct behavior");

        System.out.println("\nAdding a HybridCar requires ZERO changes to Vehicle -- just a new PowerSource:");
        class HybridPowerSource implements PowerSource {
            public String start() { return "Vroom + Hummm... hybrid power engaged."; }
        }
        Vehicle hybridCar = new Vehicle(new HybridPowerSource());
        System.out.println("  HybridCar:   " + hybridCar.start());

        System.out.println("\nAll vehicles can be treated uniformly through the same Vehicle API:");
        for (Vehicle v : List.of(gasCar, electricCar, hybridCar)) {
            System.out.println("  -> " + v.start());
        }
    }

    public static void main(String[] args) {
        demoCompositionOverInheritance();
    }
}
