# Exercise 05 — Refactor to Composition

[Back to Exercises](README.md) | Covers: [Lesson 06 — Composition vs. Inheritance](../06-Composition-vs-Inheritance/README.md)

**Difficulty: Advanced**

## Task

You're given this ("bad") inheritance-only hierarchy for game characters:

```python
class Character:
    def attack(self): raise NotImplementedError

class MeleeCharacter(Character):
    def attack(self): return "swings a sword"

class FlyingMeleeCharacter(MeleeCharacter):
    def attack(self): return "dives and swings a sword"

class RangedCharacter(Character):
    def attack(self): return "shoots an arrow"

class FlyingRangedCharacter(RangedCharacter):
    def attack(self): return "dives and shoots an arrow"
```

Every new combination of **attack style** (melee, ranged, magic, ...) and **movement style** (grounded, flying, swimming, ...) requires a new subclass, and it's already visibly duplicating "dives and" across two unrelated branches.

1. Identify the two independent dimensions being multiplied together.
2. Refactor into a composition-based design: extract each dimension into its own small class/interface (e.g., an `AttackStyle` and a `MovementStyle`, each with their own method), and a `Character` class that holds one of each and combines their outputs.
3. Demonstrate that adding a third attack style (e.g., `MagicAttack`) and a third movement style (e.g., `SwimmingMovement`) requires **zero new combination classes** — just two new small classes that immediately work with everything already defined.

## Expected Behavior

Your refactored version should be able to produce (exact wording is your choice, but the combinatorial point must hold):

```python
Character(MeleeAttack(), FlyingMovement()).act()   # e.g. "Dives through the air and swings a sword"
Character(RangedAttack(), GroundedMovement()).act() # e.g. "Stands on the ground and shoots an arrow"
```

with 2 attack styles × 2 movement styles requiring only 4 small classes total (2 + 2), not 4 combination subclasses, and adding a 3rd of each requiring only 2 more classes (not 5 more).

## Reflection Questions

1. Why did the original hierarchy start duplicating the string `"dives and"` across `FlyingMeleeCharacter` and `FlyingRangedCharacter`? What OOP principle does that duplication violate?
2. If a game designer asks for a `SwimmingMagicCharacter` next, how many new classes does each design (original vs. your refactor) require?

## Deliverable

A runnable `.py` file with both the original (bad) hierarchy and your composition-based refactor, printing output from at least 2x2 combinations of the refactored version, plus written answers to both reflection questions.
