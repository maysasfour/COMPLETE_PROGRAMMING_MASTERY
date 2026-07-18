/* example.c -- SQLite's C API directly, via the amalgamation
   (sqlite3.h/sqlite3.c, downloaded on demand -- see README.md). C has
   ZERO built-in database access, not even a database-agnostic API like
   Java's JDBC -- this raw C API is what every C/C++ SQLite wrapper is
   ultimately built on. */
#include <stdio.h>
#include "sqlite3.h"

static void checkRc(sqlite3* db, int rc, const char* what) {
    if (rc != SQLITE_OK && rc != SQLITE_DONE && rc != SQLITE_ROW) {
        fprintf(stderr, "%s failed: %s\n", what, sqlite3_errmsg(db));
    }
}

int main(void) {
    sqlite3* db;
    int rc = sqlite3_open(":memory:", &db);   /* in-memory DB, no file left behind */
    if (rc != SQLITE_OK) {
        fprintf(stderr, "cannot open database: %s\n", sqlite3_errmsg(db));
        return 1;
    }

    char* errMsg = NULL;
    rc = sqlite3_exec(db,
        "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT NOT NULL, done INTEGER NOT NULL DEFAULT 0);",
        NULL, NULL, &errMsg);
    if (rc != SQLITE_OK) {
        fprintf(stderr, "CREATE TABLE failed: %s\n", errMsg);
        sqlite3_free(errMsg);
        return 1;
    }

    /* --- INSERT via a prepared statement -- ? placeholders, 1-indexed --- */
    sqlite3_stmt* stmt;
    sqlite3_prepare_v2(db, "INSERT INTO tasks (title) VALUES (?);", -1, &stmt, NULL);
    const char* titles[] = {"Write report", "Review PR", "Water plants"};
    for (int i = 0; i < 3; i++) {
        sqlite3_bind_text(stmt, 1, titles[i], -1, SQLITE_TRANSIENT);
        rc = sqlite3_step(stmt);
        checkRc(db, rc, "insert step");
        sqlite3_reset(stmt);   /* reuse the same compiled statement for the next row */
    }
    sqlite3_finalize(stmt);   /* manual -- no RAII/destructor exists in the raw C API */
    printf("Inserted 3 tasks.\n");

    /* --- SELECT and iterate rows --- */
    printf("\nAll tasks:\n");
    sqlite3_prepare_v2(db, "SELECT id, title, done FROM tasks ORDER BY id;", -1, &stmt, NULL);
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        int id = sqlite3_column_int(stmt, 0);
        const unsigned char* title = sqlite3_column_text(stmt, 1);
        int done = sqlite3_column_int(stmt, 2);
        printf("  [%s] #%d %s\n", done ? "x" : " ", id, title);
    }
    sqlite3_finalize(stmt);

    /* --- UPDATE --- */
    sqlite3_prepare_v2(db, "UPDATE tasks SET done = 1 WHERE id = ?;", -1, &stmt, NULL);
    sqlite3_bind_int(stmt, 1, 1);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    printf("\nMarked task #1 done.\n");

    /* --- DELETE --- */
    sqlite3_prepare_v2(db, "DELETE FROM tasks WHERE id = ?;", -1, &stmt, NULL);
    sqlite3_bind_int(stmt, 1, 3);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    printf("Deleted task #3.\n");

    printf("\nTasks after update/delete:\n");
    sqlite3_prepare_v2(db, "SELECT id, title, done FROM tasks ORDER BY id;", -1, &stmt, NULL);
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        int id = sqlite3_column_int(stmt, 0);
        const unsigned char* title = sqlite3_column_text(stmt, 1);
        int done = sqlite3_column_int(stmt, 2);
        printf("  [%s] #%d %s\n", done ? "x" : " ", id, title);
    }
    sqlite3_finalize(stmt);

    /* --- SQL-injection-safety demonstration, same pattern used throughout
       this repository's other language courses --- */
    printf("\nSQL-injection-safety check:\n");
    const char* maliciousInput = "'); DROP TABLE tasks; --";
    sqlite3_prepare_v2(db, "INSERT INTO tasks (title) VALUES (?);", -1, &stmt, NULL);
    sqlite3_bind_text(stmt, 1, maliciousInput, -1, SQLITE_TRANSIENT);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);

    sqlite3_prepare_v2(db, "SELECT COUNT(*) FROM tasks;", -1, &stmt, NULL);
    sqlite3_step(stmt);
    int remainingCount = sqlite3_column_int(stmt, 0);
    sqlite3_finalize(stmt);
    printf("  Malicious-looking string inserted safely as plain data.\n");
    printf("  Table survived intact -- %d rows remain (table was NOT dropped).\n", remainingCount);

    sqlite3_close(db);
    return 0;
}
