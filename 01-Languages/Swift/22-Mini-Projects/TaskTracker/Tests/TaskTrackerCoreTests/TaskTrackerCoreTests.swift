// TaskTrackerCoreTests.swift -- XCTest suite (Lesson 18's approach: `XCTestCase`,
// `setUp()`, `XCTAssertEqual`/`XCTAssertThrowsError`), run against a fresh in-memory
// SQLite database (`:memory:`) per test via `setUp()`, so no test can leak state into
// another and nothing is left on disk after the suite finishes.

import XCTest
@testable import TaskTrackerCore

final class TaskTrackerCoreTests: XCTestCase {
    var repository: TaskRepository!

    override func setUp() {
        super.setUp()
        repository = TaskRepository(path: ":memory:")
    }

    func testAddTaskReturnsAssignedId() {
        let task = repository.addTask(title: "Write tests", priority: .high)
        XCTAssertEqual(task.title, "Write tests")
        XCTAssertEqual(task.priority, .high)
        XCTAssertFalse(task.done)
        XCTAssertEqual(task.id, 1) // first row in a fresh in-memory database
    }

    func testAddTaskDefaultsToMediumPriority() {
        let task = repository.addTask(title: "Default priority", priority: .medium)
        XCTAssertEqual(task.priority, .medium)
    }

    func testAllTasksReturnsInInsertionOrder() {
        repository.addTask(title: "First", priority: .low)
        repository.addTask(title: "Second", priority: .high)
        let tasks = repository.allTasks()
        XCTAssertEqual(tasks.map(\.title), ["First", "Second"])
    }

    func testAllTasksIsEmptyForFreshDatabase() {
        XCTAssertTrue(repository.allTasks().isEmpty)
    }

    func testMarkDoneUpdatesExistingTask() throws {
        let task = repository.addTask(title: "Finish lesson", priority: .medium)
        try repository.markDone(id: task.id)
        let reloaded = repository.allTasks().first { $0.id == task.id }
        XCTAssertEqual(reloaded?.done, true)
    }

    func testMarkDoneOnMissingIdThrows() {
        XCTAssertThrowsError(try repository.markDone(id: 999)) { error in
            XCTAssertEqual(error as? TaskTrackerError, .taskNotFound(999))
        }
    }

    func testDeleteRemovesTask() throws {
        let task = repository.addTask(title: "Delete me", priority: .low)
        try repository.delete(id: task.id)
        XCTAssertTrue(repository.allTasks().isEmpty)
    }

    func testDeleteOnMissingIdThrows() {
        XCTAssertThrowsError(try repository.delete(id: 42)) { error in
            XCTAssertEqual(error as? TaskTrackerError, .taskNotFound(42))
        }
    }

    func testStatsCountsTotalDoneAndPending() throws {
        let first = repository.addTask(title: "A", priority: .low)
        repository.addTask(title: "B", priority: .medium)
        repository.addTask(title: "C", priority: .high)
        try repository.markDone(id: first.id)

        let stats = repository.stats()
        XCTAssertEqual(stats.total, 3)
        XCTAssertEqual(stats.done, 1)
        XCTAssertEqual(stats.pending, 2)
    }

    func testEachRepositoryInstanceIsIsolated() {
        // A second `:memory:` database is a genuinely SEPARATE database, not a second
        // handle to the same one -- proving tests don't leak state through some shared
        // "the" in-memory database, and neither would two real CLI invocations without
        // an explicit shared file path.
        repository.addTask(title: "Only in this repository", priority: .medium)
        let otherRepository = TaskRepository(path: ":memory:")
        XCTAssertTrue(otherRepository.allTasks().isEmpty)
        XCTAssertEqual(repository.allTasks().count, 1)
    }
}
