// task_not_found_exception.dart - a dedicated exception type (rather than a generic
// StateError) lets the CLI layer catch exactly this failure mode and print a clean
// user-facing message, without accidentally swallowing unrelated bugs that also
// happen to throw StateError elsewhere in this codebase.

class TaskNotFoundException implements Exception {
  final int taskId;

  TaskNotFoundException(this.taskId);

  @override
  String toString() => 'No task found with id $taskId.';
}
