// example.dart - named parameters ({required, default}), optional positional parameters
// ([...]), variadic-like behavior, and closures/anonymous functions.

// Named parameters: {name: value} at the call site, curly braces in the signature.
// `required` makes a named parameter mandatory; without it, named params are optional.
String greet({required String name, String greeting = 'Hello'}) {
  return '$greeting, $name!';
}

// Optional POSITIONAL parameters: square brackets, with a default value
String multiply(int a, [int b = 2]) {
  return '${a * b}';
}

void main() {
  print(greet(name: 'Ada')); // named args, called by name, order-independent
  print(greet(greeting: 'Hi', name: 'Grace')); // order can be swapped freely

  print('\n--- Optional positional parameters ---');
  print(multiply(5));       // uses default b=2
  print(multiply(5, 3));      // explicit b=3

  print('\n--- Both named and required positional in one signature ---');
  String describe(String item, {required int quantity, String unit = 'units'}) {
    return '$quantity $unit of $item';
  }
  print(describe('apples', quantity: 5));
  print(describe('water', quantity: 2, unit: 'liters'));

  print('\n--- Closures and anonymous functions ---');
  var multiplier = (int x) => x * 3; // arrow syntax for a single-expression function
  print(multiplier(5));

  int applyTwice(int x, int Function(int) f) {
    return f(f(x));
  }
  print(applyTwice(2, (x) => x * 2)); // anonymous function passed directly

  print('\n--- Closures capture by reference and CAN mutate captured variables ---');
  Function() makeCounter() {
    var count = 0;
    return () {
      count += 1;
      return count;
    };
  }
  // Dart requires an explicit return type for the counter function itself here for clarity;
  // calling it:
  var counter = makeCounter();
  print(counter());
  print(counter());
  print(counter()); // state persists across calls -- like Kotlin/Swift's closures
}
