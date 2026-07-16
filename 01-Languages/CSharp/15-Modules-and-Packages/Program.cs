// Program.cs - the entry point, using a class from a DIFFERENT file (Utilities.cs)
// that shares the same namespace, demonstrating namespaces aren't tied one-to-one with files.

using MyApp.Utilities;

Console.WriteLine($"MathHelpers.Add(2, 3): {MathHelpers.Add(2, 3)}");
Console.WriteLine($"MathHelpers.Multiply(4, 5): {MathHelpers.Multiply(4, 5)}");
