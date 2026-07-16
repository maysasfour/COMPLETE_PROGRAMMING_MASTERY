// example.dart - Dart's SOUND null safety (since Dart 2.12): String vs String?, directly
// comparable to Kotlin's nullable types and Swift's Optionals, both covered earlier in
// this repository -- a third language in a row demonstrating this same core idea with its
// own specific syntax.

void main() {
  print('--- Basic types ---');
  int age = 30;
  double price = 19.99;
  String name = 'Ada';
  bool active = true;
  print('age=$age, price=$price, name=$name, active=$active');

  print('\n--- Null safety: String vs String? ---');
  String nonNullable = 'always has a value';
  String? nullable; // the ? makes this type EXPLICITLY nullable; defaults to null
  print('nonNullable: $nonNullable');
  print('nullable: $nullable');
  // nonNullable = null; // COMPILE ERROR: "A value of type 'Null' can't be assigned..."

  print('\n--- Null-aware operators ---');
  print('length: ${nullable?.length}'); // ?. -- null if nullable is null, no exception
  print('default: ${nullable ?? 'no value'}'); // ?? -- nil-coalescing, like Kotlin's ?:/Swift's ??
  nullable ??= 'assigned only if null'; // ??= -- assigns ONLY if currently null
  print('after ??=: $nullable');

  print('\n--- Bang operator (!) -- like Kotlin\'s !!/Swift\'s !, asserts non-null ---');
  String? maybeValue = 'trust me';
  print(maybeValue!.toUpperCase()); // throws a runtime TypeError if maybeValue were actually null

  print('\n--- late: promise to initialize before first use (not immediately) ---');
  late String lateValue;
  lateValue = 'assigned later, but before use';
  print(lateValue);

  print('\n--- dynamic vs var: var is still static, dynamic opts OUT of static checking ---');
  var staticallyTyped = 42; // inferred as int, and REMAINS int -- reassigning a String is an error
  dynamic trulyDynamic = 42;
  trulyDynamic = 'now a string'; // legal -- dynamic bypasses static type checking entirely
  print('staticallyTyped: $staticallyTyped, trulyDynamic: $trulyDynamic');
}
