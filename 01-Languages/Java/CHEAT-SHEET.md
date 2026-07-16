# Java Cheat Sheet

[Back to course overview](README.md)

## Variables and Types

```java
int age = 30;               // primitive
Integer boxedAge = 30;       // boxed (autoboxed)
var name = "Ada";            // inferred, local-only
final int maxRetries = 3;
```

## `==` vs `.equals()` — THE Java Rule

```java
a == b        // ALWAYS reference equality for objects -- never use for content comparison
a.equals(b)   // content equality -- ALWAYS use this instead, no exceptions
```

## Control Flow

```java
if (x > 0) { } else if (x == 0) { } else { }

String desc = switch (x) {
    case 1, 2 -> "small";
    default -> "other";
};

for (int i = 0; i < 3; i++) { }
for (String s : list) { }   // enhanced for / for-each
while (condition) { }
```

## Methods (No Free Functions)

```java
static int add(int a, int b) { return a + b; }
static int sum(int... nums) { int t=0; for (int n: nums) t+=n; return t; } // varargs
```

## Collections and Streams

```java
List<Integer> list = new ArrayList<>(List.of(1, 2, 3));
Map<String, Integer> map = new HashMap<>();
map.getOrDefault("key", -1);

list.stream().filter(n -> n % 2 == 0).map(n -> n * n)
    .collect(Collectors.toList());
list.stream().reduce(0, Integer::sum);
```

## Strings

```java
"a" + "b";
String.join(", ", list);
new StringBuilder().append("a").append("b").toString();
String text = """
    multi-line
    text block""";
```

## Exceptions

```java
try {
    // ...
} catch (SpecificException e) {
    // ...
} catch (Exception e) {
    // ...
} finally { }

try (var resource = openResource()) { } // try-with-resources, AutoCloseable

class MyException extends RuntimeException { // unchecked, conventional default
    public MyException(String msg) { super(msg); }
}
```

## OOP

```java
class Animal {
    private final String name;
    public Animal(String name) { this.name = name; }
    public String speak() { return name + "..."; } // overridable by DEFAULT
}
class Dog extends Animal {
    public Dog(String name) { super(name); }
    @Override
    public String speak() { return "Woof"; }
}

interface Shape { double area(); default String describe() { return "area: " + area(); } }
record Point(double x, double y) {} // value equality auto-generated
```

## Generics

```java
static <T> T first(List<T> items) { return items.get(0); }
static <T extends Comparable<T>> T max(List<T> items) { /* ... */ }
static double sum(List<? extends Number> list) { /* PECS: producer extends */ }
```

## Concurrency

```java
CompletableFuture<String> f = CompletableFuture.supplyAsync(() -> "done");
CompletableFuture.allOf(f1, f2, f3).join();

try (var ex = Executors.newVirtualThreadPerTaskExecutor()) {
    ex.submit(() -> { /* ... */ });
}
```

## Running Code

```bash
java File.java                 # single-file source launcher, JDK 11+
javac File.java && java File    # traditional two-step compile+run
mvn compile / gradle build      # real multi-file projects
```
