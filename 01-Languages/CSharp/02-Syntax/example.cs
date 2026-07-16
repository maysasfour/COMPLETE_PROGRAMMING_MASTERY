// example.cs - statements vs expressions, comments, XML doc comments.

int x = 5;
int y = x + 1;
Console.WriteLine($"y = {y}");

/// <summary>
/// Greets a person by name. This XML doc comment is picked up by IDE tooltips.
/// </summary>
/// <param name="name">The name to greet.</param>
/// <returns>A greeting string.</returns>
string Greet(string name) => $"Hello, {name}";

Console.WriteLine(Greet("Ada"));

// int missingSemicolon = 5   <- would fail to COMPILE: ; expected
