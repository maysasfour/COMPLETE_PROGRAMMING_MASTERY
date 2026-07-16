// example.cpp - CRUD against SQLite using its C API directly, with parameterized queries.
// Requires sqlite3.h/sqlite3.c (the "amalgamation" -- a single-file build of SQLite) --
// see this lesson's README for the download command, since the standard library has no
// built-in database access (matching every other language course's honest gap here).

#include <iostream>
#include <string>
#include "sqlite3.h"

void checkRc(int rc, sqlite3* db, const std::string& context) {
    if (rc != SQLITE_OK && rc != SQLITE_DONE && rc != SQLITE_ROW) {
        std::cerr << context << " failed: " << sqlite3_errmsg(db) << std::endl;
    }
}

int main() {
    sqlite3* db;
    sqlite3_open(":memory:", &db);

    char* errMsg = nullptr;
    sqlite3_exec(db,
        "CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, done INTEGER NOT NULL DEFAULT 0)",
        nullptr, nullptr, &errMsg);

    std::cout << "--- CREATE (parameterized) ---" << std::endl;
    sqlite3_stmt* insertStmt;
    sqlite3_prepare_v2(db, "INSERT INTO tasks (title) VALUES (?)", -1, &insertStmt, nullptr);
    for (const std::string& title : {"Write lesson", "Test examples", "Ship it"}) {
        sqlite3_bind_text(insertStmt, 1, title.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_step(insertStmt);
        sqlite3_reset(insertStmt);
    }
    sqlite3_finalize(insertStmt);
    std::cout << "Inserted 3 rows." << std::endl;

    std::cout << "\n--- READ (all) ---" << std::endl;
    sqlite3_stmt* selectStmt;
    sqlite3_prepare_v2(db, "SELECT id, title, done FROM tasks", -1, &selectStmt, nullptr);
    while (sqlite3_step(selectStmt) == SQLITE_ROW) {
        int id = sqlite3_column_int(selectStmt, 0);
        const unsigned char* title = sqlite3_column_text(selectStmt, 1);
        int done = sqlite3_column_int(selectStmt, 2);
        std::cout << "  id=" << id << ", title=" << title << ", done=" << done << std::endl;
    }
    sqlite3_finalize(selectStmt);

    std::cout << "\n--- UPDATE (parameterized) ---" << std::endl;
    sqlite3_stmt* updateStmt;
    sqlite3_prepare_v2(db, "UPDATE tasks SET done = 1 WHERE id = ?", -1, &updateStmt, nullptr);
    sqlite3_bind_int(updateStmt, 1, 1);
    sqlite3_step(updateStmt);
    sqlite3_finalize(updateStmt);

    sqlite3_stmt* checkStmt;
    sqlite3_prepare_v2(db, "SELECT done FROM tasks WHERE id = ?", -1, &checkStmt, nullptr);
    sqlite3_bind_int(checkStmt, 1, 1);
    sqlite3_step(checkStmt);
    std::cout << "Row 1 done status after update: " << sqlite3_column_int(checkStmt, 0) << std::endl;
    sqlite3_finalize(checkStmt);

    std::cout << "\n--- DELETE (parameterized) ---" << std::endl;
    sqlite3_stmt* deleteStmt;
    sqlite3_prepare_v2(db, "DELETE FROM tasks WHERE id = ?", -1, &deleteStmt, nullptr);
    sqlite3_bind_int(deleteStmt, 1, 3);
    sqlite3_step(deleteStmt);
    sqlite3_finalize(deleteStmt);

    sqlite3_stmt* countStmt;
    sqlite3_prepare_v2(db, "SELECT COUNT(*) FROM tasks", -1, &countStmt, nullptr);
    sqlite3_step(countStmt);
    std::cout << "Remaining row count: " << sqlite3_column_int(countStmt, 0) << std::endl;
    sqlite3_finalize(countStmt);

    std::cout << "\n--- parameterized queries prevent SQL injection ---" << std::endl;
    std::string maliciousTitle = "'; DROP TABLE tasks; --";
    sqlite3_stmt* maliciousInsert;
    sqlite3_prepare_v2(db, "INSERT INTO tasks (title) VALUES (?)", -1, &maliciousInsert, nullptr);
    sqlite3_bind_text(maliciousInsert, 1, maliciousTitle.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_step(maliciousInsert);
    sqlite3_finalize(maliciousInsert);

    sqlite3_stmt* verifyStmt;
    sqlite3_prepare_v2(db, "SELECT title FROM tasks WHERE title = ?", -1, &verifyStmt, nullptr);
    sqlite3_bind_text(verifyStmt, 1, maliciousTitle.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_step(verifyStmt);
    std::cout << "Malicious-looking string stored and retrieved as plain data: "
              << sqlite3_column_text(verifyStmt, 0) << std::endl;
    sqlite3_finalize(verifyStmt);

    sqlite3_stmt* finalCountStmt;
    sqlite3_prepare_v2(db, "SELECT COUNT(*) FROM tasks", -1, &finalCountStmt, nullptr);
    sqlite3_step(finalCountStmt);
    std::cout << "Table still exists with all rows intact: " << sqlite3_column_int(finalCountStmt, 0) << std::endl;
    sqlite3_finalize(finalCountStmt);

    sqlite3_close(db);
    return 0;
}
