#nullable enable
// example.cs - value vs reference semantics, var inference, nullable reference/value types.

Console.WriteLine("--- value type: independent copies ---");
int a = 5;
int b = a;
b = 10;
Console.WriteLine($"a={a}, b={b}");

Console.WriteLine("\n--- reference type: shared underlying object ---");
var listA = new List<int> { 1, 2, 3 };
var listB = listA;
listB.Add(4);
Console.WriteLine($"listA.Count={listA.Count} (listB's mutation is visible through listA)");

Console.WriteLine("\n--- var inference ---");
var name = "Ada";
var scores = new List<int>();
scores.Add(95);
Console.WriteLine($"name (inferred string): {name}, scores (inferred List<int>): [{string.Join(", ", scores)}]");

Console.WriteLine("\n--- nullable reference and value types ---");
string? nickname = null;
if (nickname != null) {
    Console.WriteLine(nickname.Length);
} else {
    Console.WriteLine("nickname is null, skipped safely");
}

int? optionalAge = null;
Console.WriteLine($"optionalAge ?? -1: {optionalAge ?? -1}");
optionalAge = 30;
Console.WriteLine($"optionalAge ?? -1 (now set): {optionalAge ?? -1}");
