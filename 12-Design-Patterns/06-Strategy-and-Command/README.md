# 06 — Strategy and Command

[Back to module overview](../README.md) | [Previous: Observer](../05-Observer/README.md)

## Beginner: Two Behavioral Patterns

**Strategy** lets an algorithm be selected at runtime through a clean lookup or injected object, instead of a branching chain that can accidentally shadow entries depending on their order. **Command** encapsulates a request as an object, capturing everything needed to properly undo it. Both are demonstrated here as real, verified bugs.

## Strategy: A Real Order-Dependent Branching Bug

The violation determines tax rate through an `if`/`else if` chain. A later developer added Canada's rate, but by copy-paste mistake also added `"CA"` to the EU-country check **above** it:

```java
static boolean isEuCountryViolation(String country) {
    return country.equals("DE") || country.equals("FR") || country.equals("CA"); // shouldn't be here!
}
static double taxRateViolation(String country) {
    if (country.equals("US")) return 0.08;
    else if (isEuCountryViolation(country)) return 0.20; // matches Canada FIRST
    else if (country.equals("CA")) return 0.13; // unreachable for Canada!
    return 0.0;
}
```

Verified live — Canada gets the EU rate (20%), not its own correct rate (13%), because the EU check runs first and matches:

```
Canada's tax rate: 20%  <- BUG: should be 13%, but the EU check matches first!
```

The fix replaces the branching chain with a direct lookup — a `Map<String, TaxStrategy>` — where each country's rate is looked up independently, with no possibility of one entry shadowing another regardless of insertion or check order:

```
Canada's tax rate: 13%  <- correct
Germany's tax rate: 20%  <- correct, unaffected by Canada's entry
```

## Command: A Real Undo Bug From Not Tracking Real Previous State

The violation implements "undo" by remembering only *what kind* of action happened, not the actual state before it:

```java
void pressSetBrightness(int newBrightness) {
    lastAction = "brightness";
    light.brightness = newBrightness; // the OLD value is never recorded!
}
void pressUndo() {
    if ("brightness".equals(lastAction)) light.brightness = 50; // hardcoded default!
}
```

Verified live — starting at brightness 80, setting it to 30, then undoing, restores the wrong value:

```
Brightness after undo: 50  <- BUG: should be 80 (the real previous value), but it's hardcoded to 50!
```

The fix encapsulates the action as a `Command` object that captures its *own* previous state **before** executing:

```java
class SetBrightnessCommand implements Command {
    private int previousBrightness;
    public void execute() {
        previousBrightness = light.brightness; // captured BEFORE changing anything
        light.brightness = newBrightness;
    }
    public void undo() {
        light.brightness = previousBrightness; // restores the ACTUAL previous value
    }
}
```

Verified live — the same scenario now correctly restores the real previous value:

```
Brightness after undo: 80  <- correct: restored to the REAL previous value, 80
```

## Detailed Example

See [Example.java](Example.java) — both a real Strategy bug and a real Command bug, each with a verified fix.

## Run It

```bash
cd 12-Design-Patterns/06-Strategy-and-Command
javac Example.java
java Example
```

## Expected Output

A Strategy section showing Canada incorrectly taxed at the EU rate (20% instead of 13%) in the violation, then correctly taxed in the fix; a Command section showing a brightness incorrectly restored to a hardcoded 50 in the violation, then correctly restored to the real previous value (80) in the fix.

## Common Mistakes

- Using an `if`/`else if` chain for algorithm/rate selection where entries can accidentally overlap or shadow each other depending on order — verified live to let one country's tax rate be silently overridden by an unrelated, earlier-matching branch.
- Implementing "undo" by remembering only the *type* of the last action rather than its actual previous state — verified live to restore a hardcoded, wrong default instead of the genuine previous value.
- Forgetting that undo/redo history needs to be a proper stack (or similar) if multiple undoable actions can occur in sequence — a single "last action" variable (as in the violation) cannot support undoing more than one step back.

## Best Practices

- Prefer a direct lookup (a `Map` from key to strategy) over a branching chain whenever selection doesn't inherently depend on order — it eliminates the entire category of shadowing bugs demonstrated here.
- Have each `Command` capture whatever state it needs to properly undo itself, captured at execution time, not assumed or hardcoded.
- Maintain undo history as an explicit stack of executed commands, so multiple sequential actions can each be undone correctly, one at a time.

## Real-World Usage

Strategy is the standard way to make an algorithm swappable at runtime (compression algorithms, sorting comparators, payment methods) without fragile conditional branching — directly related to [Composition over Inheritance](../../11-Design-Principles/04-Composition-over-Inheritance/README.md), which this pattern is built on. Command is the foundation of undo/redo systems in editors and IDEs, transaction logs, and task queues where an action needs to be represented as a first-class object that can be stored, logged, retried, or reversed.

## Summary

- Strategy replaces order-dependent branching with direct lookup, verified live to prevent a real tax-rate bug where one country's rate was silently shadowed by another's check.
- Command encapsulates an action's own state needed for undo, verified live to correctly restore a light's actual previous brightness instead of a hardcoded default.
- Both patterns are, at their core, applications of composition (Strategy) and encapsulation (Command) from [11-Design-Principles](../../11-Design-Principles/README.md) to specific, recurring problem shapes.

## Key Terms

- **Strategy** — a design pattern that encapsulates an interchangeable algorithm/behavior behind a common interface, selected at runtime.
- **Command** — a design pattern that encapsulates a request/action as an object, including enough information to undo it.
- **Order-dependent branching bug** — a bug where an `if`/`else if` chain's behavior depends on the order of its conditions, allowing one branch to unintentionally shadow another.

## Interview Questions

1. **How did an order-dependent `if`/`else if` chain cause a real tax-calculation bug in this lesson, and how does Strategy prevent it?**
   The violation checked `isEuCountryViolation(country)` (which, due to a copy-paste mistake, incorrectly included `"CA"`) *before* checking for `"CA"` specifically — so Canada's request always matched the EU branch first, returning 20% instead of the correct 13%, verified live by the actual computed rate. Strategy prevents this entirely by using a direct lookup (`Map<String, TaxStrategy>`) instead of sequential branching — each country's rate is retrieved independently by key, so there is no possible ordering for one entry to shadow another; this was verified by both Canada's and Germany's rates being computed correctly and independently after the fix.

2. **Why did the naive undo implementation in this lesson restore the wrong value, and how does Command fix it?**
   The naive implementation (`RemoteControlViolation`) only remembered *which kind* of action was last performed (`"brightness"`), not the actual value the brightness held *before* that action — so its undo logic had no real data to restore and fell back to a hardcoded default (`50`), which was verified live to be wrong when the actual previous value was 80. The Command-based fix (`SetBrightnessCommand`) captures the real previous value (`previousBrightness = light.brightness`) at the moment the command executes, before making any change, so `undo()` can restore the genuine prior state — verified live to correctly restore 80, not a hardcoded guess.

## Recommended Next Lesson

This is the final lesson in the Design Patterns module. Continue to [13-Software-Architecture](../../13-Software-Architecture/README.md) if built, or return to the [module overview](../README.md).
