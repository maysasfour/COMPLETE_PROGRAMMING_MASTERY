namespace TaskTracker;

// Priority/Status as enums (not raw strings) so an invalid value is a
// compile-time error at every call site, and the SQLite layer only ever
// has to translate a small closed set of values, not validate free text.
public enum Priority { Low, Medium, High }

public enum Status { Pending, Done }

// A record rather than a class: task rows are read back from SQLite as
// fresh snapshots on every query, never mutated in place, so value
// equality (two tasks with identical fields are "the same task") is the
// right default and comes for free with a record.
public record TaskItem(int Id, string Title, Priority Priority, Status Status, DateTime CreatedAt) {
    public override string ToString() {
        var statusMark = Status == Status.Done ? "[x]" : "[ ]";
        return $"{statusMark} #{Id,-3} {Title,-30} priority={Priority,-6} created={CreatedAt:yyyy-MM-dd}";
    }
}
