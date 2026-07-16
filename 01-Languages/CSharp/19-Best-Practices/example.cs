// example.cs - a "before" (bad-practice) and "after" (best-practice) contrast.

Console.WriteLine("=== BEFORE: reference-equality mistake, no null-safety, no using ===");
var c1 = new PointClassBad { X = 1, Y = 2 };
var c2 = new PointClassBad { X = 1, Y = 2 };
Console.WriteLine($"c1 == c2 (expected equal, got reference equality): {c1 == c2}");

string? nameBad = null;
try {
    Console.WriteLine(nameBad!.Length); // ! silences the compiler but doesn't prevent the crash
} catch (NullReferenceException) {
    Console.WriteLine("BUG: NullReferenceException at runtime -- the ! assertion was wrong");
}

Console.WriteLine("\n=== AFTER: record value equality, real null-check, no unchecked assertion ===");
var p1 = new PointGood(1, 2);
var p2 = new PointGood(1, 2);
Console.WriteLine($"p1 == p2 (record, correct value equality): {p1 == p2}");

string? nameGood = null;
if (nameGood is not null) {
    Console.WriteLine(nameGood.Length);
} else {
    Console.WriteLine("Correctly handled null without a crash");
}

Console.WriteLine("\n=== validating external data instead of trusting it blindly ===");
string validJson = "{\"Theme\":\"dark\",\"FontSize\":14}";
string invalidJson = "{\"Theme\":\"dark\",\"FontSize\":\"not-a-number\"}";

Config? ParseConfig(string json) {
    try {
        AppContext.SetSwitch("System.Text.Json.JsonSerializer.IsReflectionEnabledByDefault", true);
        return System.Text.Json.JsonSerializer.Deserialize<Config>(json);
    } catch (System.Text.Json.JsonException) {
        return null;
    }
}

var validConfig = ParseConfig(validJson);
Console.WriteLine($"Valid config parsed: Theme={validConfig?.Theme}, FontSize={validConfig?.FontSize}");

var invalidConfig = ParseConfig(invalidJson);
Console.WriteLine($"Invalid config correctly rejected: {(invalidConfig is null ? "null (handled)" : "unexpectedly parsed")}");

class PointClassBad { public double X, Y; }
record PointGood(double X, double Y);
record Config(string Theme, int FontSize);
