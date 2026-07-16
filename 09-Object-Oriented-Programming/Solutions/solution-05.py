"""Solution to Exercise 05 -- Refactor to Composition."""

from abc import ABC, abstractmethod


# ---------------------------------------------------------------------------
# The original ("bad") inheritance-only hierarchy, kept verbatim for comparison.
# ---------------------------------------------------------------------------
class BadCharacter:
    def attack(self):
        raise NotImplementedError


class MeleeCharacter(BadCharacter):
    def attack(self):
        return "swings a sword"


class FlyingMeleeCharacter(MeleeCharacter):
    def attack(self):
        return "dives and swings a sword"


class RangedCharacter(BadCharacter):
    def attack(self):
        return "shoots an arrow"


class FlyingRangedCharacter(RangedCharacter):
    def attack(self):
        return "dives and shoots an arrow"


# ---------------------------------------------------------------------------
# Composition-based refactor.
#
# The two independent dimensions being multiplied together are:
#   1. Attack style   (melee, ranged, magic, ...)
#   2. Movement style  (grounded, flying, swimming, ...)
# Inheritance forces one subclass PER COMBINATION; composition lets Character hold
# one of each and combine their outputs, so the two dimensions vary independently.
# ---------------------------------------------------------------------------
class AttackStyle(ABC):
    @abstractmethod
    def attack(self) -> str: ...


class MeleeAttack(AttackStyle):
    def attack(self) -> str:
        return "swings a sword"


class RangedAttack(AttackStyle):
    def attack(self) -> str:
        return "shoots an arrow"


class MagicAttack(AttackStyle):
    def attack(self) -> str:
        return "casts a fireball"


class MovementStyle(ABC):
    @abstractmethod
    def move(self) -> str: ...


class GroundedMovement(MovementStyle):
    def move(self) -> str:
        return "Stands on the ground"


class FlyingMovement(MovementStyle):
    def move(self) -> str:
        return "Dives through the air"


class SwimmingMovement(MovementStyle):
    def move(self) -> str:
        return "Glides through the water"


class Character:
    def __init__(self, attack_style: AttackStyle, movement_style: MovementStyle):
        # HAS-A relationships: a Character holds an attack style and a movement style rather
        # than inheriting from a fused combination of the two.
        self.attack_style = attack_style
        self.movement_style = movement_style

    def act(self) -> str:
        return f"{self.movement_style.move()} and {self.attack_style.attack()}"


if __name__ == "__main__":
    print("--- Original inheritance-only hierarchy ---")
    print(FlyingMeleeCharacter().attack())
    print(FlyingRangedCharacter().attack())

    print("\n--- Composition-based refactor: 2x2 combinations ---")
    print(Character(MeleeAttack(), FlyingMovement()).act())
    print(Character(RangedAttack(), GroundedMovement()).act())
    print(Character(MeleeAttack(), GroundedMovement()).act())
    print(Character(RangedAttack(), FlyingMovement()).act())

    print("\n--- Adding a 3rd attack style and a 3rd movement style: zero new combo classes ---")
    print(Character(MagicAttack(), SwimmingMovement()).act())
    print(Character(MagicAttack(), FlyingMovement()).act())
    print(Character(RangedAttack(), SwimmingMovement()).act())


# Reflection 1: "dives and" duplicated across FlyingMeleeCharacter and FlyingRangedCharacter
# because inheritance can only express ONE axis of specialization per subclass -- to combine
# "flying" with both "melee" and "ranged", the flying behavior had to be copy-pasted into each
# unrelated branch. This violates DRY (Don't Repeat Yourself) and, more specifically, shows why
# inheritance is the wrong tool when two independent dimensions are being modeled: it forces a
# combinatorial explosion of subclasses (attack_styles * movement_styles) instead of letting
# the two vary independently.
#
# Reflection 2: The original design would need a brand-new `SwimmingMagicCharacter` subclass
# (1 new class, but the pattern doesn't scale -- N attack styles * M movement styles ultimately
# needs N*M classes). The composition-based refactor needs ZERO new combination classes --
# `Character(MagicAttack(), SwimmingMovement())` already works using classes that likely
# already exist from earlier requests, and in the worst case only 1-2 new small strategy
# classes (not a new combination class) are needed if either style is genuinely novel.
