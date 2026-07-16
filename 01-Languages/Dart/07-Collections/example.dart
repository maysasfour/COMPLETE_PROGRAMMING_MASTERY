// example.dart - List/Map/Set, collection-if/collection-for in literals (a genuinely
// distinctive Dart feature, building on the spread operator from Lesson 04), and
// List.unmodifiable for genuine immutability (contrasted with the reference-aliasing
// concerns from Kotlin's course).

void main() {
  print('--- List, Map, Set ---');
  var list = [1, 2, 3];
  var map = {'name': 'Ada', 'age': 30};
  var set = {1, 2, 2, 3, 3, 3}; // Set literal -- duplicates removed automatically
  print('list: $list');
  print('map: $map');
  print('set: $set');

  print('\n--- map/where/reduce (Dart\'s names for map/filter/reduce) ---');
  var nums = [1, 2, 3, 4, 5];
  print(nums.map((n) => n * 2).toList()); // .map returns an Iterable -- .toList() materializes it
  print(nums.where((n) => n % 2 == 0).toList()); // .where is Dart's "filter"
  print(nums.reduce((a, b) => a + b));

  print('\n--- Collection-if and collection-for in literals: a genuinely distinctive feature ---');
  var includeExtra = true;
  var conditionalList = [
    1,
    2,
    if (includeExtra) 3, // collection-if: conditionally includes an element, right in the literal
    4,
  ];
  print('conditionalList: $conditionalList');

  var source = [10, 20, 30];
  var generatedList = [
    0,
    for (var x in source) x * 2, // collection-for: generates elements from a loop, in the literal
    100,
  ];
  print('generatedList: $generatedList');

  print('\n--- List.unmodifiable: GENUINE immutability, not just a read-only-typed view ---');
  var mutableSource = [1, 2, 3];
  var trulyImmutable = List.unmodifiable(mutableSource); // an actual, separate, immutable copy
  mutableSource.add(4); // mutating the ORIGINAL source list
  print('mutableSource: $mutableSource');       // [1, 2, 3, 4] -- the original changed
  print('trulyImmutable: $trulyImmutable');       // [1, 2, 3]    -- UNCHANGED, genuinely independent
  try {
    trulyImmutable.add(99); // throws -- attempting to mutate an unmodifiable list
  } catch (e) {
    print('caught: attempting to mutate trulyImmutable threw ${e.runtimeType}');
  }

  print('\n--- Destructuring (Dart 3 records and pattern matching) ---');
  var (first, second, third) = (1, 2, 3); // destructuring a record
  print('$first, $second, $third');
}
