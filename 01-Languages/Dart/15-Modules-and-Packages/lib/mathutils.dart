// mathutils.dart - a small library file demonstrating Dart's underscore-based privacy:
// privacy is scoped to the FILE (library), not the class, genuinely different from
// Java/Kotlin's class-based private/internal modifiers, verified in this lesson's main.dart.

int _secretMultiplier = 10; // private to THIS FILE -- invisible even to files that import it

int publicMultiply(int a, int b) => a * b * _secretMultiplier ~/ _secretMultiplier;

class Calculator {
  int add(int a, int b) => a + b;
  int _internalHelper(int x) => x * 2; // private to this file, NOT just this class
}
