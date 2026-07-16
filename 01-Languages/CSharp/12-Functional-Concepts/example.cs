// example.cs - Func<>/Action<> delegates, a higher-order wrapper, LINQ functional chain.

using System.Linq;

Console.WriteLine("--- Func<> and Action<> ---");
Func<int, int, int> add = (a, b) => a + b;
Console.WriteLine($"add(2, 3): {add(2, 3)}");

Action<string> log = message => Console.WriteLine($"LOG: {message}");
log("hello");

Func<int, bool> isEven = n => n % 2 == 0;
Console.WriteLine($"isEven(4): {isEven(4)}");

Console.WriteLine("\n--- higher-order function wrapping a delegate ---");
Func<int, int, int> WithLogging(Func<int, int, int> fn) {
    return (a, b) => {
        Console.WriteLine($"  Calling with {a}, {b}");
        int result = fn(a, b);
        Console.WriteLine($"  Returned {result}");
        return result;
    };
}
var loggedAdd = WithLogging(add);
loggedAdd(2, 3);

Console.WriteLine("\n--- LINQ functional chain: filter, map, reduce in one expression ---");
var numbers = new List<int> { 1, 2, 3, 4, 5 };
var result = numbers.Where(n => n % 2 == 0).Select(n => n * n).Sum();
Console.WriteLine($"sum of squares of evens: {result}");
