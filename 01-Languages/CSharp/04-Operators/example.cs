#nullable enable
// example.cs - null-coalescing/null-conditional, is-pattern matching, as safe casts.

Console.WriteLine("--- null-coalescing and null-conditional ---");
string? nickname = null;
string display = nickname ?? "Anonymous";
Console.WriteLine($"display: {display}");

nickname ??= "Guest";
Console.WriteLine($"nickname after ??=: {nickname}");

User? user = null;
int? nameLength = user?.Name?.Length;
Console.WriteLine($"nameLength (via ?. chain on null user): {nameLength?.ToString() ?? "null"}");

user = new User { Name = "Ada" };
nameLength = user?.Name?.Length;
Console.WriteLine($"nameLength (user now set): {nameLength}");

Console.WriteLine("\n--- is pattern matching ---");
object value = "hello";
if (value is string s) {
    Console.WriteLine($"Matched string, uppercased: {s.ToUpper()}");
}

Console.WriteLine("\n--- as safe cast ---");
object maybeNumber = 42;
string? asString = maybeNumber as string;
Console.WriteLine($"maybeNumber as string: {asString ?? "not a string (safely null, no exception)"}");

class User {
    public string? Name { get; set; }
}
