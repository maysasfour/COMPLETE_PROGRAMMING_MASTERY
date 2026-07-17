// Program.cs - CLI entry point. Parses argv, opens/creates tasks.db in the
// current directory, and dispatches to TaskRepository. Kept deliberately
// thin: all persistence logic lives in TaskRepository so it (not this file)
// is what the test project exercises.

using Microsoft.Data.Sqlite;
using TaskTracker;

// A file-backed connection is what makes tasks.db survive between runs --
// tests instead construct an in-memory connection directly, bypassing this
// file entirely, which is why Program.cs itself has no unit tests of its own.
using var connection = new SqliteConnection("Data Source=tasks.db");
connection.Open();
var repository = new TaskRepository(connection);
repository.InitDb();

return RunCommand(args, repository);

static int RunCommand(string[] args, TaskRepository repository) {
    if (args.Length == 0) {
        PrintUsage();
        return 1;
    }

    try {
        switch (args[0]) {
            case "add":
                return HandleAdd(args, repository);
            case "list":
                return HandleList(args, repository);
            case "done":
                return HandleDone(args, repository);
            case "delete":
                return HandleDelete(args, repository);
            case "stats":
                return HandleStats(repository);
            default:
                Console.WriteLine($"Unknown command: {args[0]}");
                PrintUsage();
                return 1;
        }
    } catch (TaskNotFoundException ex) {
        Console.WriteLine($"Error: {ex.Message}");
        return 1;
    } catch (ArgumentException ex) {
        Console.WriteLine($"Error: {ex.Message}");
        return 1;
    }
}

static int HandleAdd(string[] args, TaskRepository repository) {
    if (args.Length < 2) {
        Console.WriteLine("Usage: add <title> [--priority low|medium|high]");
        return 1;
    }

    var priority = Priority.Medium;
    var priorityFlagIndex = Array.IndexOf(args, "--priority");
    string title;
    if (priorityFlagIndex >= 0 && priorityFlagIndex + 1 < args.Length) {
        priority = Enum.Parse<Priority>(args[priorityFlagIndex + 1], ignoreCase: true);
        // Title is everything between "add" and "--priority" -- lets a
        // multi-word title be passed without requiring shell quoting tricks
        // beyond the single pair of quotes the shell itself needs.
        title = string.Join(' ', args[1..priorityFlagIndex]);
    } else {
        title = string.Join(' ', args[1..]);
    }

    var task = repository.AddTask(title, priority);
    Console.WriteLine($"Added task #{task.Id}: {task.Title} (priority={task.Priority})");
    return 0;
}

static int HandleList(string[] args, TaskRepository repository) {
    Status? filter = null;
    var statusFlagIndex = Array.IndexOf(args, "--status");
    if (statusFlagIndex >= 0 && statusFlagIndex + 1 < args.Length) {
        filter = Enum.Parse<Status>(args[statusFlagIndex + 1], ignoreCase: true);
    }

    var tasks = repository.ListTasks(filter);
    if (tasks.Count == 0) {
        Console.WriteLine("No tasks found.");
        return 0;
    }
    foreach (var task in tasks) {
        Console.WriteLine(task);
    }
    return 0;
}

static int HandleDone(string[] args, TaskRepository repository) {
    if (args.Length < 2 || !int.TryParse(args[1], out var id)) {
        Console.WriteLine("Usage: done <id>");
        return 1;
    }
    repository.MarkDone(id);
    Console.WriteLine($"Marked task #{id} as done.");
    return 0;
}

static int HandleDelete(string[] args, TaskRepository repository) {
    if (args.Length < 2 || !int.TryParse(args[1], out var id)) {
        Console.WriteLine("Usage: delete <id>");
        return 1;
    }
    repository.DeleteTask(id);
    Console.WriteLine($"Deleted task #{id}.");
    return 0;
}

static int HandleStats(TaskRepository repository) {
    var stats = repository.GetStats();
    Console.WriteLine($"Pending: {stats.Pending}  Done: {stats.Done}  Total: {stats.Total}");
    return 0;
}

static void PrintUsage() {
    Console.WriteLine("""
        Usage:
          dotnet run -- add <title> [--priority low|medium|high]
          dotnet run -- list [--status pending|done]
          dotnet run -- done <id>
          dotnet run -- delete <id>
          dotnet run -- stats
        """);
}
