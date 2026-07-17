# Design Principles Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../11-Design-Principles/README.md)

## SOLID
| Letter | Principle | Verified finding |
|---|---|---|
| S | Single Responsibility — one class, one reason to change | Splitting pricing from printing fixed a mixed-concern class |
| O | Open/Closed — extend via new code, not edits | Adding `Triangle` required zero changes to existing shape code |
| L | Liskov Substitution — subtypes must honor the base contract | `Square extends Rectangle` silently produced a wrong area (100 instead of 50) |
| I | Interface Segregation — don't force unneeded methods | A `RobotWorker` forced to implement `eat()` threw at runtime |
| D | Dependency Inversion — depend on abstractions | Swapping `EmailSender` for `SmsSender` required zero changes to the dependent class |

See [11-Design-Principles/01-SOLID-Principles](../../11-Design-Principles/01-SOLID-Principles/README.md) for all five, verified live.

## DRY, KISS, YAGNI
- **DRY** (Don't Repeat Yourself): a duplicated discount rule drifted from 10% to 15% between two copies.
- **KISS** (Keep It Simple): a "clever" bit-trick was actually wrong for `n=0`; the simple version was correct.
- **YAGNI** (You Aren't Gonna Need It): unused, speculative code contained a real, unnoticed bug.

See [11-Design-Principles/02-DRY-KISS-YAGNI](../../11-Design-Principles/02-DRY-KISS-YAGNI/README.md).

## Coupling and Cohesion
- **Tight coupling** to internal representation: a `Display` reading a `Thermometer`'s raw Fahrenheit field mislabeled it as Celsius.
- **Low cohesion**: mixing header formatting and discount calculation in one class let them silently clobber shared state.

See [11-Design-Principles/03-Coupling-and-Cohesion](../../11-Design-Principles/03-Coupling-and-Cohesion/README.md).

## Composition over Inheritance
An `ElectricCar extends Vehicle` inheriting `startEngine()` produced the nonsensical "Vroom!" for a car with no combustion engine — composition (a `PowerSource` interface) fixed it and let a `HybridPowerSource` be added with zero changes elsewhere.

See [11-Design-Principles/04-Composition-over-Inheritance](../../11-Design-Principles/04-Composition-over-Inheritance/README.md).

## Quick Reference Table
| Smell | Principle it violates |
|---|---|
| A class doing "and" two unrelated things | Single Responsibility |
| Editing existing code for every new case | Open/Closed |
| A subclass that breaks callers of the base type | Liskov Substitution |
| A fat interface forcing irrelevant methods | Interface Segregation |
| `new ConcreteClass()` inside a business-logic class | Dependency Inversion |
| Same logic copy-pasted in two places | DRY |
| A clever one-liner nobody can verify by eye | KISS |
| Code for a feature nobody asked for yet | YAGNI |

See the [full Design Principles module](../../11-Design-Principles/README.md) for verified, runnable code for every principle above.
