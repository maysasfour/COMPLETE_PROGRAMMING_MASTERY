// solution-03.dart - Exercise 03: Mixins via `with`.

mixin Flyable {
  String fly() => 'flies through the air';
}

mixin Swimmable {
  String swim() => 'swims through water';
}

class Duck with Flyable, Swimmable {
  String describe() => 'Duck ${fly()} and ${swim()}';
}

// `on Flyable` restricts this mixin to only classes that already have Flyable applied
// (or extend a class that does) -- it's how a mixin can safely call super.fly() and be
// GUARANTEED at compile time that a real Flyable implementation exists to call into.
mixin LoudFlyable on Flyable {
  @override
  String fly() => '${super.fly()} (loudly!)';
}

// Order matters: mixins apply left-to-right, each layering onto the ones before it,
// so `with Flyable, LoudFlyable` makes LoudFlyable's fly() the ACTIVE one (it's applied
// last, so it "wins" the method lookup), while its `super.fly()` correctly reaches back
// to Flyable's original implementation, applied just before it.
class Goose with Flyable, LoudFlyable {
  String describe() => 'Goose ${fly()}';
}

void main() {
  print('--- Duck: two independent mixins ---');
  print(Duck().describe());

  print('\n--- Goose: LoudFlyable overrides Flyable via super ---');
  print(Goose().describe());

  // If the order were reversed (`with LoudFlyable, Flyable`), this would be a COMPILE
  // ERROR: LoudFlyable's `on Flyable` clause requires Flyable to already be part of the
  // class's superclass chain by the time LoudFlyable is applied -- applying it FIRST
  // means no Flyable exists yet for `on Flyable` to be satisfied by.
  print('\n(Reversing to "with LoudFlyable, Flyable" would fail: the `on Flyable`');
  print(' clause requires Flyable to already be applied before LoudFlyable is.)');
}
