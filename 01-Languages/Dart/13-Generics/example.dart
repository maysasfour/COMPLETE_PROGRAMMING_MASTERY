// example.dart - generic classes/functions with bounds, and a genuinely important, verified
// contrast with Java (covered earlier in this repository): Dart generics are REIFIED at
// runtime, not erased -- `is List<int>` genuinely works and distinguishes from `List<String>`,
// something Java's type-erasure-based generics cannot do at all.

class Stack<T> {
  final List<T> _items = [];
  void push(T item) => _items.add(item);
  T? pop() => _items.isEmpty ? null : _items.removeLast();
  bool get isEmpty => _items.isEmpty;
}

// Generic function with a bound (extends Comparable)
T maxOf<T extends Comparable<T>>(T a, T b) => a.compareTo(b) > 0 ? a : b;

class Box<T> {
  final T item;
  Box(this.item);
}

void main() {
  print('--- Generic class ---');
  var intStack = Stack<int>();
  intStack.push(1);
  intStack.push(2);
  print(intStack.pop()); // 2

  print('\n--- Generic function with a bound ---');
  print(maxOf(3, 7));
  print(maxOf('apple', 'banana'));

  print('\n--- Dart generics are REIFIED at runtime, NOT erased (verified live) ---');
  var intList = <int>[1, 2, 3];
  print(intList is List<int>);      // true
  print(intList is List<String>);    // false -- genuinely distinguishes type arguments at runtime
  print(intList.runtimeType);          // List<int> -- the ACTUAL type argument is visible

  var box = Box<String>('hello');
  print(box.runtimeType);                // Box<String> -- reified, unlike Java's erased Box
  print(box is Box<String>);              // true
  print(box is Box<int>);                  // false

  print('\n--- Contrast: this is NOT possible in Java, where generics are erased ---');
  print('(In Java, "list instanceof List<Integer>" is a compile error -- the type');
  print(' argument simply does not exist at runtime to check against at all.)');
}
