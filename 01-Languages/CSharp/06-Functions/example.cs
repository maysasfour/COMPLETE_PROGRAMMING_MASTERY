// example.cs - default params, params arrays, out/ref, local functions.

Console.WriteLine("--- default parameters ---");
string Greet(string name = "World") => $"Hello, {name}";
Console.WriteLine(Greet());
Console.WriteLine(Greet("Ada"));

Console.WriteLine("\n--- params array ---");
int Sum(params int[] numbers) {
    int total = 0;
    foreach (var n in numbers) total += n;
    return total;
}
Console.WriteLine($"Sum(1,2,3,4): {Sum(1, 2, 3, 4)}");
Console.WriteLine($"Sum(): {Sum()}");

Console.WriteLine("\n--- out parameter (TryParse pattern) ---");
bool TryParseAge(string input, out int age) {
    return int.TryParse(input, out age);
}
if (TryParseAge("30", out int parsedAge)) {
    Console.WriteLine($"Parsed: {parsedAge}");
}
if (!TryParseAge("not-a-number", out int failedAge)) {
    Console.WriteLine($"Parse failed, out variable defaults to: {failedAge}");
}

Console.WriteLine("\n--- ref parameter ---");
void Increment(ref int value) {
    value += 1;
}
int counter = 5;
Increment(ref counter);
Console.WriteLine($"counter after Increment(ref counter): {counter}");

Console.WriteLine("\n--- local function (recursive) ---");
int Factorial(int n) {
    int Helper(int n, int acc) => n <= 1 ? acc : Helper(n - 1, n * acc);
    return Helper(n, 1);
}
Console.WriteLine($"Factorial(5): {Factorial(5)}");
