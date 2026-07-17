// solution-05.cs - Generic Result<T> Type
// See: ../20-Exercises/README.md#exercise-05--generic-resultt-type-advanced
//
// Run with:
//     dotnet run solution-05.cs

Console.WriteLine("--- Result<T> without exceptions for control flow ---");

var goodResult = ParseAge("42");
var badResult = ParseAge("not a number");
var negativeResult = ParseAge("-5");

Console.WriteLine(goodResult.Match(
    onSuccess: age => $"Parsed age: {age}",
    onFailure: err => $"Failed: {err}"
));
Console.WriteLine(badResult.Match(
    onSuccess: age => $"Parsed age: {age}",
    onFailure: err => $"Failed: {err}"
));
Console.WriteLine(negativeResult.Match(
    onSuccess: age => $"Parsed age: {age}",
    onFailure: err => $"Failed: {err}"
));

static Result<int> ParseAge(string input) {
    if (!int.TryParse(input, out var value)) {
        return Result<int>.Failure($"'{input}' is not a valid integer.");
    }
    if (value < 0) {
        return Result<int>.Failure($"Age cannot be negative: {value}.");
    }
    return Result<int>.Success(value);
}

// A readonly record struct keeps this allocation-free (no heap object per
// result, unlike a class hierarchy) while record equality gives Result<T>
// value semantics "for free" -- two successes with the same value compare
// equal, which is useful in tests.
readonly record struct Result<T> {
    private readonly T? _value;
    private readonly string? _error;
    public bool IsSuccess { get; }

    private Result(T value) { _value = value; _error = null; IsSuccess = true; }
    private Result(string error) { _value = default; _error = error; IsSuccess = false; }

    public static Result<T> Success(T value) => new(value);
    public static Result<T> Failure(string error) => new(error);

    // Forces the caller to handle both branches at the call site instead of
    // risking an unchecked "success" access on a failed Result -- the same
    // discipline exceptions give you for free, but visible in the type.
    public TOut Match<TOut>(Func<T, TOut> onSuccess, Func<string, TOut> onFailure) =>
        IsSuccess ? onSuccess(_value!) : onFailure(_error!);
}
