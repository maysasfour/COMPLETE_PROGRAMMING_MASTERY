// example.cs - arrays, List<T>, Dictionary<K,V>, and LINQ.

using System.Linq;

Console.WriteLine("--- arrays, List<T>, Dictionary<K,V> ---");
int[] numbersArray = { 1, 2, 3, 4, 5 };
Console.WriteLine($"array: [{string.Join(", ", numbersArray)}]");

var scores = new List<int> { 95, 88, 76 };
scores.Add(100);
Console.WriteLine($"scores after Add: [{string.Join(", ", scores)}]");

var ages = new Dictionary<string, int> {
    ["Ada"] = 30,
    ["Lin"] = 28,
};
Console.WriteLine($"ages[\"Ada\"]: {ages["Ada"]}");
Console.WriteLine(ages.TryGetValue("Unknown", out int age) ? age.ToString() : "not found (safe lookup)");

Console.WriteLine("\n--- LINQ ---");
var numbers = new List<int> { 1, 2, 3, 4, 5 };
var doubled = numbers.Select(n => n * 2).ToList();
var evens = numbers.Where(n => n % 2 == 0).ToList();
int total = numbers.Sum();
int firstOver3 = numbers.First(n => n > 3);
bool hasEven = numbers.Any(n => n % 2 == 0);
bool allPositive = numbers.All(n => n > 0);
var sortedDesc = numbers.OrderByDescending(n => n).ToList();

Console.WriteLine($"doubled: [{string.Join(", ", doubled)}]");
Console.WriteLine($"evens: [{string.Join(", ", evens)}]");
Console.WriteLine($"total: {total}");
Console.WriteLine($"firstOver3: {firstOver3}");
Console.WriteLine($"hasEven: {hasEven}");
Console.WriteLine($"allPositive: {allPositive}");
Console.WriteLine($"sortedDesc: [{string.Join(", ", sortedDesc)}]");
Console.WriteLine($"original numbers unchanged: [{string.Join(", ", numbers)}]");
