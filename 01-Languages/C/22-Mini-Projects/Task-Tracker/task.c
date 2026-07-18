#include <stdio.h>
#include "task.h"

void taskPrint(const Task* t) {
    printf("  [%c] #%d %s\n", t->done ? 'x' : ' ', t->id, t->title);
}
