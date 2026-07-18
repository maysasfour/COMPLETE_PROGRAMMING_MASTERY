// TaskTrackerError.swift -- a custom `Error`-conforming enum (Lesson 09), thrown instead
// of silently no-op'ing when a caller tries to mark-done/delete a task ID that doesn't
// exist -- callers get an explicit, catchable failure rather than a misleading success.

public enum TaskTrackerError: Error, Equatable {
    case taskNotFound(Int)
}

extension TaskTrackerError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .taskNotFound(let id):
            return "No task with id \(id) exists."
        }
    }
}
