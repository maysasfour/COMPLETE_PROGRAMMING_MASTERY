// solution-04.cs - Custom Exception + Nullable Reference Types
// See: ../20-Exercises/README.md#exercise-04--custom-exception--nullable-reference-types-intermediate
//
// Run with:
//     dotnet run solution-04.cs
//
// #:property enables nullable reference types for this file-based app --
// file-based apps default Nullable to 'disable', so without this directive
// the compiler would silently accept `string? Bio` and `string Username`
// as equivalent, defeating the whole exercise.
#:property Nullable=enable

var withBio = new UserProfile("ada", "Mathematician and programmer.");
Console.WriteLine($"withBio.DisplayBio(): {withBio.DisplayBio()}");

var noBio = new UserProfile("grace", null);
Console.WriteLine($"noBio.DisplayBio(): {noBio.DisplayBio()}");

try {
    var invalid = new UserProfile("   ", "irrelevant");
} catch (InvalidUsernameException ex) {
    Console.WriteLine($"Caught expected error: {ex.Message}");
}

class UserProfile {
    public string Username { get; }
    public string? Bio { get; }

    public UserProfile(string username, string? bio) {
        if (string.IsNullOrWhiteSpace(username)) {
            throw new InvalidUsernameException("Username cannot be null, empty, or whitespace.");
        }
        Username = username;
        Bio = bio;
    }

    // '??' short-circuits only on null (unlike '||', which would also treat
    // an empty-but-non-null string as falsy) -- that distinction matters
    // because an explicitly empty bio is different from "never set".
    public string DisplayBio() => Bio ?? "No bio provided";
}

class InvalidUsernameException : Exception {
    public InvalidUsernameException(string message) : base(message) {}
}
