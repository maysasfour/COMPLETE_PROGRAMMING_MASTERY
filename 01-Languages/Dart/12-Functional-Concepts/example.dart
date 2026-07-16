// example.dart - extension methods (Dart's version of Kotlin's/C#'s extension functions --
// adding "methods" to EXISTING types, including types you don't own, without inheritance),
// typedef for naming function types, and function composition.

// Extension method: adds a method to String (a type we don't own) without modifying its
// source or subclassing it -- resolved statically, just like Kotlin's extension functions.
extension StringExtras on String {
  String shout() => '${toUpperCase()}!';
  bool get isPalindrome {
    var cleaned = toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == cleaned.split('').reversed.join('');
  }
}

// typedef: names a function type for readability/reuse
typedef IntTransformer = int Function(int);

int compose(IntTransformer f, IntTransformer g, int x) => f(g(x));

void main() {
  print('--- Extension methods: called AS IF they were real methods on String ---');
  print('hello'.shout()); // HELLO!
  print('racecar'.isPalindrome); // true -- an extension GETTER, not just a method
  print('A man a plan a canal Panama'.isPalindrome); // true
  print('hello'.isPalindrome); // false

  print('\n--- typedef and function composition ---');
  IntTransformer addOne = (x) => x + 1;
  IntTransformer square = (x) => x * x;
  print(compose(square, addOne, 4)); // (4+1)^2 = 25

  print('\n--- Higher-order functions: functions returning functions ---');
  IntTransformer multiplier(int factor) => (x) => x * factor;
  var triple = multiplier(3);
  print(triple(5)); // 15

  print('\n--- map/where/reduce with named functions (not just closures) ---');
  bool isEven(int n) => n % 2 == 0;
  var nums = [1, 2, 3, 4, 5, 6];
  print(nums.where(isEven).toList()); // passing a named function directly
}
