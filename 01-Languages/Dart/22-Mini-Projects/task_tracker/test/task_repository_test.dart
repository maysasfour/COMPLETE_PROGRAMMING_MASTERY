// task_repository_test.dart - 10 tests against a FRESH in-memory SQLite database
// per test (Data Source is effectively in-memory via sqlite3.openInMemory()), following
// this course's Lesson 18 pattern. Each test opens its own connection because SQLite's
// in-memory database only exists for the lifetime of the single connection that created
// it -- sharing one connection across tests would leak state between them.

import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

import 'package:task_tracker/task_item.dart';
import 'package:task_tracker/task_not_found_exception.dart';
import 'package:task_tracker/task_repository.dart';

void main() {
  late Database db;
  late TaskRepository repo;

  setUp(() {
    db = sqlite3.openInMemory(); // fresh, isolated DB for every test -- never the real tasks.db
    repo = TaskRepository(db);
    repo.initDb();
  });

  tearDown(() {
    db.dispose(); // releases the native SQLite connection -- Lesson 16's dispose() discipline
  });

  test('addTask returns a TaskItem with an assigned id and pending status', () {
    var task = repo.addTask('Write tests', Priority.high);
    expect(task.id, greaterThan(0));
    expect(task.title, equals('Write tests'));
    expect(task.priority, equals(Priority.high));
    expect(task.status, equals(Status.pending));
  });

  test('addTask rejects an empty title', () {
    expect(() => repo.addTask('   ', Priority.low), throwsArgumentError);
  });

  test('addTask assigns sequential ids across multiple inserts', () {
    var first = repo.addTask('First', Priority.low);
    var second = repo.addTask('Second', Priority.low);
    expect(second.id, equals(first.id + 1));
  });

  test('listTasks with no filter returns everything in insertion order', () {
    repo.addTask('A', Priority.low);
    repo.addTask('B', Priority.medium);
    var tasks = repo.listTasks();
    expect(tasks.map((t) => t.title).toList(), equals(['A', 'B']));
  });

  test('listTasks filters by status', () {
    var t1 = repo.addTask('Pending one', Priority.low);
    repo.addTask('Pending two', Priority.low);
    repo.markDone(t1.id);

    var doneTasks = repo.listTasks(statusFilter: Status.done);
    var pendingTasks = repo.listTasks(statusFilter: Status.pending);

    expect(doneTasks.length, equals(1));
    expect(doneTasks.single.title, equals('Pending one'));
    expect(pendingTasks.length, equals(1));
    expect(pendingTasks.single.title, equals('Pending two'));
  });

  test('markDone flips a task to done status', () {
    var task = repo.addTask('Finish lesson', Priority.medium);
    repo.markDone(task.id);
    var reloaded = repo.listTasks().single;
    expect(reloaded.status, equals(Status.done));
  });

  test('markDone on a nonexistent id throws TaskNotFoundException', () {
    expect(() => repo.markDone(999), throwsA(isA<TaskNotFoundException>()));
  });

  test('deleteTask removes exactly the targeted row', () {
    var t1 = repo.addTask('Keep me', Priority.low);
    var t2 = repo.addTask('Delete me', Priority.low);
    repo.deleteTask(t2.id);

    var remaining = repo.listTasks();
    expect(remaining.length, equals(1));
    expect(remaining.single.id, equals(t1.id));
  });

  test('deleteTask on a nonexistent id throws TaskNotFoundException', () {
    expect(() => repo.deleteTask(999), throwsA(isA<TaskNotFoundException>()));
  });

  test('getStats counts pending and done correctly', () {
    var t1 = repo.addTask('One', Priority.low);
    repo.addTask('Two', Priority.low);
    repo.addTask('Three', Priority.low);
    repo.markDone(t1.id);

    var stats = repo.getStats();
    expect(stats.pending, equals(2));
    expect(stats.done, equals(1));
    expect(stats.total, equals(3));
  });
}
