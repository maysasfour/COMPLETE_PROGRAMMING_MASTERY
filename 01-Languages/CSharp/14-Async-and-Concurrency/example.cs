// example.cs - async/await, Task<T>, and Task.WhenAll with real timing measurement.

using System.Diagnostics;

async Task<string> DelayAndGreetAsync(int ms, string name) {
    await Task.Delay(ms);
    return $"Hello, {name}";
}

Console.WriteLine("--- basic async/await ---");
string greeting = await DelayAndGreetAsync(50, "Ada");
Console.WriteLine(greeting);

Console.WriteLine("\n--- sequential await vs Task.WhenAll (real timing) ---");
var sw = Stopwatch.StartNew();
await DelayAndGreetAsync(80, "a");
await DelayAndGreetAsync(80, "b");
await DelayAndGreetAsync(80, "c");
sw.Stop();
Console.WriteLine($"Sequential 3x80ms awaits took ~{sw.ElapsedMilliseconds}ms");

sw.Restart();
var task1 = DelayAndGreetAsync(80, "Ada");
var task2 = DelayAndGreetAsync(80, "Lin");
var task3 = DelayAndGreetAsync(80, "Kai");
string[] results = await Task.WhenAll(task1, task2, task3);
sw.Stop();
Console.WriteLine($"Task.WhenAll of the same 3x80ms tasks took ~{sw.ElapsedMilliseconds}ms");
Console.WriteLine(string.Join(" | ", results));
