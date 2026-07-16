// example.dart - file I/O via dart:io's File class (sync and async variants), and
// dart:convert's jsonEncode/jsonDecode -- Dart has GENUINELY BUILT-IN JSON support,
// no external package needed, matching PHP/JavaScript/Python/Swift's built-in JSON
// (all covered elsewhere in this repository) and contrasting with Java/Kotlin/C++/Rust,
// all of which needed an external library.

import 'dart:io';
import 'dart:convert';

void main() {
  var dir = Directory.systemTemp.createTempSync('dart_course_scratch_');
  var file = File('${dir.path}/notes.txt');

  print('--- Writing and reading a file (synchronous) ---');
  file.writeAsStringSync('line one\nline two\n');
  print(file.readAsStringSync());

  print('\n--- Appending ---');
  file.writeAsStringSync('line three\n', mode: FileMode.append);
  print(file.readAsStringSync());

  print('\n--- Reading line by line ---');
  var lines = file.readAsLinesSync();
  for (var i = 0; i < lines.length; i++) {
    print('  ${i + 1}: ${lines[i]}');
  }

  print('\n--- Missing file: throws, like Kotlin/Java (exception-based) ---');
  var missingFile = File('${dir.path}/does-not-exist.txt');
  try {
    missingFile.readAsStringSync();
  } catch (e) {
    print('caught: ${e.runtimeType}');
  }

  print('\n--- dart:convert: BUILT-IN JSON support, no external package needed ---');
  var person = {'name': 'Ada', 'age': 30, 'active': true};
  var jsonString = jsonEncode(person); // jsonEncode -- built directly into dart:convert
  print(jsonString);
  var decoded = jsonDecode(jsonString) as Map<String, dynamic>; // returns dynamic-typed data
  print('decoded name: ${decoded['name']}');

  // clean up -- this course never leaves scratch artifacts behind
  dir.deleteSync(recursive: true);
}
