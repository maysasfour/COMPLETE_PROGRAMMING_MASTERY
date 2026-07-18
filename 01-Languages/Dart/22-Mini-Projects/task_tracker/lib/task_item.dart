// task_item.dart - Priority/Status as enums (not raw strings), so an invalid value is a
// compile-time error at every call site in this codebase, and the SQLite layer only ever
// has to translate a small closed set of values, not validate free text.

enum Priority { low, medium, high }

enum Status { pending, done }

// An immutable class rather than a mutable one: rows are always read back from SQLite
// as fresh snapshots on every query, never mutated in place, so treating each TaskItem
// as a value (equality by field, never reused across an UPDATE) matches how it's actually
// used and avoids a class of "stale in-memory copy" bugs.
class TaskItem {
  final int id;
  final String title;
  final Priority priority;
  final Status status;
  final DateTime createdAt;

  const TaskItem({
    required this.id,
    required this.title,
    required this.priority,
    required this.status,
    required this.createdAt,
  });

  @override
  String toString() {
    var statusMark = status == Status.done ? '[x]' : '[ ]';
    var titlePadded = title.padRight(30);
    var priorityPadded = priority.name.padRight(6);
    var createdDate = createdAt.toIso8601String().substring(0, 10);
    return '$statusMark #${id.toString().padRight(3)} $titlePadded priority=$priorityPadded created=$createdDate';
  }

  // Value equality (by field, not identity) matters here specifically because the test
  // suite compares TaskItems read back from a fresh SELECT against TaskItems built by
  // hand -- two separately-constructed instances with identical fields must compare equal,
  // the same gotcha this course's Lesson 19 demonstrates Dart's collections DON'T give you
  // for free, so it's implemented explicitly here rather than assumed.
  @override
  bool operator ==(Object other) =>
      other is TaskItem &&
      id == other.id &&
      title == other.title &&
      priority == other.priority &&
      status == other.status &&
      createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(id, title, priority, status, createdAt);
}

class TaskStats {
  final int pending;
  final int done;

  const TaskStats({required this.pending, required this.done});

  int get total => pending + done;
}
