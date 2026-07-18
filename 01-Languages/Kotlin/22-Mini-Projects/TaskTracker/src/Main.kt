import java.sql.DriverManager

private const val USAGE = """Usage:
  add <title> [--priority low|medium|high]
  list [--status pending|done]
  done <id>
  delete <id>
  stats"""

fun main(args: Array<String>) {
    if (args.isEmpty()) {
        println(USAGE)
        return
    }

    Class.forName("org.sqlite.JDBC") // registers the SQLite JDBC driver -- same requirement as Lesson 16
    DriverManager.getConnection("jdbc:sqlite:tasks.db").use { conn ->
        val repo = TaskRepository(conn)
        try {
            dispatch(repo, args)
        } catch (e: TaskNotFoundException) {
            println("Error: ${e.message}")
        } catch (e: IllegalArgumentException) {
            println("Error: ${e.message}")
        }
    }
}

private fun dispatch(repo: TaskRepository, args: Array<String>) {
    when (args[0]) {
        "add" -> {
            val title = args.getOrNull(1) ?: run { println("Error: add requires a title"); return }
            val priority = flagValue(args, "--priority")?.let { parsePriority(it) } ?: Priority.MEDIUM
            val task = repo.addTask(title, priority)
            println("Added task #${task.id}: ${task.title} (priority=${task.priority.display()})")
        }
        "list" -> {
            val status = flagValue(args, "--status")?.let { parseStatus(it) }
            val tasks = repo.listTasks(status)
            if (tasks.isEmpty()) {
                println("No tasks.")
            } else {
                for (task in tasks) println(task.format())
            }
        }
        "done" -> {
            val id = requireIdArg(args)
            repo.markDone(id)
            println("Marked task #$id as done.")
        }
        "delete" -> {
            val id = requireIdArg(args)
            repo.deleteTask(id)
            println("Deleted task #$id.")
        }
        "stats" -> {
            val stats = repo.getStats()
            println("Pending: ${stats.pending}  Done: ${stats.done}  Total: ${stats.total}")
        }
        else -> println(USAGE)
    }
}

private fun requireIdArg(args: Array<String>): Long =
    args.getOrNull(1)?.toLongOrNull() ?: throw IllegalArgumentException("expected a numeric task id")

// A tiny, hand-rolled --flag value lookup -- proportionate to this app's five commands and two
// flags; a real CLI with more surface area would reach for a library instead of growing this by hand.
private fun flagValue(args: Array<String>, flag: String): String? {
    val index = args.indexOf(flag)
    return if (index >= 0 && index + 1 < args.size) args[index + 1] else null
}

private fun parsePriority(raw: String): Priority = when (raw.lowercase()) {
    "low" -> Priority.LOW
    "medium" -> Priority.MEDIUM
    "high" -> Priority.HIGH
    else -> throw IllegalArgumentException("unknown priority '$raw' (expected low|medium|high)")
}

private fun parseStatus(raw: String): Status = when (raw.lowercase()) {
    "pending" -> Status.PENDING
    "done" -> Status.DONE
    else -> throw IllegalArgumentException("unknown status '$raw' (expected pending|done)")
}

private fun Priority.display(): String = name.lowercase().replaceFirstChar { it.uppercase() }

private fun TaskItem.format(): String {
    val mark = if (status == Status.DONE) "x" else " "
    return "[$mark] #$id\t$title\tpriority=${priority.display()}\tcreated=${createdAt.take(10)}"
}
