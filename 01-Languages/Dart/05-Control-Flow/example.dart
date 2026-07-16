// example.dart - if/else, switch (NO fall-through by default -- verified live, matching
// Go/Swift, unlike C/Java/JavaScript), Dart 3's switch EXPRESSIONS and pattern matching,
// and loops.

void main() {
  var score = 85;
  String grade;
  if (score >= 90) {
    grade = 'A';
  } else if (score >= 80) {
    grade = 'B';
  } else {
    grade = 'C or below';
  }
  print('grade: $grade');

  print('\n--- switch: NO fall-through by default (verified live) ---');
  var day = 1;
  switch (day) {
    case 1:
      print('Monday'); // does NOT fall through to case 2, unlike C/Java/JavaScript
    case 2:
      print('Tuesday');
    default:
      print('other');
  }

  print('\n--- Explicit fall-through via labeled continue (an intentional opt-in) ---');
  switch (day) {
    case 1:
      print('Monday (explicit fallthrough)');
      continue tuesday; // opts INTO falling through to the "tuesday" label
    tuesday:
    case 2:
      print('Tuesday (reached via fallthrough or directly)');
    default:
      print('other');
  }

  print('\n--- Dart 3 switch EXPRESSION: produces a value directly ---');
  var dayType = switch (day) {
    1 || 2 || 3 || 4 || 5 => 'Weekday', // || inside a switch expression pattern -- "or" patterns
    6 || 7 => 'Weekend',
    _ => 'Invalid day', // _ is the wildcard/default pattern
  };
  print('dayType: $dayType');

  print('\n--- Dart 3 pattern matching: destructuring in a switch ---');
  var point = (2, 0); // a record (Dart 3 feature, previewed here, covered more in Lesson 11)
  var description = switch (point) {
    (0, 0) => 'origin',
    (_, 0) => 'on the x-axis',
    (0, _) => 'on the y-axis',
    _ => 'elsewhere',
  };
  print(description);

  print('\n--- Loops ---');
  for (var i = 0; i < 3; i++) {
    print('for: $i');
  }
  var i = 0;
  while (i < 3) {
    print('while: $i');
    i++;
  }
  var letters = ['a', 'b', 'c'];
  for (var (index, letter) in letters.indexed) {
    print('indexed: $index -> $letter');
  }
}
