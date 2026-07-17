// solution-02.cs - Pattern Matching Shape Calculator
// See: ../20-Exercises/README.md#exercise-02--pattern-matching-shape-calculator-beginnerintermediate
//
// Run with:
//     dotnet run solution-02.cs

Console.WriteLine("--- switch expression with type + property patterns ---");
Console.WriteLine($"Circle(3): {Area(new Circle(3)):F2}");
Console.WriteLine($"Rectangle(4,5): {Area(new Rectangle(4, 5)):F2}");
Console.WriteLine($"Rectangle(4,4) (square guard): {Area(new Rectangle(4, 4)):F2}");
Console.WriteLine($"Triangle(6,2): {Area(new Triangle(6, 2)):F2}");

try {
    Area("not a shape");
} catch (UnknownShapeException ex) {
    Console.WriteLine($"Caught expected error: {ex.Message}");
}

static double Area(object shape) => shape switch {
    Circle(var r) => Math.PI * r * r,

    // Property pattern with a 'when' guard: a Rectangle whose Width equals
    // its Height is still a Rectangle at the type level, but worth calling
    // out distinctly before falling through to the general rectangle case.
    Rectangle { Width: var w, Height: var h } when w == h =>
        LogSquareAndReturnArea(w, h),

    Rectangle(var w, var h) => w * h,
    Triangle(var b, var h) => 0.5 * b * h,

    // Discard pattern: anything that isn't one of the shapes above is a
    // programming error, not a recoverable case, so it throws.
    _ => throw new UnknownShapeException($"Unrecognized shape: {shape}")
};

static double LogSquareAndReturnArea(double w, double h) {
    Console.WriteLine($"  (detected a square: {w}x{h})");
    return w * h;
}

record Circle(double Radius);
record Rectangle(double Width, double Height);
record Triangle(double Base, double Height);

class UnknownShapeException : Exception {
    public UnknownShapeException(string message) : base(message) {}
}
