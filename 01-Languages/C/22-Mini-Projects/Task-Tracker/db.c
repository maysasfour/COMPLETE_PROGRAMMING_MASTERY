#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>
#include "db.h"

int dbOpen(sqlite3** db, const char* path) {
    return (sqlite3_open(path, db) == SQLITE_OK) ? 0 : -1;
}

int dbClose(sqlite3* db) {
    return (sqlite3_close(db) == SQLITE_OK) ? 0 : -1;
}

int dbInitSchema(sqlite3* db) {
    const char* sql =
        "CREATE TABLE IF NOT EXISTS tasks ("
        "  id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "  title TEXT NOT NULL,"
        "  done INTEGER NOT NULL DEFAULT 0"
        ");";
    char* errMsg = NULL;
    int rc = sqlite3_exec(db, sql, NULL, NULL, &errMsg);
    if (rc != SQLITE_OK) {
        fprintf(stderr, "dbInitSchema failed: %s\n", errMsg);
        sqlite3_free(errMsg);
        return -1;
    }
    return 0;
}

int dbAddTask(sqlite3* db, const char* title) {
    sqlite3_stmt* stmt;
    int rc = sqlite3_prepare_v2(db, "INSERT INTO tasks (title) VALUES (?);", -1, &stmt, NULL);
    if (rc != SQLITE_OK) return -1;

    sqlite3_bind_text(stmt, 1, title, -1, SQLITE_TRANSIENT);
    rc = sqlite3_step(stmt);
    sqlite3_finalize(stmt);   /* always finalize, on both success and failure paths */

    return (rc == SQLITE_DONE) ? 0 : -1;
}

int dbMarkDone(sqlite3* db, int id) {
    sqlite3_stmt* stmt;
    int rc = sqlite3_prepare_v2(db, "UPDATE tasks SET done = 1 WHERE id = ?;", -1, &stmt, NULL);
    if (rc != SQLITE_OK) return -1;

    sqlite3_bind_int(stmt, 1, id);
    rc = sqlite3_step(stmt);
    int changed = sqlite3_changes(db);
    sqlite3_finalize(stmt);

    return (rc == SQLITE_DONE && changed > 0) ? 0 : -1;
}

int dbDeleteTask(sqlite3* db, int id) {
    sqlite3_stmt* stmt;
    int rc = sqlite3_prepare_v2(db, "DELETE FROM tasks WHERE id = ?;", -1, &stmt, NULL);
    if (rc != SQLITE_OK) return -1;

    sqlite3_bind_int(stmt, 1, id);
    rc = sqlite3_step(stmt);
    int changed = sqlite3_changes(db);
    sqlite3_finalize(stmt);

    return (rc == SQLITE_DONE && changed > 0) ? 0 : -1;
}

int dbForEachTask(sqlite3* db, void (*callback)(const Task*)) {
    sqlite3_stmt* stmt;
    int rc = sqlite3_prepare_v2(db, "SELECT id, title, done FROM tasks ORDER BY id;", -1, &stmt, NULL);
    if (rc != SQLITE_OK) return -1;

    int count = 0;
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        Task t;
        t.id = sqlite3_column_int(stmt, 0);
        const unsigned char* title = sqlite3_column_text(stmt, 1);
        strncpy(t.title, (const char*)title, TASK_TITLE_MAX - 1);
        t.title[TASK_TITLE_MAX - 1] = '\0';
        t.done = sqlite3_column_int(stmt, 2);
        callback(&t);
        count++;
    }
    sqlite3_finalize(stmt);
    return count;
}
