// example.cs - text and JSON file I/O with System.IO and System.Text.Json, and the ENOENT-equivalent pattern.

using System.Text.Json;

// .NET 10 file-based apps disable reflection-based JSON serialization by default
// (it's optimized for trimming/AOT publishing scenarios). This switch re-enables it --
// a real, worth-knowing quirk specific to file-based apps, not an issue in a normal
// csproj-based project, which enables reflection-based serialization by default.
AppContext.SetSwitch("System.Text.Json.JsonSerializer.IsReflectionEnabledByDefault", true);

string textPath = Path.Combine(AppContext.BaseDirectory, "notes.txt");
string configPath = Path.Combine(AppContext.BaseDirectory, "config.json");

Console.WriteLine("--- text file round-trip ---");
File.WriteAllText(textPath, "Hello, file system!\n");
string textContents = File.ReadAllText(textPath);
Console.WriteLine($"Read back: {textContents.Trim()}");

Console.WriteLine("\n--- JSON file round-trip ---");
var config = new Config("dark", 14);
string json = JsonSerializer.Serialize(config);
File.WriteAllText(configPath, json);

string rawConfig = File.ReadAllText(configPath);
Config? loaded = JsonSerializer.Deserialize<Config>(rawConfig);
Console.WriteLine($"Loaded config: Theme={loaded?.Theme}, FontSize={loaded?.FontSize}");

Console.WriteLine("\n--- missing file handled with a specific exception type ---");
try {
    File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "does-not-exist.json"));
} catch (FileNotFoundException) {
    Console.WriteLine("File doesn't exist -- using defaults, handled gracefully");
}

File.Delete(textPath);
File.Delete(configPath);
Console.WriteLine("\nCleaned up temporary files.");

record Config(string Theme, int FontSize);
