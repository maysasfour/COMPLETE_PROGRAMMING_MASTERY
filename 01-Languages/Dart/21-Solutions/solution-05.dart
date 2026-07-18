// solution-05.dart - Exercise 05: Reified Generics: a Typed Cache.

class TypedCache<T> {
  final Map<String, T> _store = {};

  void put(String key, T value) => _store[key] = value;
  T? get(String key) => _store[key];

  // T is the ACTUAL, reified type argument this instance was constructed with --
  // not `dynamic`, not erased. This line would have no equivalent in Java at all:
  // a generic class there cannot even reference its own type parameter as a Class
  // object without an explicit Class<T> token threaded through manually.
  Type get valueType => T;
}

void main() {
  print('--- Reified generics: is-checks genuinely distinguish type arguments ---');
  var intCache = TypedCache<int>();
  intCache.put('a', 1);
  var stringCache = TypedCache<String>();
  stringCache.put('b', 'hello');

  print('intCache is TypedCache<int>: ${intCache is TypedCache<int>}'); // true
  print('intCache is TypedCache<String>: ${intCache is TypedCache<String>}'); // false
  print('intCache.valueType: ${intCache.valueType}'); // int
  print('stringCache.valueType: ${stringCache.valueType}'); // String

  print('\n--- Same check style applied to plain generic Lists ---');
  Map<String, dynamic> mixed = {'x': 1, 'y': 2, 'z': 3};
  var mixedIntValues = mixed.values.toList();
  var realStringList = <String>['a', 'b'];
  // mixedIntValues was built through a `dynamic`-valued map, so even though every
  // element happens to be an int, the LIST's static type argument is `dynamic`,
  // not `int` -- `is List<int>` checks the reified type argument of the List itself,
  // not merely "do all elements happen to be ints right now".
  print('mixedIntValues is List<int>: ${mixedIntValues is List<int>}'); // false -- List<dynamic>
  print('mixedIntValues.runtimeType: ${mixedIntValues.runtimeType}');
  print('<int>[1, 2, 3] is List<int>: ${<int>[1, 2, 3] is List<int>}'); // true -- built WITH <int>
  print('realStringList is List<int>: ${realStringList is List<int>}'); // false

  print('\n--- Contrast with Java (covered earlier in this repository) ---');
  print('In Java, generics are ERASED at compile time: at runtime a Cache<Integer>');
  print('and a Cache<String> are both just "Cache" -- the type argument no longer');
  print('exists to check against. `cache instanceof TypedCache<Integer>` (or any');
  print('parameterized-type instanceof check) is a COMPILE ERROR in Java, not just');
  print('false -- the language does not even let you ask the question, because the');
  print('information needed to answer it was thrown away after compilation. Dart\'s');
  print('is-checks above work because Dart genuinely keeps the type argument at runtime.');
}
