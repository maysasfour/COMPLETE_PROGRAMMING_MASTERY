// Task.swift -- the CLI's core model, deliberately a `struct` (value type, Lesson 11) --
// every `TaskItem` returned by `TaskRepository` is an independent snapshot, never an alias
// back into the database's internal state.

/// A task's priority, modeled as an enum rather than a free-text string column -- an
/// invalid priority is then a compile-time impossibility for any Swift code constructing
/// a `TaskItem` directly, not just a runtime validation rule.
public enum Priority: String, CaseIterable, Equatable {
    case low
    case medium
    case high
}

public struct TaskItem: Equatable {
    public let id: Int
    public let title: String
    public let priority: Priority
    public let done: Bool

    public init(id: Int, title: String, priority: Priority, done: Bool) {
        self.id = id
        self.title = title
        self.priority = priority
        self.done = done
    }
}
