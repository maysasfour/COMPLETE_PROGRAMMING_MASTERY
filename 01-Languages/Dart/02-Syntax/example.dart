// example.dart - void main() entry point (required, unlike Kotlin/Swift's top-level
// statements), var/final/const, string interpolation, mandatory semicolons.

void main() {
  // Single-line comment.
  /* Multi-line
     comment. */

  var name = 'World'; // var: type INFERRED, but still statically typed (not dynamic)
  final greeting = 'Hello'; // final: single-assignment, like Kotlin's val/Swift's let
  const pi = 3.14159; // const: COMPILE-TIME constant, stricter than final (must be known at compile time)

  print('$greeting, $name!'); // string interpolation: $var or ${expression}
  print('pi + 1 = ${pi + 1}');

  var count = 0;
  count = 1; // var CAN be reassigned; final and const cannot
  print('count is now $count');

  // final name2 = 'reassigned';
  // greeting = 'Hi'; // COMPILE ERROR: "greeting" can't be used as a setter -- it's final

  // Semicolons ARE required in Dart, unlike Kotlin/Swift's optional semicolons
  print('semicolons are mandatory in Dart');
}
