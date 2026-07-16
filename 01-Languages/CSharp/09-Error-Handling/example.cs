// example.cs - typed catch clauses, custom exceptions, exception filters.

Console.WriteLine("--- typed catch clauses and finally ---");
try {
    int[] numbers = { 1, 2, 3 };
    Console.WriteLine(numbers[10]);
} catch (IndexOutOfRangeException e) {
    Console.WriteLine($"Index error: {e.Message}");
} catch (Exception e) {
    Console.WriteLine($"Unexpected error: {e.Message}");
} finally {
    Console.WriteLine("Cleanup runs regardless");
}

Console.WriteLine("\n--- custom exception ---");
int ValidateAge(int age) {
    if (age < 0) throw new ValidationException("Age cannot be negative", "age");
    return age;
}

try {
    ValidateAge(-5);
} catch (ValidationException e) {
    Console.WriteLine($"Validation failed on \"{e.Field}\": {e.Message}");
}

Console.WriteLine("\n--- exception filter (when) ---");
void TryRecoverable(bool temporary) {
    try {
        throw new InvalidOperationException(temporary ? "temporary failure" : "permanent failure");
    } catch (InvalidOperationException e) when (e.Message.Contains("temporary")) {
        Console.WriteLine("Recoverable, retrying...");
    } catch (InvalidOperationException e) {
        Console.WriteLine($"Non-recoverable: {e.Message}");
    }
}
TryRecoverable(true);
TryRecoverable(false);

class ValidationException : Exception {
    public string Field { get; }
    public ValidationException(string message, string field) : base(message) {
        Field = field;
    }
}
