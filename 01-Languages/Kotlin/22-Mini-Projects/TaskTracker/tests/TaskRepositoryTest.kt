import java.sql.Connection
import java.sql.DriverManager
import kotlin.test.Test
import kotlin.test.BeforeTest
import kotlin.test.AfterTest
import kotlin.test.assertEquals
import kotlin.test.assertTrue
import kotlin.test.assertFailsWith

class TaskRepositoryTest {
    private lateinit var conn: Connection
    private lateinit var repo: TaskRepository

    @BeforeTest
    fun setUp() {
        // A FRESH in-memory connection per test, never the real tasks.db file -- SQLite's
        // ":memory:" database only exists for the lifetime of the single connection that
        // created it, so sharing one connection across tests would leak state between them
        // (the exact same reasoning as the C#/Java courses' mini-project test suites).
        Class.forName("org.sqlite.JDBC")
        conn = DriverManager.getConnection("jdbc:sqlite::memory:")
        repo = TaskRepository(conn)
    }

    @AfterTest
    fun tearDown() {
        conn.close()
    }

    @Test
    fun addTaskAssignsIncrementingIds() {
        val first = repo.addTask("Write README", Priority.HIGH)
        val second = repo.addTask("Review PR", Priority.MEDIUM)
        assertEquals(1L, first.id)
        assertEquals(2L, second.id)
    }

    @Test
    fun addedTaskStartsPending() {
        val task = repo.addTask("Water plants", Priority.LOW)
        assertEquals(Status.PENDING, task.status)
    }

    @Test
    fun addTaskRejectsBlankTitle() {
        val exception = assertFailsWith<IllegalArgumentException> {
            repo.addTask("   ", Priority.LOW)
        }
        assertTrue(exception.message!!.contains("blank"))
    }

    @Test
    fun listTasksReturnsAllInInsertionOrder() {
        repo.addTask("First", Priority.LOW)
        repo.addTask("Second", Priority.LOW)
        repo.addTask("Third", Priority.LOW)
        val titles = repo.listTasks().map { it.title }
        assertEquals(listOf("First", "Second", "Third"), titles)
    }

    @Test
    fun listTasksFiltersByStatus() {
        val t1 = repo.addTask("Task A", Priority.LOW)
        repo.addTask("Task B", Priority.LOW)
        repo.markDone(t1.id)

        val pending = repo.listTasks(Status.PENDING)
        val done = repo.listTasks(Status.DONE)

        assertEquals(1, pending.size)
        assertEquals("Task B", pending.single().title)
        assertEquals(1, done.size)
        assertEquals("Task A", done.single().title)
    }

    @Test
    fun markDoneChangesStatus() {
        val task = repo.addTask("Deploy", Priority.HIGH)
        repo.markDone(task.id)
        val reloaded = repo.getTask(task.id)
        assertEquals(Status.DONE, reloaded.status)
    }

    @Test
    fun markDoneOnMissingIdThrows() {
        val exception = assertFailsWith<TaskNotFoundException> {
            repo.markDone(999L)
        }
        assertEquals("No task found with id 999", exception.message)
    }

    @Test
    fun deleteTaskRemovesIt() {
        val task = repo.addTask("Temporary", Priority.LOW)
        repo.deleteTask(task.id)
        assertFailsWith<TaskNotFoundException> { repo.getTask(task.id) }
    }

    @Test
    fun deleteTaskOnMissingIdThrows() {
        assertFailsWith<TaskNotFoundException> { repo.deleteTask(42L) }
    }

    @Test
    fun getStatsCountsPendingAndDone() {
        val t1 = repo.addTask("A", Priority.LOW)
        val t2 = repo.addTask("B", Priority.LOW)
        repo.addTask("C", Priority.LOW)
        repo.markDone(t1.id)
        repo.markDone(t2.id)

        val stats = repo.getStats()
        assertEquals(1, stats.pending)
        assertEquals(2, stats.done)
        assertEquals(3, stats.total)
    }
}
