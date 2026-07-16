// example.dart - string interpolation (seen since Lesson 02), core string methods, and
// Dart's UTF-16-code-unit-based .length -- matching Java/JavaScript's approach (covered
// earlier in this repository), NOT Swift's grapheme-cluster-based .count (also covered
// earlier), verified live with a multi-scalar emoji.

void main() {
  var name = 'Ada';
  var age = 30;
  print('--- String interpolation ---');
  print('$name is $age years old, and next year will be ${age + 1}');

  print('\n--- Core string methods ---');
  var s = 'Hello, World!';
  print(s.toUpperCase());
  print(s.toLowerCase());
  print(s.replaceAll('World', 'Dart'));
  print(s.substring(7, 12));
  print(s.contains('World'));
  print(s.startsWith('Hello'));
  print(s.split(', '));

  print('\n--- Multi-line (triple-quoted) strings ---');
  var raw = '''
Line one
Line two with a literal backslash: \\n (escaped, prints literally, not a newline)
''';
  print(raw);

  print('\n--- .length is UTF-16 CODE UNIT count, NOT grapheme clusters (verified live) ---');
  var flag = '🇺🇸'; // the US flag emoji: TWO Unicode scalars, each requiring a UTF-16 surrogate pair
  print('flag.length: ${flag.length}');           // 4 -- UTF-16 code units (2 scalars x 2 units each)
  print('flag.runes.length: ${flag.runes.length}'); // 2 -- actual Unicode SCALAR count (via .runes)
  var accented = 'café'; // é is a single Unicode scalar within the Basic Multilingual Plane
  print('accented.length: ${accented.length}');       // 4 -- matches character count here, no surprise

  print('\n--- Iterating by rune (Unicode scalar) vs by UTF-16 code unit ---');
  for (var rune in 'café'.runes) {
    print('  rune: $rune (${String.fromCharCode(rune)})');
  }
}
