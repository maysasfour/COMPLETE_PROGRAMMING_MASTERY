#:package Microsoft.Data.Sqlite@10.0.10
// example.cs - CRUD against a real SQLite database using Microsoft.Data.Sqlite.
// #:package is a .NET 10 file-based app directive -- it references a NuGet package
// directly in a single file, no .csproj needed, restored automatically on `dotnet run`.

using Microsoft.Data.Sqlite;

using var connection = new SqliteConnection("Data Source=:memory:");
connection.Open();

var createCmd = connection.CreateCommand();
createCmd.CommandText = @"
    CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        done INTEGER NOT NULL DEFAULT 0
    )";
createCmd.ExecuteNonQuery();

Console.WriteLine("--- CREATE (parameterized) ---");
void InsertTask(string title) {
    var cmd = connection.CreateCommand();
    cmd.CommandText = "INSERT INTO tasks (title) VALUES (@title)";
    cmd.Parameters.AddWithValue("@title", title);
    cmd.ExecuteNonQuery();
}
InsertTask("Write lesson");
InsertTask("Test examples");
InsertTask("Ship it");
Console.WriteLine("Inserted 3 rows.");

Console.WriteLine("\n--- READ (all) ---");
var selectCmd = connection.CreateCommand();
selectCmd.CommandText = "SELECT id, title, done FROM tasks";
using (var reader = selectCmd.ExecuteReader()) {
    while (reader.Read()) {
        Console.WriteLine($"  id={reader.GetInt32(0)}, title={reader.GetString(1)}, done={reader.GetInt32(2)}");
    }
}

Console.WriteLine("\n--- UPDATE (parameterized) ---");
var updateCmd = connection.CreateCommand();
updateCmd.CommandText = "UPDATE tasks SET done = 1 WHERE id = @id";
updateCmd.Parameters.AddWithValue("@id", 1);
updateCmd.ExecuteNonQuery();

var checkCmd = connection.CreateCommand();
checkCmd.CommandText = "SELECT done FROM tasks WHERE id = @id";
checkCmd.Parameters.AddWithValue("@id", 1);
Console.WriteLine($"Row 1 done status after update: {checkCmd.ExecuteScalar()}");

Console.WriteLine("\n--- DELETE (parameterized) ---");
var deleteCmd = connection.CreateCommand();
deleteCmd.CommandText = "DELETE FROM tasks WHERE id = @id";
deleteCmd.Parameters.AddWithValue("@id", 3);
deleteCmd.ExecuteNonQuery();

var countCmd = connection.CreateCommand();
countCmd.CommandText = "SELECT COUNT(*) FROM tasks";
Console.WriteLine($"Remaining row count: {countCmd.ExecuteScalar()}");

Console.WriteLine("\n--- parameterized queries prevent SQL injection ---");
string maliciousTitle = "'; DROP TABLE tasks; --";
InsertTask(maliciousTitle); // safe: bound as a parameter, never concatenated into SQL text
var verifyCmd = connection.CreateCommand();
verifyCmd.CommandText = "SELECT title FROM tasks WHERE title = @title";
verifyCmd.Parameters.AddWithValue("@title", maliciousTitle);
Console.WriteLine($"Malicious-looking string stored and retrieved as plain data: {verifyCmd.ExecuteScalar()}");

var finalCountCmd = connection.CreateCommand();
finalCountCmd.CommandText = "SELECT COUNT(*) FROM tasks";
Console.WriteLine($"Table still exists with all rows intact: {finalCountCmd.ExecuteScalar()}");
