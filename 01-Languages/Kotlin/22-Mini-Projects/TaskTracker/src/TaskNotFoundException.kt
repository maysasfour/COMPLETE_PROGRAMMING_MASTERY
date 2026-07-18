// A specific exception type rather than a generic RuntimeException/IllegalStateException --
// lets the CLI layer (Main.kt) catch exactly this failure mode and print a clean, expected
// error message, instead of treating every possible failure as an unhandled crash.
class TaskNotFoundException(id: Long) : Exception("No task found with id $id")
