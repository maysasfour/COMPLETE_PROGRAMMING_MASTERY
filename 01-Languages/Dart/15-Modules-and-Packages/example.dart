// example.dart - import, and Dart's underscore-based privacy: private to the FILE
// (library), not the class -- genuinely different from Java/Kotlin's class-based
// private modifiers, verified in this lesson.

import 'lib/mathutils.dart';

void main() {
  print('--- import and public API usage ---');
  print(publicMultiply(3, 4)); // 12 -- uses the file-private _secretMultiplier internally
  var calc = Calculator();
  print(calc.add(2, 3));

  // print(_secretMultiplier); // COMPILE ERROR: Undefined name '_secretMultiplier' --
  // verified separately: privacy is scoped to mathutils.dart's FILE, invisible here
  // even though we imported the file that declares it.

  // print(calc._internalHelper(5)); // ALSO a compile error -- _internalHelper is private
  // to mathutils.dart's file scope, not just Calculator's class scope; even Calculator's
  // OWN file could access it via a plain function, but code in THIS file cannot at all.

  print('\n--- pubspec.yaml: the standard package/dependency manifest (not runnable here) ---');
  print('A real Dart project uses pubspec.yaml, e.g.:');
  print('''
name: my_project
environment:
  sdk: ^3.0.0
dependencies:
  http: ^1.0.0
dev_dependencies:
  test: ^1.0.0
''');
  print('`dart pub get` resolves dependencies; `dart pub add <package>` adds one directly.');
}
