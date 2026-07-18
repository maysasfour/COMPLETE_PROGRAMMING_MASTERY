// TaskRepository.swift -- reuses Lesson 16's exact raw-SQLite3-C-API approach
// (`import CSQLite3`, `OpaquePointer` handles, `sqlite3_prepare_v2`/`sqlite3_bind_*`
// parameterized queries, explicit `sqlite3_finalize` for every prepared statement) since
// Swift has no built-in database access at all -- this is the same documented gap Lesson
// 16 covers, just against a locally-compiled SQLite (see this package's README for why).

import CSQLite3

// SQLITE_TRANSIENT is not importable as-is on this Windows toolchain -- a genuine finding
// from building this mini-project, documented in the README's "Bugs found and fixed"
// section: referencing `SQLITE_TRANSIENT` directly fails to compile ("cannot find
// 'SQLITE_TRANSIENT' in scope"), unlike Apple platforms, where Clang-importer special-cases
// this exact `(sqlite3_destructor_type)-1` macro pattern into an importable constant.
// Reconstructing it manually here tells SQLite to COPY each bound string immediately
// during `sqlite3_bind_text`, which is the well-defined-behavior choice -- passing `nil`
// (SQLITE_STATIC) instead, as Lesson 16's never-compiled Example.swift does, was verified
// separately to *happen* to work in a throwaway test on this toolchain (Swift's temporary
// C-string bridge buffer for a `String` argument apparently outlives the single
// `sqlite3_bind_text` call in practice), but that is not a documented guarantee to rely on,
// so this file uses the safe, explicit alternative instead.
private let sqliteTransient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

public final class TaskRepository {
    private var db: OpaquePointer?

    /// - Parameter path: a file path, or `:memory:` for a private, in-memory database --
    ///   the test suite uses `:memory:` so every test starts from a clean, isolated database
    ///   with no shared state and nothing left on disk afterward.
    public init(path: String) {
        sqlite3_open(path, &db)
        sqlite3_exec(db, """
            CREATE TABLE IF NOT EXISTS tasks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                priority TEXT NOT NULL,
                done INTEGER NOT NULL DEFAULT 0
            )
        """, nil, nil, nil)
    }

    deinit {
        sqlite3_close(db)
    }

    @discardableResult
    public func addTask(title: String, priority: Priority) -> TaskItem {
        var stmt: OpaquePointer?
        // `?`-placeholders bound via `sqlite3_bind_*`, never string-interpolated SQL --
        // the exact SQL-injection-safety pattern Lesson 16 demonstrates.
        sqlite3_prepare_v2(db, "INSERT INTO tasks (title, priority, done) VALUES (?, ?, 0)", -1, &stmt, nil)
        sqlite3_bind_text(stmt, 1, title, -1, sqliteTransient)
        sqlite3_bind_text(stmt, 2, priority.rawValue, -1, sqliteTransient)
        sqlite3_step(stmt)
        sqlite3_finalize(stmt)
        let id = Int(sqlite3_last_insert_rowid(db))
        return TaskItem(id: id, title: title, priority: priority, done: false)
    }

    public func allTasks() -> [TaskItem] {
        var stmt: OpaquePointer?
        sqlite3_prepare_v2(db, "SELECT id, title, priority, done FROM tasks ORDER BY id", -1, &stmt, nil)
        defer { sqlite3_finalize(stmt) }

        var results: [TaskItem] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(stmt, 0))
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let priorityRaw = String(cString: sqlite3_column_text(stmt, 2))
            let done = sqlite3_column_int(stmt, 3) != 0
            let priority = Priority(rawValue: priorityRaw) ?? .medium
            results.append(TaskItem(id: id, title: title, priority: priority, done: done))
        }
        return results
    }

    /// Throws `TaskTrackerError.taskNotFound` if no row with `id` exists -- checked via
    /// `sqlite3_changes`, the number of rows the most recent statement actually modified,
    /// rather than assuming the UPDATE silently succeeded.
    public func markDone(id: Int) throws {
        var stmt: OpaquePointer?
        sqlite3_prepare_v2(db, "UPDATE tasks SET done = 1 WHERE id = ?", -1, &stmt, nil)
        sqlite3_bind_int(stmt, 1, Int32(id))
        sqlite3_step(stmt)
        sqlite3_finalize(stmt)
        if sqlite3_changes(db) == 0 {
            throw TaskTrackerError.taskNotFound(id)
        }
    }

    public func delete(id: Int) throws {
        var stmt: OpaquePointer?
        sqlite3_prepare_v2(db, "DELETE FROM tasks WHERE id = ?", -1, &stmt, nil)
        sqlite3_bind_int(stmt, 1, Int32(id))
        sqlite3_step(stmt)
        sqlite3_finalize(stmt)
        if sqlite3_changes(db) == 0 {
            throw TaskTrackerError.taskNotFound(id)
        }
    }

    public func stats() -> (total: Int, done: Int, pending: Int) {
        let all = allTasks()
        let doneCount = all.filter { $0.done }.count
        return (total: all.count, done: doneCount, pending: all.count - doneCount)
    }
}
