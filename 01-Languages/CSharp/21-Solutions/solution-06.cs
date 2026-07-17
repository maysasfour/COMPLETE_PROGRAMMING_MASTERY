// solution-06.cs - Concurrent Downloads Simulation
// See: ../20-Exercises/README.md#exercise-06--concurrent-downloads-simulation-advanced
//
// Run with:
//     dotnet run solution-06.cs

using System.Diagnostics;

var stopwatch = Stopwatch.StartNew();

// Starting all four Tasks here (not awaiting each one immediately) is what
// makes them run concurrently -- FetchAsync begins its Task.Delay the
// instant it's called, before this line even reaches WhenAll.
var t1 = FetchAsync("https://api.example.com/users", 300, shouldFail: false);
var t2 = FetchAsync("https://api.example.com/orders", 500, shouldFail: false);
var t3 = FetchAsync("https://api.example.com/broken", 200, shouldFail: true);
var t4 = FetchAsync("https://api.example.com/products", 400, shouldFail: false);
var tasks = new[] { t1, t2, t3, t4 };

try {
    await Task.WhenAll(tasks);
} catch (Exception) {
    // WhenAll rethrows only the FIRST faulted task's exception here --
    // deliberately ignored in this catch so the loop below can inspect
    // every task individually and report ALL failures, not just one.
}

stopwatch.Stop();
Console.WriteLine($"Elapsed: {stopwatch.ElapsedMilliseconds}ms (slowest single delay was 500ms -- proves concurrency, not a ~1400ms sum)");

Console.WriteLine("\n--- per-task results ---");
foreach (var task in tasks) {
    if (task.IsFaulted) {
        // Task.Exception wraps the real exception in an AggregateException;
        // unwrap via .InnerException (or .Flatten()) to get the actual
        // FetchFailedException and its message.
        Console.WriteLine($"  FAILED: {task.Exception!.InnerException!.Message}");
    } else {
        Console.WriteLine($"  OK: {task.Result}");
    }
}

async Task<string> FetchAsync(string url, int delayMs, bool shouldFail) {
    await Task.Delay(delayMs);
    if (shouldFail) {
        throw new FetchFailedException($"{url} -> request failed after {delayMs}ms");
    }
    return $"{url} -> 200 OK ({delayMs}ms)";
}

class FetchFailedException : Exception {
    public FetchFailedException(string message) : base(message) {}
}
