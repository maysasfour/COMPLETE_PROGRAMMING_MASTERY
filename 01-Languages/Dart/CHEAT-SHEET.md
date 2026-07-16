# Dart Cheat Sheet

[Back to course overview](README.md)

## Variables and Null Safety

```dart
var name = 'World';        // type inferred, still statically typed
final greeting = 'Hello';    // single-assignment, runtime value
const pi = 3.14159;            // single-assignment, COMPILE-TIME value

String nonNullable = 'x';      // can NEVER be null
String? nullable;                 // explicitly nullable, defaults to null

nullable?.length         // safe call -- null if nullable is null
nullable ?? 'default'     // nil-coalescing
nullable ??= 'set if null'  // assign only if currently null
nullable!.length            // force unwrap -- throws if actually null (catchable, unlike Swift's !)

late String x;   // promise: initialized before first use, not at declaration
dynamic d = 42;    // opts OUT of static type checking entirely
```

## Operators

```dart
10 / 3;    // 3.3333333333333335 -- ALWAYS double
10 ~/ 3;     // 3 -- dedicated INTEGER division

var p = Paint()
  ..color = 'red'    // CASCADE: chain calls/assignments on the SAME object
  ..width = 5
  ..describe();        // whole expression evaluates to the ORIGINAL object

var combined = [0, ...list1, 4];     // spread
var safe = [0, ...?maybeNullList, 1]; // null-aware spread

value is String   // runtime type check, smart-casts within the block
value as String    // explicit cast, throws if invalid
```

## Control Flow

```dart
switch (day) {
  case 1: print('Monday');   // NO fall-through by default (verified)!
  case 2: print('Tuesday');
  default: print('other');
}
// explicit fallthrough: continue label;

var dayType = switch (day) {       // Dart 3 switch EXPRESSION
  1 || 2 || 3 || 4 || 5 => 'Weekday', // "or" pattern
  _ => 'Invalid',                       // wildcard
};

var (a, b) = (1, 2);   // record destructuring
```

## Functions

```dart
String greet({required String name, String greeting = 'Hello'}) => '$greeting, $name!';
greet(name: 'Ada');          // named params, order-independent

String multiply(int a, [int b = 2]) => '${a * b}'; // optional POSITIONAL param

Function() makeCounter() {
  var count = 0;
  return () { count += 1; return count; };  // closures CAN mutate captured vars
}
```

## Collections

```dart
var list = [1, 2, 3];
var map = {'name': 'Ada'};
var set = {1, 2, 2, 3};        // {1, 2, 3} -- dupes removed

nums.map((n) => n * 2).toList();  // lazy Iterable -- .toList() materializes
nums.where((n) => n.isEven).toList();
nums.reduce((a, b) => a + b);

var trulyImmutable = List.unmodifiable(source); // GENUINE, independent immutability
trulyImmutable.add(1); // throws UnsupportedError

// WARNING: List == is IDENTITY equality by default, NOT content equality!
[1,2,3] == [1,2,3];  // false! Use package:collection's ListEquality for content comparison
```

## Strings

```dart
'$name is $age, next year ${age + 1}';  // interpolation

var raw = '''
multi-line, no escaping needed
''';

// .length counts UTF-16 CODE UNITS (matches Java/JS), NOT grapheme clusters (unlike Swift)
'🇺🇸'.length;         // 4
'🇺🇸'.runes.length;    // 2 -- actual Unicode scalar count
```

## Error Handling

```dart
class MyException implements Exception {  // ANY object can be thrown, not just this!
  final String msg;
  MyException(this.msg);
}

try {
  throw MyException('oops');
} on MyException catch (e) {
  print(e.msg);
} on FormatException {
  print('no variable needed');
} finally {
  print('always runs');
}

void risky() {
  try { throw StateError('bad'); }
  catch (e) { rethrow; } // preserves ORIGINAL stack trace, unlike throw e;
}
```

## OOP

```dart
abstract class Animal {
  final String name;
  Animal(this.name);
  String makeSound();                    // abstract
  String describe() => '$name: ${makeSound()}';
}
class Dog extends Animal {
  Dog(super.name);
  @override String makeSound() => 'Woof!';
}

mixin Loggable {                          // reusable behavior via `with`, NOT inheritance
  void log(String m) => print(m);
}
class Service with Loggable { }

class Point {
  final int x, y;
  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0;            // named constructor
  factory Point.fromJson(Map j) =>            // factory: logic + can return existing instance
      Point(j['x'], j['y']);
  Map toJson() => {'x': x, 'y': y};
  int get sum => x + y;                        // getter
}
```

## Generics (REIFIED at runtime, unlike Java!)

```dart
class Stack<T> {
  final List<T> _items = [];
  void push(T item) => _items.add(item);
}

T maxOf<T extends Comparable<T>>(T a, T b) => a.compareTo(b) > 0 ? a : b;

var list = <int>[1, 2, 3];
list is List<int>;      // true -- verified: generics are REIFIED, not erased
list is List<String>;    // false
```

## Async/Concurrency (native async/await + Isolates)

```dart
Future<int> fetch() async { await Future.delayed(Duration(milliseconds: 100)); return 42; }

await Future.wait([fetch(), fetch()]); // concurrent

Stream<int> counter() async* {   // generator -- SEQUENCE of values over time
  for (var i = 0; i < 5; i++) { yield i; }
}
await for (var v in counter()) { print(v); }

// Isolate: Dart's ONLY parallelism mechanism -- NO shared memory, message passing only
void entry(SendPort p) => p.send(42);
var rp = ReceivePort();
await Isolate.spawn(entry, rp.sendPort);
var result = await rp.first;
```

## Modules (privacy is FILE-scoped, not class-scoped)

```dart
// mylib.dart
int _private = 10;  // invisible to ANY other file, even ones that import this one

import 'mylib.dart'; // brings public API into scope
```

```yaml
# pubspec.yaml
dependencies:
  http: ^1.0.0
```

## Database (no built-in access, like Swift/C++)

```dart
import 'package:sqlite3/sqlite3.dart';
final db = sqlite3.openInMemory();
db.execute('SELECT * FROM t WHERE id = ?', [id]); // parameterized
```

## HTTP / JSON

```dart
import 'dart:io';
import 'dart:convert';   // BUILT IN, no package needed

var request = await HttpClient().getUrl(uri);
var response = await request.close();
response.statusCode;  // NO exception on 404 -- check this!

var json = jsonEncode(obj);
var decoded = jsonDecode(json) as Map<String, dynamic>;
```

## Testing (the `test` package)

```dart
import 'package:test/test.dart';

void main() {
  late Calculator calc;
  setUp(() => calc = Calculator());   // runs before EVERY test

  test('adds', () => expect(calc.add(2, 3), equals(5)));
  test('throws', () => expect(() => calc.divide(1, 0), throwsArgumentError));
}
```

## Running Code

```bash
dart run file.dart                  # JIT via Dart VM, no build step
dart compile exe file.dart -o bin    # AOT native binary
dart pub get; dart pub add <pkg>      # dependency management
dart test                              # run the test suite
```
