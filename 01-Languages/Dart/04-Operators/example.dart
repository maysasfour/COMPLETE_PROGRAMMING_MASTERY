// example.dart - arithmetic (~/ for integer division), the cascade operator (..) --
// a genuinely distinctive Dart feature not present in this repository's other languages --
// spread operator, ternary, and is/as type checks.

class Paint {
  String color = 'black';
  int width = 1;
  void describe() => print('Paint(color: $color, width: $width)');
}

void main() {
  print('--- Arithmetic ---');
  print(10 / 3);    // 3.3333333333333335 -- / ALWAYS returns a double
  print(10 ~/ 3);     // 3 -- ~/ is INTEGER (truncating) division, a dedicated operator
  print(10 % 3);        // 1
  print(2.5 + 1);          // 3.5

  print('\n--- Cascade operator (..): call multiple methods/set multiple properties on ONE object ---');
  var paint = Paint()
    ..color = 'red' // each ..line operates on the SAME object, without repeating its name
    ..width = 5
    ..describe(); // cascades can even call methods -- and the whole expression returns the ORIGINAL object
  print('paint.color after cascade: ${paint.color}');

  print('\n--- Spread operator (...) in collection literals ---');
  var list1 = [1, 2, 3];
  var list2 = [0, ...list1, 4]; // spreads list1's elements directly into list2
  print(list2);

  print('\n--- Null-aware spread (...?) -- skips spreading if the collection is null ---');
  List<int>? maybeNullList;
  var list3 = [0, ...?maybeNullList, 1]; // no error even though maybeNullList is null
  print(list3);

  print('\n--- Ternary and conditional expressions ---');
  var age = 20;
  var category = age >= 18 ? 'adult' : 'minor';
  print(category);

  print('\n--- is / as: runtime type checks and casts ---');
  Object value = 'a string';
  if (value is String) {
    print('value is a String with length ${value.length}'); // smart-cast: value treated as String here
  }
  var casted = value as String; // explicit cast -- throws if the cast is invalid
  print('casted: $casted');
}
