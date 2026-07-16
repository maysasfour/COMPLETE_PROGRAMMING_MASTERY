// Example.swift - Swift has NO built-in database access, matching C++'s complete gap
// (covered earlier in this repository) -- this example uses SQLite3's raw C API directly
// via `import SQLite3` (SQLite ships with macOS/iOS/Linux as a system library, so no
// external package is strictly required, though most real projects use a wrapper library
// like SQLite.swift or GRDB for a more idiomatic API instead of raw C interop).
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

import SQLite3
import Foundation

var db: OpaquePointer?
sqlite3_open(":memory:", &db)

func exec(_ sql: String) {
    sqlite3_exec(db, sql, nil, nil, nil)
}

exec("""
    CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        done INTEGER NOT NULL DEFAULT 0
    )
""")

print("--- CREATE (parameterized) ---")
func insertTask(_ title: String) {
    var stmt: OpaquePointer?
    sqlite3_prepare_v2(db, "INSERT INTO tasks (title) VALUES (?)", -1, &stmt, nil)
    sqlite3_bind_text(stmt, 1, title, -1, nil) // ? placeholder, 1-indexed, bound safely
    sqlite3_step(stmt)
    sqlite3_finalize(stmt)
}
["Write lesson", "Test examples", "Ship it"].forEach { insertTask($0) }
print("Inserted 3 rows.")

print("\n--- READ (all) ---")
var readStmt: OpaquePointer?
sqlite3_prepare_v2(db, "SELECT id, title, done FROM tasks", -1, &readStmt, nil)
while sqlite3_step(readStmt) == SQLITE_ROW {
    let id = sqlite3_column_int(readStmt, 0)
    let title = String(cString: sqlite3_column_text(readStmt, 1))
    let done = sqlite3_column_int(readStmt, 2)
    print("  id=\(id), title=\(title), done=\(done)")
}
sqlite3_finalize(readStmt)

print("\n--- UPDATE (parameterized) ---")
var updateStmt: OpaquePointer?
sqlite3_prepare_v2(db, "UPDATE tasks SET done = 1 WHERE id = ?", -1, &updateStmt, nil)
sqlite3_bind_int(updateStmt, 1, 1)
sqlite3_step(updateStmt)
sqlite3_finalize(updateStmt)

print("\n--- DELETE (parameterized) ---")
var deleteStmt: OpaquePointer?
sqlite3_prepare_v2(db, "DELETE FROM tasks WHERE id = ?", -1, &deleteStmt, nil)
sqlite3_bind_int(deleteStmt, 1, 3)
sqlite3_step(deleteStmt)
sqlite3_finalize(deleteStmt)

print("\n--- Parameterized queries prevent SQL injection ---")
let maliciousTitle = "'; DROP TABLE tasks; --"
insertTask(maliciousTitle) // safely bound, not concatenated into the SQL string
var checkStmt: OpaquePointer?
sqlite3_prepare_v2(db, "SELECT title FROM tasks WHERE title = ?", -1, &checkStmt, nil)
sqlite3_bind_text(checkStmt, 1, maliciousTitle, -1, nil)
if sqlite3_step(checkStmt) == SQLITE_ROW {
    let retrieved = String(cString: sqlite3_column_text(checkStmt, 0))
    print("Malicious-looking string stored and retrieved as plain data: \(retrieved)")
}
sqlite3_finalize(checkStmt)

sqlite3_close(db)
