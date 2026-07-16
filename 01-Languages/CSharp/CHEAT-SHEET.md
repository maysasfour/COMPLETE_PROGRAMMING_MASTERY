# C# Cheat Sheet

[Back to course overview](README.md)

## Variables and Types

```csharp
int age = 30;
var name = "Ada";           // inferred, still static
string? nickname = null;    // nullable reference type
int? optionalAge = null;    // Nullable<int>
const double Pi = 3.14159;
```

## Operators

```csharp
value ?? "default";     // null-coalescing
value ??= "default";    // assign only if null
obj?.Member?.Method();   // null-conditional chain
if (obj is string s) { } // pattern-matching is
var x = obj as string;   // safe cast -> null on failure
```

## Control Flow

```csharp
if (x > 0) { } else if (x == 0) { } else { }

string desc = x switch {
    > 0 => "positive",
    < 0 => "negative",
    _ => "zero",
};

for (int i = 0; i < 3; i++) { }
foreach (var item in collection) { }
while (condition) { }
```

## Functions

```csharp
int Add(int a, int b) => a + b;
string Greet(string name = "World") => $"Hello, {name}";
int Sum(params int[] nums) => nums.Sum();
bool TryParse(string s, out int result) => int.TryParse(s, out result);
void Increment(ref int value) => value++;
```

## Collections and LINQ

```csharp
var list = new List<int> { 1, 2, 3 };
var dict = new Dictionary<string, int> { ["a"] = 1 };
dict.TryGetValue("b", out int val);

list.Where(n => n > 1).Select(n => n * 2).ToList();
list.Sum(); list.Any(n => n > 2); list.All(n => n > 0);
list.OrderByDescending(n => n).ToList();
```

## Strings

```csharp
$"{name} is {age}";
"hello".ToUpper();
string.Join(", ", list);
new StringBuilder().Append("a").Append("b").ToString();
```

## Error Handling

```csharp
try {
    // ...
} catch (SpecificException e) when (condition) {
    // ...
} catch (Exception e) {
    // ...
} finally {
    // always runs
}

class MyException : Exception {
    public MyException(string message) : base(message) {}
}
```

## OOP

```csharp
class Animal {
    public string Name { get; }
    public Animal(string name) { Name = name; }
    public virtual string Speak() => $"{Name}...";
}
class Dog : Animal {
    public Dog(string name) : base(name) {}
    public override string Speak() => $"{Name} says Woof";
}

interface IShape { double Area(); }
record Point(double X, double Y); // value equality, auto-generated
```

## Generics

```csharp
T First<T>(List<T> items) => items[0];
class Stack<T> where T : notnull { /* ... */ }
```

## Async

```csharp
async Task<string> GetAsync() {
    await Task.Delay(100);
    return "done";
}
await Task.WhenAll(task1, task2, task3);
```

## Running Code

```bash
dotnet run file.cs                         # file-based app, .NET 10+
dotnet new console -o MyApp && dotnet run   # full project
dotnet test                                  # xUnit/NUnit/MSTest project
```
