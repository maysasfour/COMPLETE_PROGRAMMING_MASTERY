/* cli.c -- hand-rolled argv parsing (no third-party CLI framework, the
   same deliberate choice this repository's Node/TS mini-projects make).
   Usage:
     tasktracker.exe add "Write report"
     tasktracker.exe list
     tasktracker.exe done 1
     tasktracker.exe delete 3
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "db.h"

static void printTask(const Task* t) {
    taskPrint(t);
}

static void printUsage(void) {
    printf("Usage: tasktracker <add|list|done|delete> [args]\n");
    printf("  add <title>     add a new task\n");
    printf("  list            list all tasks\n");
    printf("  done <id>       mark a task done\n");
    printf("  delete <id>     delete a task\n");
}

int main(int argc, char* argv[]) {
    sqlite3* db;
    if (dbOpen(&db, "tasks.db") != 0) {
        fprintf(stderr, "Failed to open database.\n");
        return 1;
    }
    if (dbInitSchema(db) != 0) {
        dbClose(db);
        return 1;
    }

    if (argc < 2) {
        printUsage();
        dbClose(db);
        return 1;
    }

    int exitCode = 0;

    if (strcmp(argv[1], "add") == 0 && argc >= 3) {
        if (dbAddTask(db, argv[2]) == 0) {
            printf("Added task: %s\n", argv[2]);
        } else {
            fprintf(stderr, "Failed to add task.\n");
            exitCode = 1;
        }
    } else if (strcmp(argv[1], "list") == 0) {
        int count = dbForEachTask(db, printTask);
        if (count == 0) printf("  (no tasks)\n");
    } else if (strcmp(argv[1], "done") == 0 && argc >= 3) {
        int id = atoi(argv[2]);
        if (dbMarkDone(db, id) == 0) {
            printf("Marked task #%d done.\n", id);
        } else {
            fprintf(stderr, "No task with id %d.\n", id);
            exitCode = 1;
        }
    } else if (strcmp(argv[1], "delete") == 0 && argc >= 3) {
        int id = atoi(argv[2]);
        if (dbDeleteTask(db, id) == 0) {
            printf("Deleted task #%d.\n", id);
        } else {
            fprintf(stderr, "No task with id %d.\n", id);
            exitCode = 1;
        }
    } else {
        printUsage();
        exitCode = 1;
    }

    dbClose(db);
    return exitCode;
}
