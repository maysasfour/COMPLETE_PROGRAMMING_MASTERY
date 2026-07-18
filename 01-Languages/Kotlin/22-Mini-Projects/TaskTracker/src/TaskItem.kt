// Enums instead of free-text strings for priority/status -- an invalid priority is a compile
// error here, not a runtime-discovered typo in a database row (the exact problem free-text
// columns invite).
enum class Priority { LOW, MEDIUM, HIGH }
enum class Status { PENDING, DONE }

// A data class rather than a plain class specifically so tests get real structural equality
// (Exercise 02's finding, reused here) -- comparing two TaskItems in an assertion compares their
// field values, not their object identity, which is what a test actually wants to check.
data class TaskItem(
    val id: Long,
    val title: String,
    val priority: Priority,
    val status: Status,
    val createdAt: String, // stored as SQLite's own ISO-8601 default (see TaskRepository), kept as a
                            // plain String rather than a proper date type to avoid pulling in a third
                            // dependency (java.time formatting) just for this mini-project's display needs
)

data class TaskStats(val pending: Int, val done: Int, val total: Int)
