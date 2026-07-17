using Microsoft.Data.Sqlite;
using TaskTracker;

namespace TaskTracker.Tests;

// Each test opens its own fresh in-memory connection ("Data Source=:memory:")
// rather than sharing one across tests -- SQLite's in-memory database is
// tied to the single connection that created it and disappears the moment
// that connection closes, so a per-test connection is what guarantees tests
// never see leftover state from a previous test.
public class TaskRepositoryTests {
    private static TaskRepository CreateRepository(out SqliteConnection connection) {
        connection = new SqliteConnection("Data Source=:memory:");
        connection.Open();
        var repository = new TaskRepository(connection);
        repository.InitDb();
        return repository;
    }

    [Fact]
    public void AddTask_ReturnsTaskWithGeneratedId() {
        var repository = CreateRepository(out var connection);
        using (connection) {
            var task = repository.AddTask("Write tests", Priority.High);

            Assert.Equal(1, task.Id);
            Assert.Equal("Write tests", task.Title);
            Assert.Equal(Priority.High, task.Priority);
            Assert.Equal(Status.Pending, task.Status);
        }
    }

    [Fact]
    public void AddTask_ThrowsOnEmptyTitle() {
        var repository = CreateRepository(out var connection);
        using (connection) {
            var ex = Assert.Throws<ArgumentException>(() => repository.AddTask("   ", Priority.Low));
            Assert.Contains("cannot be empty", ex.Message);
        }
    }

    [Fact]
    public void ListTasks_ReturnsAllTasksInInsertionOrder() {
        var repository = CreateRepository(out var connection);
        using (connection) {
            repository.AddTask("First", Priority.Low);
            repository.AddTask("Second", Priority.Medium);

            var tasks = repository.ListTasks();

            Assert.Equal(2, tasks.Count);
            Assert.Equal("First", tasks[0].Title);
            Assert.Equal("Second", tasks[1].Title);
        }
    }

    [Fact]
    public void ListTasks_FiltersByStatus() {
        var repository = CreateRepository(out var connection);
        using (connection) {
            var first = repository.AddTask("Finish report", Priority.High);
            repository.AddTask("Read book", Priority.Low);
            repository.MarkDone(first.Id);

            var doneTasks = repository.ListTasks(Status.Done);
            var pendingTasks = repository.ListTasks(Status.Pending);

            Assert.Single(doneTasks);
            Assert.Equal("Finish report", doneTasks[0].Title);
            Assert.Single(pendingTasks);
            Assert.Equal("Read book", pendingTasks[0].Title);
        }
    }

    [Fact]
    public void MarkDone_ChangesStatusToDone() {
        var repository = CreateRepository(out var connection);
        using (connection) {
            var task = repository.AddTask("Ship it", Priority.High);

            repository.MarkDone(task.Id);
            var updated = repository.ListTasks().Single(t => t.Id == task.Id);

            Assert.Equal(Status.Done, updated.Status);
        }
    }

    [Fact]
    public void MarkDone_ThrowsTaskNotFoundExceptionForUnknownId() {
        var repository = CreateRepository(out var connection);
        using (connection) {
            var ex = Assert.Throws<TaskNotFoundException>(() => repository.MarkDone(999));
            Assert.Equal(999, ex.TaskId);
        }
    }

    [Fact]
    public void DeleteTask_RemovesTaskFromList() {
        var repository = CreateRepository(out var connection);
        using (connection) {
            var task = repository.AddTask("Temporary", Priority.Low);

            repository.DeleteTask(task.Id);

            Assert.Empty(repository.ListTasks());
        }
    }

    [Fact]
    public void DeleteTask_ThrowsTaskNotFoundExceptionForUnknownId() {
        var repository = CreateRepository(out var connection);
        using (connection) {
            Assert.Throws<TaskNotFoundException>(() => repository.DeleteTask(999));
        }
    }

    [Fact]
    public void GetStats_CountsPendingAndDoneSeparately() {
        var repository = CreateRepository(out var connection);
        using (connection) {
            var t1 = repository.AddTask("A", Priority.Low);
            repository.AddTask("B", Priority.Medium);
            repository.AddTask("C", Priority.High);
            repository.MarkDone(t1.Id);

            var stats = repository.GetStats();

            Assert.Equal(2, stats.Pending);
            Assert.Equal(1, stats.Done);
            Assert.Equal(3, stats.Total);
        }
    }

    [Fact]
    public void GetStats_ReturnsZeroesOnEmptyDatabase() {
        var repository = CreateRepository(out var connection);
        using (connection) {
            var stats = repository.GetStats();

            Assert.Equal(0, stats.Pending);
            Assert.Equal(0, stats.Done);
            Assert.Equal(0, stats.Total);
        }
    }
}
