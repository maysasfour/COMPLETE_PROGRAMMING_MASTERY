// TaskRepository.hpp - CRUD against SQLite via the raw C API (Lesson 16), wrapped in a
// small RAII class so the rest of the program never touches sqlite3*/sqlite3_stmt*
// directly, nor has to remember a single sqlite3_close()/sqlite3_finalize() call --
// exactly the "wrap the raw C handles in your own RAII class" guidance Lesson 16's
// README explicitly leaves as a follow-up, made real here instead of just described.
#pragma once
#include <string>
#include <vector>
#include <optional>
#include "sqlite3.h"
#include "TaskItem.hpp"

class TaskRepository {
    sqlite3* db = nullptr;

    // A single centralized "run this SQL, log-and-throw on real errors" helper --
    // every public method funnels through prepare/bind/step/finalize using this pattern
    // instead of hand-rolling error handling seven separate times.
    sqlite3_stmt* prepare(const std::string& sql) const;

public:
    // Opens (or creates) the database file at `path` and ensures the schema exists.
    // Pass ":memory:" for an ephemeral in-memory database -- exactly what the test
    // suite uses, so tests never touch a real tasks.db file on disk.
    explicit TaskRepository(const std::string& path);

    // Rule of Five, applied for real: this class owns a raw sqlite3* handle directly
    // (Lesson 19's "if you must manage a raw resource, implement all five" case,
    // since the raw C API gives us nothing RAII-shaped to compose from instead).
    ~TaskRepository();
    TaskRepository(const TaskRepository&) = delete;            // a sqlite3* connection isn't safely copyable
    TaskRepository& operator=(const TaskRepository&) = delete;
    TaskRepository(TaskRepository&& other) noexcept;
    TaskRepository& operator=(TaskRepository&& other) noexcept;

    // Returns the new row's id.
    int addTask(const std::string& title, Priority priority);

    std::vector<TaskItem> listTasks(std::optional<Status> filter = std::nullopt) const;

    // Throws TaskNotFoundException if no row with this id exists.
    void markDone(int id);
    void deleteTask(int id);

    TaskStats getStats() const;
};
