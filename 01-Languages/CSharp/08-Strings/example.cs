// example.cs - interpolation, common methods, immutability, StringBuilder, verbatim strings.

Console.WriteLine("--- interpolation and common methods ---");
string name = "Ada";
int age = 30;
Console.WriteLine($"{name} is {age} years old");
Console.WriteLine("  hello  ".Trim());
Console.WriteLine("hello".ToUpper());
Console.WriteLine("hello world".Contains("wor"));
Console.WriteLine(string.Join("-", "hello world".Split(' ')));
Console.WriteLine("hello".Replace("l", "L") + " (all occurrences replaced, unlike JS default)");

Console.WriteLine("\n--- immutability: += creates a new string each time ---");
string result = "";
for (int i = 0; i < 5; i++) {
    result += i;
}
Console.WriteLine($"built via +=: {result}");

Console.WriteLine("\n--- StringBuilder for efficient repeated appends ---");
var sb = new System.Text.StringBuilder();
for (int i = 0; i < 5; i++) {
    sb.Append(i);
}
Console.WriteLine($"built via StringBuilder: {sb.ToString()}");

Console.WriteLine("\n--- verbatim string ---");
string path = @"C:\Users\Ada\file.txt";
Console.WriteLine(path);
