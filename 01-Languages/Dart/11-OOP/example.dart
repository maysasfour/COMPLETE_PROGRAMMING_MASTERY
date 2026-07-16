// example.dart - classes with named/factory constructors, mixins (a genuinely distinctive
// Dart feature via the `with` keyword -- similar in spirit to Kotlin's traits/interfaces
// with default methods, but Dart's mixins are their own dedicated language construct),
// abstract classes, getters/setters, and the fromJson/toJson convention (building on
// Lesson 10's dart:convert).

abstract class Animal {
  final String name;
  Animal(this.name);
  String makeSound(); // abstract method -- must be implemented by concrete subclasses
  String describe() => '$name says ${makeSound()}';
}

class Dog extends Animal {
  Dog(super.name);
  @override
  String makeSound() => 'Woof!';
}

class Cat extends Animal {
  Cat(super.name);
  @override
  String makeSound() => 'Meow!';
}

// Mixin: reusable behavior "mixed into" a class via `with`, without inheritance --
// Dart's dedicated answer to the same "horizontal code reuse" problem PHP's traits
// and (differently) Kotlin's protocol-extension-style default methods solve.
mixin Loggable {
  void log(String message) => print('[${runtimeType}] $message');
}

class Service with Loggable {
  void start() => log('service started'); // log() comes from the Loggable mixin
}

// Named constructors and factory constructors
class Point {
  final int x;
  final int y;
  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0; // a NAMED constructor -- an alternate way to construct a Point

  factory Point.fromJson(Map<String, dynamic> json) {
    // factory constructors can return an existing instance, or do validation/logic
    // before constructing -- a plain constructor cannot do either of these things.
    return Point(json['x'] as int, json['y'] as int);
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y}; // pairs with dart:convert's jsonEncode

  // Getter and setter
  int get sum => x + y; // computed property -- no stored backing field
}

void main() {
  print('--- Abstract classes and polymorphism ---');
  List<Animal> animals = [Dog('Rex'), Cat('Whiskers')];
  for (var a in animals) {
    print(a.describe());
  }

  print('\n--- Mixins: reusable behavior via `with`, not inheritance ---');
  var service = Service();
  service.start();

  print('\n--- Named and factory constructors ---');
  var p1 = Point(3, 4);
  var p2 = Point.origin();
  print('p1.sum: ${p1.sum}, p2.sum: ${p2.sum}');

  var json = {'x': 5, 'y': 6};
  var p3 = Point.fromJson(json);
  print('p3.sum: ${p3.sum}, p3.toJson(): ${p3.toJson()}');
}
