// example.cs - if/else, switch statement, switch expressions, type-pattern matching, loops.

Console.WriteLine("--- if/else ---");
int temperature = 20;
if (temperature > 30) Console.WriteLine("hot");
else if (temperature > 15) Console.WriteLine("warm");
else Console.WriteLine("cool");

Console.WriteLine("\n--- switch expression with relational patterns ---");
string DescribeTemperature(int temp) => temp switch {
    > 30 => "hot",
    > 15 => "warm",
    _ => "cool",
};
Console.WriteLine(DescribeTemperature(35));
Console.WriteLine(DescribeTemperature(20));
Console.WriteLine(DescribeTemperature(5));

Console.WriteLine("\n--- type-pattern switch with a when guard ---");
string Describe(object value) => value switch {
    int n when n < 0 => "negative number",
    int n => $"non-negative number: {n}",
    string s => $"a string of length {s.Length}",
    null => "null value",
    _ => "something else",
};
Console.WriteLine(Describe(-5));
Console.WriteLine(Describe(42));
Console.WriteLine(Describe("hello"));
Console.WriteLine(Describe(3.14));

Console.WriteLine("\n--- loops ---");
for (int i = 0; i < 3; i++) Console.Write($"for:{i} ");
Console.WriteLine();

foreach (var fruit in new[] { "apple", "banana" }) Console.Write($"foreach:{fruit} ");
Console.WriteLine();

int count = 0;
while (count < 3) { Console.Write($"while:{count} "); count++; }
Console.WriteLine();
