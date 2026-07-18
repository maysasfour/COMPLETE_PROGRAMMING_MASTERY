/* db.h -- SQLite-backed persistence layer, following Lesson 16's exact
   raw C API approach (prepared statements, manual finalize/reset, no
   RAII of any kind). All functions return an int status: 0 = success,
   nonzero = failure, following Lesson 09's return-code convention. */
#ifndef DB_H
#define DB_H

#include "sqlite3.h"
#include "task.h"

int dbOpen(sqlite3** db, const char* path);
int dbClose(sqlite3* db);
int dbInitSchema(sqlite3* db);

int dbAddTask(sqlite3* db, const char* title);
int dbMarkDone(sqlite3* db, int id);
int dbDeleteTask(sqlite3* db, int id);

/* Calls callback once per task, in id order. Returns the number of
   tasks visited, or -1 on error. */
int dbForEachTask(sqlite3* db, void (*callback)(const Task*));

#endif /* DB_H */
