// example.cs - generic methods, constrained generics (where T : ...), a generic class.

Console.WriteLine("--- generic method with inference ---");
T First<T>(List<T> items) => items[0];
Console.WriteLine(First(new List<int> { 1, 2, 3 }));
Console.WriteLine(First(new List<string> { "a", "b" }));

Console.WriteLine("\n--- constrained generic (where T : IHasLength) ---");
double TotalLength<T>(List<T> items) where T : IHasLength {
    double total = 0;
    foreach (var item in items) total += item.Length;
    return total;
}
var wires = new List<Wire> { new Wire(3.5), new Wire(2.0) };
Console.WriteLine($"TotalLength: {TotalLength(wires)}");

Console.WriteLine("\n--- generic class Stack<T> ---");
var numberStack = new Stack<int>();
numberStack.Push(1);
numberStack.Push(2);
numberStack.Push(3);
Console.WriteLine($"numberStack.Count: {numberStack.Count}");
Console.WriteLine($"numberStack.Pop(): {numberStack.Pop()}");

var stringStack = new Stack<string>();
stringStack.Push("a");
stringStack.Push("b");
Console.WriteLine($"stringStack.Pop(): {stringStack.Pop()}");

interface IHasLength { double Length { get; } }
record Wire(double Length) : IHasLength;

class Stack<T> {
    private readonly List<T> items = new();
    public void Push(T item) => items.Add(item);
    public T Pop() {
        var item = items[^1];
        items.RemoveAt(items.Count - 1);
        return item;
    }
    public int Count => items.Count;
}
