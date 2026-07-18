// TaskRepository.cpp - see TaskRepository.hpp for the rationale behind wrapping the
// raw SQLite C API in an RAII class rather than using it directly from main().
#include "TaskRepository.hpp"
#include "TaskNotFoundException.hpp"
#include <stdexcept>
#include <iostream>

sqlite3_stmt* TaskRepository::prepare(const std::string& sql) const {
    sqlite3_stmt* stmt = nullptr;
    // sqlite3_prepare_v2's third argument (-1) means "read until the first NUL byte" --
    // safe here since our SQL is always a std::string, never externally-truncated input.
    int rc = sqlite3_prepare_v2(db, sql.c_str(), -1, &stmt, nullptr);
    if (rc != SQLITE_OK) {
        // A malformed SQL statement is a programmer error in this codebase (all SQL
        // here is a fixed literal, never built from user input -- see addTask's
        // parameterized ? placeholder for how user input actually flows in), so this
        // throws std::runtime_error rather than a domain-specific exception type.
        throw std::runtime_error(std::string("SQLite prepare failed: ") + sqlite3_errmsg(db));
    }
    return stmt;
}

TaskRepository::TaskRepository(const std::string& path) {
    if (sqlite3_open(path.c_str(), &db) != SQLITE_OK) {
        std::string err = sqlite3_errmsg(db);
        sqlite3_close(db); // db is non-null even on a failed open, per SQLite's own docs
        throw std::runtime_error("Could not open database '" + path + "': " + err);
    }
    char* errMsg = nullptr;
    const char* schema =
        "CREATE TABLE IF NOT EXISTS tasks ("
        "  id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "  title TEXT NOT NULL,"
        "  priority INTEGER NOT NULL,"
        "  status INTEGER NOT NULL DEFAULT 0,"
        "  created_at TEXT NOT NULL DEFAULT (datetime('now'))"
        ")";
    if (sqlite3_exec(db, schema, nullptr, nullptr, &errMsg) != SQLITE_OK) {
        std::string err = errMsg ? errMsg : "unknown error";
        sqlite3_free(errMsg);
        sqlite3_close(db);
        throw std::runtime_error("Could not create schema: " + err);
    }
}

TaskRepository::~TaskRepository() {
    // sqlite3_close on a nullptr db is a documented no-op -- safe for a moved-from
    // instance, exactly like delete[] on a nulled-out pointer in Exercise 07's Buffer.
    sqlite3_close(db);
}

TaskRepository::TaskRepository(TaskRepository&& other) noexcept : db(other.db) {
    other.db = nullptr;
}

TaskRepository& TaskRepository::operator=(TaskRepository&& other) noexcept {
    if (this != &other) {
        sqlite3_close(db);
        db = other.db;
        other.db = nullptr;
    }
    return *this;
}

int TaskRepository::addTask(const std::string& title, Priority priority) {
    if (title.empty()) {
        throw std::invalid_argument("Task title cannot be empty");
    }
    // "INSERT ...; SELECT last_insert_rowid();" as ONE batched statement, read back via
    // sqlite3_step, avoids a second round trip purely to learn the new row's id --
    // last_insert_rowid() is connection-scoped and safe to read immediately after,
    // on the SAME connection, within the same prepared-statement lifetime here.
    sqlite3_stmt* stmt = prepare("INSERT INTO tasks (title, priority) VALUES (?, ?)");
    sqlite3_bind_text(stmt, 1, title.c_str(), -1, SQLITE_TRANSIENT); // 1-indexed, like JDBC
    sqlite3_bind_int(stmt, 2, static_cast<int>(priority));
    int rc = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    if (rc != SQLITE_DONE) {
        throw std::runtime_error(std::string("Insert failed: ") + sqlite3_errmsg(db));
    }
    return static_cast<int>(sqlite3_last_insert_rowid(db));
}

std::vector<TaskItem> TaskRepository::listTasks(std::optional<Status> filter) const {
    std::vector<TaskItem> results;
    sqlite3_stmt* stmt;
    if (filter.has_value()) {
        stmt = prepare("SELECT id, title, priority, status, created_at FROM tasks WHERE status = ? ORDER BY id");
        sqlite3_bind_int(stmt, 1, static_cast<int>(*filter));
    } else {
        stmt = prepare("SELECT id, title, priority, status, created_at FROM tasks ORDER BY id");
    }
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        TaskItem item;
        item.id = sqlite3_column_int(stmt, 0);
        item.title = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 1));
        item.priority = static_cast<Priority>(sqlite3_column_int(stmt, 2));
        item.status = static_cast<Status>(sqlite3_column_int(stmt, 3));
        item.createdAt = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 4));
        results.push_back(std::move(item));
    }
    sqlite3_finalize(stmt);
    return results;
}

void TaskRepository::markDone(int id) {
    sqlite3_stmt* stmt = prepare("UPDATE tasks SET status = ? WHERE id = ?");
    sqlite3_bind_int(stmt, 1, static_cast<int>(Status::Done));
    sqlite3_bind_int(stmt, 2, id);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    // sqlite3_changes() reports rows affected by the LAST statement on this connection --
    // using it as the existence check avoids a separate SELECT-then-UPDATE round trip
    // (which could race under concurrent writers; not a real risk for this single-user
    // CLI, but the pattern is worth using by default regardless, per the C# mini-project's
    // own note on the identical trade-off).
    if (sqlite3_changes(db) == 0) {
        throw TaskNotFoundException(id);
    }
}

void TaskRepository::deleteTask(int id) {
    sqlite3_stmt* stmt = prepare("DELETE FROM tasks WHERE id = ?");
    sqlite3_bind_int(stmt, 1, id);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    if (sqlite3_changes(db) == 0) {
        throw TaskNotFoundException(id);
    }
}

TaskStats TaskRepository::getStats() const {
    TaskStats stats;
    sqlite3_stmt* stmt = prepare("SELECT status, COUNT(*) FROM tasks GROUP BY status");
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        Status s = static_cast<Status>(sqlite3_column_int(stmt, 0));
        int count = sqlite3_column_int(stmt, 1);
        if (s == Status::Done) stats.done = count; else stats.pending = count;
    }
    sqlite3_finalize(stmt);
    return stats;
}
