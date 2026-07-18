/* task.h -- the Task "model": a plain struct plus free functions taking
   a pointer first, C's idiomatic stand-in for a class (Lesson 20,
   Exercise 3, and SQLite's own sqlite3* API use the identical shape). */
#ifndef TASK_H
#define TASK_H

#define TASK_TITLE_MAX 128

typedef struct {
    int id;
    char title[TASK_TITLE_MAX];
    int done;   /* 0 = pending, 1 = done -- C has no bool history before C99's stdbool.h */
} Task;

void taskPrint(const Task* t);

#endif /* TASK_H */
