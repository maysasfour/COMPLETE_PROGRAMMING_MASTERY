// test_TaskRepository.cpp - Catch2 tests (Lesson 18's pattern) against a fresh
// in-memory SQLite database per test. Each TEST_CASE opens its own TaskRepository
// on ":memory:" -- SQLite's in-memory database only exists for the lifetime of the
// single connection that created it, so a fresh TaskRepository per test genuinely
// cannot leak state between tests, unlike a single shared connection reused across cases.
#define CATCH_CONFIG_MAIN
#include "catch_amalgamated.hpp"
#include "../TaskRepository.hpp"
#include "../TaskNotFoundException.hpp"

TEST_CASE("addTask returns an incrementing id and defaults to Pending", "[repository]") {
    TaskRepository repo(":memory:");
    int id1 = repo.addTask("First task", Priority::Medium);
    int id2 = repo.addTask("Second task", Priority::High);
    REQUIRE(id1 == 1);
    REQUIRE(id2 == 2);

    auto tasks = repo.listTasks();
    REQUIRE(tasks.size() == 2);
    REQUIRE(tasks[0].status == Status::Pending);
}

TEST_CASE("addTask rejects an empty title", "[repository]") {
    TaskRepository repo(":memory:");
    REQUIRE_THROWS_AS(repo.addTask("", Priority::Low), std::invalid_argument);
}

TEST_CASE("listTasks with no filter returns every task", "[repository]") {
    TaskRepository repo(":memory:");
    repo.addTask("A", Priority::Low);
    repo.addTask("B", Priority::Medium);
    repo.addTask("C", Priority::High);
    REQUIRE(repo.listTasks().size() == 3);
}

TEST_CASE("listTasks filters by status", "[repository]") {
    TaskRepository repo(":memory:");
    int id1 = repo.addTask("A", Priority::Low);
    repo.addTask("B", Priority::Medium);
    repo.markDone(id1);

    auto pending = repo.listTasks(Status::Pending);
    auto done = repo.listTasks(Status::Done);
    REQUIRE(pending.size() == 1);
    REQUIRE(done.size() == 1);
    REQUIRE(done[0].title == "A");
}

TEST_CASE("markDone flips status for the correct row only", "[repository]") {
    TaskRepository repo(":memory:");
    int id1 = repo.addTask("A", Priority::Low);
    int id2 = repo.addTask("B", Priority::Low);
    repo.markDone(id1);

    auto tasks = repo.listTasks();
    REQUIRE(tasks[0].id == id1);
    REQUIRE(tasks[0].status == Status::Done);
    REQUIRE(tasks[1].id == id2);
    REQUIRE(tasks[1].status == Status::Pending);
}

TEST_CASE("markDone throws TaskNotFoundException for a nonexistent id", "[repository]") {
    TaskRepository repo(":memory:");
    REQUIRE_THROWS_AS(repo.markDone(999), TaskNotFoundException);
}

TEST_CASE("deleteTask removes exactly one row", "[repository]") {
    TaskRepository repo(":memory:");
    repo.addTask("A", Priority::Low);
    int id2 = repo.addTask("B", Priority::Low);
    repo.deleteTask(id2);

    auto tasks = repo.listTasks();
    REQUIRE(tasks.size() == 1);
    REQUIRE(tasks[0].title == "A");
}

TEST_CASE("deleteTask throws TaskNotFoundException for a nonexistent id", "[repository]") {
    TaskRepository repo(":memory:");
    REQUIRE_THROWS_AS(repo.deleteTask(42), TaskNotFoundException);
}

TEST_CASE("getStats counts pending and done correctly", "[repository]") {
    TaskRepository repo(":memory:");
    int id1 = repo.addTask("A", Priority::Low);
    repo.addTask("B", Priority::Low);
    repo.addTask("C", Priority::Low);
    repo.markDone(id1);

    TaskStats stats = repo.getStats();
    REQUIRE(stats.pending == 2);
    REQUIRE(stats.done == 1);
    REQUIRE(stats.total() == 3);
}

TEST_CASE("priority round-trips through the database correctly", "[repository]") {
    TaskRepository repo(":memory:");
    repo.addTask("Urgent thing", Priority::High);
    auto tasks = repo.listTasks();
    REQUIRE(tasks[0].priority == Priority::High);
    REQUIRE(toString(tasks[0].priority) == "High");
}

TEST_CASE("parsePriority and parseStatus reject invalid input", "[repository]") {
    REQUIRE_THROWS_AS(parsePriority("extreme"), std::invalid_argument);
    REQUIRE_THROWS_AS(parseStatus("archived"), std::invalid_argument);
}
