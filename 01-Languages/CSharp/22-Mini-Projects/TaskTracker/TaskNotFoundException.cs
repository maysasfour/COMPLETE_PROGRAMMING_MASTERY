namespace TaskTracker;

// A dedicated exception type (rather than a generic InvalidOperationException)
// lets the CLI layer catch exactly this failure mode and print a clean
// user-facing message, without accidentally swallowing unrelated bugs that
// also happen to throw InvalidOperationException elsewhere in the repository.
public class TaskNotFoundException : Exception {
    public int TaskId { get; }

    public TaskNotFoundException(int taskId)
        : base($"No task found with id {taskId}.") {
        TaskId = taskId;
    }
}
