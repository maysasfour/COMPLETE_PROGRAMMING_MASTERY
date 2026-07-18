/* tests.c -- the hand-rolled minitest.h harness from Lesson 18, run
   against db.c's real SQLite-backed functions using an in-memory
   database (":memory:") so no file is left behind. */
#include "minitest.h"
#include "db.h"

static int g_lastSeenId = 0;
static int g_lastSeenDone = 0;
static int g_visitCount = 0;

static void collectLast(const Task* t) {
    g_lastSeenId = t->id;
    g_lastSeenDone = t->done;
    g_visitCount++;
}

static sqlite3* openFreshDb(void) {
    sqlite3* db;
    dbOpen(&db, ":memory:");
    dbInitSchema(db);
    return db;
}

TEST_CASE(test_add_and_list) {
    sqlite3* db = openFreshDb();
    ASSERT_EQ_INT(0, dbAddTask(db, "Write report"));
    ASSERT_EQ_INT(0, dbAddTask(db, "Review PR"));

    g_visitCount = 0;
    int count = dbForEachTask(db, collectLast);
    ASSERT_EQ_INT(2, count);
    ASSERT_EQ_INT(2, g_visitCount);
    ASSERT_EQ_INT(2, g_lastSeenId);   /* last row visited, in id order, is id 2 */
    ASSERT_EQ_INT(0, g_lastSeenDone); /* new tasks default to not-done */

    dbClose(db);
}

TEST_CASE(test_mark_done) {
    sqlite3* db = openFreshDb();
    dbAddTask(db, "Water plants");

    ASSERT_EQ_INT(0, dbMarkDone(db, 1));

    dbForEachTask(db, collectLast);
    ASSERT_EQ_INT(1, g_lastSeenDone);

    dbClose(db);
}

TEST_CASE(test_mark_done_nonexistent_id_fails) {
    sqlite3* db = openFreshDb();
    dbAddTask(db, "Only task");

    /* id 99 does not exist -- dbMarkDone must report failure, not
       silently succeed with zero rows changed. */
    ASSERT_EQ_INT(-1, dbMarkDone(db, 99));

    dbClose(db);
}

TEST_CASE(test_delete_task) {
    sqlite3* db = openFreshDb();
    dbAddTask(db, "Task A");
    dbAddTask(db, "Task B");

    ASSERT_EQ_INT(0, dbDeleteTask(db, 1));

    g_visitCount = 0;
    int count = dbForEachTask(db, collectLast);
    ASSERT_EQ_INT(1, count);
    ASSERT_EQ_INT(2, g_lastSeenId);   /* task 1 gone, only task 2 remains */

    dbClose(db);
}

TEST_CASE(test_delete_nonexistent_id_fails) {
    sqlite3* db = openFreshDb();
    dbAddTask(db, "Only task");

    ASSERT_EQ_INT(-1, dbDeleteTask(db, 42));

    dbClose(db);
}

TEST_CASE(test_empty_db_has_no_tasks) {
    sqlite3* db = openFreshDb();

    g_visitCount = 0;
    int count = dbForEachTask(db, collectLast);
    ASSERT_EQ_INT(0, count);
    ASSERT_EQ_INT(0, g_visitCount);

    dbClose(db);
}

int main(void) {
    RUN_TEST(test_add_and_list);
    RUN_TEST(test_mark_done);
    RUN_TEST(test_mark_done_nonexistent_id_fails);
    RUN_TEST(test_delete_task);
    RUN_TEST(test_delete_nonexistent_id_fails);
    RUN_TEST(test_empty_db_has_no_tasks);

    MINITEST_SUMMARY();
    return MINITEST_EXIT_CODE();
}
