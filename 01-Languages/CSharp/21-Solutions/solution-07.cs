// solution-07.cs - JSON Roundtrip with LINQ Filtering
// See: ../20-Exercises/README.md#exercise-07--json-roundtrip-with-linq-filtering-advanced
//
// Run with:
//     dotnet run solution-07.cs

using System.Text.Json;

// .NET 10 file-based apps disable reflection-based JSON serialization by
// default (it's tuned for trimming/AOT scenarios) -- without this switch,
// JsonSerializer.Serialize below throws InvalidOperationException at
// runtime even though the code compiles cleanly. See Lesson 10's example.cs
// for the first place this course hits the same quirk.
AppContext.SetSwitch("System.Text.Json.JsonSerializer.IsReflectionEnabledByDefault", true);

var books = new List<Book> {
    new("Clean Code", "Robert C. Martin", 2008, 4.2),
    new("The Pragmatic Programmer", "Hunt & Thomas", 1999, 4.4),
    new("C# in Depth", "Jon Skeet", 2019, 4.7),
    new("Deep Work", "Cal Newport", 2016, 4.3),
    new("Atomic Habits", "James Clear", 2018, 4.8),
    new("Refactoring", "Martin Fowler", 1999, 4.5),
};

// Path.GetTempFileName() guarantees a unique, writable path so this
// example never collides with a real file or needs manual name generation.
var tempPath = Path.GetTempFileName();

try {
    Console.WriteLine($"--- serializing {books.Count} books to {tempPath} ---");
    var json = JsonSerializer.Serialize(books, new JsonSerializerOptions { WriteIndented = true });
    File.WriteAllText(tempPath, json);

    Console.WriteLine("\n--- reading back and deserializing ---");
    var readBack = File.ReadAllText(tempPath);
    var deserialized = JsonSerializer.Deserialize<List<Book>>(readBack)
        ?? throw new InvalidOperationException("Deserialization returned null.");
    Console.WriteLine($"Deserialized {deserialized.Count} books.");

    Console.WriteLine("\n--- books after 2015 with rating >= 4.0, sorted by rating desc ---");
    var filtered = deserialized
        .Where(b => b.Year > 2015 && b.Rating >= 4.0)
        .OrderByDescending(b => b.Rating);
    foreach (var b in filtered) {
        Console.WriteLine($"  {b.Title} ({b.Year}) by {b.Author} -- {b.Rating:F1}");
    }
} finally {
    // Cleanup runs even if an assertion above throws, so a failed run
    // never leaves a stray temp file behind.
    File.Delete(tempPath);
    Console.WriteLine($"\nCleanup check -- file still exists: {File.Exists(tempPath)}");
}

record Book(string Title, string Author, int Year, double Rating);
