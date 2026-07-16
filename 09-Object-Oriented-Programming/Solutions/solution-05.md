# Solution 05 — Refactor to Composition

[Back to Solutions](README.md) | [Exercise](../Exercises/exercise-05-refactor-composition.md) | [Code](solution-05.py)

## Approach

The two independent dimensions hidden in the original hierarchy are **attack style** (melee, ranged, ...) and **movement style** (grounded, flying, ...). The original design encodes both dimensions as a single inheritance chain, so every new *combination* needs its own subclass — `FlyingMeleeCharacter`, `FlyingRangedCharacter`, and so on — which is exactly why `"dives and"` ends up duplicated: there's no single place in the hierarchy that means "flying" independent of "melee" or "ranged."

The refactor extracts each dimension into its own small abstract interface:

- `AttackStyle` (`abc.ABC` with an abstract `attack()`) — implemented by `MeleeAttack`, `RangedAttack`, `MagicAttack`.
- `MovementStyle` (`abc.ABC` with an abstract `move()`) — implemented by `GroundedMovement`, `FlyingMovement`, `SwimmingMovement`.

`Character` no longer inherits from anything related to combat — it simply **holds** one `AttackStyle` and one `MovementStyle` (composition: "a `Character` *has an* attack style and a movement style," not "*is a*" flying-melee-anything), and its `act()` method just concatenates both strings. Every combination of attack × movement is available immediately by passing different objects into the same `Character` constructor — no combination-specific class exists anywhere.

## Why This Design

This is the textbook case for composition over inheritance: two orthogonal, independently-varying concerns (what you attack with, how you move) were being multiplied together into a single class hierarchy. Composition lets each dimension have exactly as many classes as it has variants (2 attack + 2 movement = 4 small classes total), rather than needing one class per *combination* (2 × 2 = 4 combination classes, which would become 3 × 3 = 9 the moment a third variant of each is added).

## Verified Output

```
--- Original inheritance-only hierarchy ---
dives and swings a sword
dives and shoots an arrow

--- Composition-based refactor: 2x2 combinations ---
Dives through the air and swings a sword
Stands on the ground and shoots an arrow
Stands on the ground and swings a sword
Dives through the air and shoots an arrow

--- Adding a 3rd attack style and a 3rd movement style: zero new combo classes ---
Glides through the water and casts a fireball
Dives through the air and casts a fireball
Glides through the water and shoots an arrow
```

Confirms both the 2×2 combinatorial requirement and that adding `MagicAttack` + `SwimmingMovement` (one new class per dimension) immediately works with every existing class on the other dimension — zero new combination classes were written.

## Reflection Answers

1. `"dives and"` got duplicated across `FlyingMeleeCharacter` and `FlyingRangedCharacter` because the inheritance hierarchy could only express "flying" as a modifier bolted onto one specific attack-style branch at a time — there was no shared ancestor that meant "flying" independent of "melee" versus "ranged." This duplication violates **DRY (Don't Repeat Yourself)**, and more fundamentally reveals that inheritance was being asked to model two independent dimensions in a structure that only supports one axis of specialization per branch.

2. The original design would need one brand-new subclass, `SwimmingMagicCharacter`, and this pattern doesn't stop there — every new attack style or movement style added later needs a full new round of combination subclasses for every existing variant of the other dimension (N attack styles × M movement styles need N×M total classes). The composition-based refactor needs **zero new combination classes**: `Character(MagicAttack(), SwimmingMovement())` works immediately using two small classes that (in a real game) likely already exist because some other combination requested them — at most, 1-2 new *strategy* classes are needed only if either style is genuinely new, never a new *combination* class.
