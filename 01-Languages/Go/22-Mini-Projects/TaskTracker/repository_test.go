// repository_test.go - table-driven tests using only the standard testing package, following
// Lesson 18's idiom exactly. Every test opens its own fresh in-memory SQLite connection --
// ":memory:" only lives for the lifetime of the single *sql.DB connection that created it, so
// sharing one across tests would leak state between them (the same reasoning as the mini
// project's C# counterpart, adapted to Go's own database/sql + modernc.org/sqlite stack).
package main

import (
	"database/sql"
	"errors"
	"testing"

	_ "modernc.org/sqlite"
)

// newTestRepo is the one piece of setup duplicated across every test below -- intentionally
// not hoisted into TestMain, since TestMain's shared state is exactly what per-test isolation
// here is trying to avoid.
func newTestRepo(t *testing.T) *Repository {
	t.Helper()
	db, err := sql.Open("sqlite", ":memory:")
	if err != nil {
		t.Fatalf("failed to open in-memory db: %v", err)
	}
	t.Cleanup(func() { db.Close() })

	repo := NewRepository(db)
	if err := repo.Init(); err != nil {
		t.Fatalf("failed to init schema: %v", err)
	}
	return repo
}

func TestAddInsertsTaskWithPendingStatus(t *testing.T) {
	repo := newTestRepo(t)

	task, err := repo.Add("Write tests", PriorityHigh)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if task.ID == 0 {
		t.Error("expected a non-zero autoincrement id")
	}
	if task.Title != "Write tests" {
		t.Errorf("Title = %q; want %q", task.Title, "Write tests")
	}
	if task.Priority != PriorityHigh {
		t.Errorf("Priority = %v; want %v", task.Priority, PriorityHigh)
	}
	if task.Status != StatusPending {
		t.Errorf("Status = %v; want %v (newly added tasks must start pending)", task.Status, StatusPending)
	}
}

func TestAddAssignsIncrementingIDs(t *testing.T) {
	repo := newTestRepo(t)

	first, err := repo.Add("First", PriorityLow)
	if err != nil {
		t.Fatalf("unexpected error adding first task: %v", err)
	}
	second, err := repo.Add("Second", PriorityLow)
	if err != nil {
		t.Fatalf("unexpected error adding second task: %v", err)
	}
	if second.ID <= first.ID {
		t.Errorf("second.ID (%d) should be greater than first.ID (%d)", second.ID, first.ID)
	}
}

func TestListReturnsAllTasksWhenNoFilterGiven(t *testing.T) {
	repo := newTestRepo(t)
	repo.Add("A", PriorityLow)
	repo.Add("B", PriorityMedium)
	repo.Add("C", PriorityHigh)

	tasks, err := repo.List(nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(tasks) != 3 {
		t.Errorf("got %d tasks; want 3", len(tasks))
	}
}

func TestListFiltersByStatus(t *testing.T) {
	repo := newTestRepo(t)
	first, _ := repo.Add("Done task", PriorityLow)
	repo.Add("Pending task", PriorityLow)
	if err := repo.MarkDone(first.ID); err != nil {
		t.Fatalf("unexpected error marking done: %v", err)
	}

	pending := StatusPending
	pendingTasks, err := repo.List(&pending)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(pendingTasks) != 1 {
		t.Fatalf("got %d pending tasks; want 1", len(pendingTasks))
	}
	if pendingTasks[0].Title != "Pending task" {
		t.Errorf("pending task title = %q; want %q", pendingTasks[0].Title, "Pending task")
	}

	done := StatusDone
	doneTasks, err := repo.List(&done)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(doneTasks) != 1 || doneTasks[0].ID != first.ID {
		t.Errorf("done tasks = %+v; want exactly [%+v]", doneTasks, first)
	}
}

func TestMarkDoneUpdatesStatus(t *testing.T) {
	repo := newTestRepo(t)
	task, _ := repo.Add("Finish lesson", PriorityMedium)

	if err := repo.MarkDone(task.ID); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	tasks, _ := repo.List(nil)
	if len(tasks) != 1 || tasks[0].Status != StatusDone {
		t.Errorf("task after MarkDone = %+v; want Status = %v", tasks, StatusDone)
	}
}

func TestMarkDoneReturnsTaskNotFoundErrorForMissingID(t *testing.T) {
	repo := newTestRepo(t)

	err := repo.MarkDone(999)
	if err == nil {
		t.Fatal("expected an error for a nonexistent id, got nil")
	}

	var notFound *TaskNotFoundError
	if !errors.As(err, &notFound) {
		t.Errorf("error = %v (%T); want a *TaskNotFoundError", err, err)
	} else if notFound.ID != 999 {
		t.Errorf("TaskNotFoundError.ID = %d; want 999", notFound.ID)
	}
}

func TestDeleteRemovesTask(t *testing.T) {
	repo := newTestRepo(t)
	task, _ := repo.Add("Delete me", PriorityLow)

	if err := repo.Delete(task.ID); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	tasks, _ := repo.List(nil)
	if len(tasks) != 0 {
		t.Errorf("got %d tasks after delete; want 0", len(tasks))
	}
}

func TestDeleteReturnsTaskNotFoundErrorForMissingID(t *testing.T) {
	repo := newTestRepo(t)

	err := repo.Delete(42)
	var notFound *TaskNotFoundError
	if !errors.As(err, &notFound) {
		t.Errorf("error = %v; want a *TaskNotFoundError", err)
	}
}

// TestStats is table-driven over several starting scenarios, following Lesson 18's idiom of a
// slice of anonymous structs -- each case builds its own fresh repo so cases can't interfere.
func TestStats(t *testing.T) {
	cases := []struct {
		name        string
		setup       func(r *Repository)
		wantPending int
		wantDone    int
		wantTotal   int
	}{
		{
			name:        "empty repository",
			setup:       func(r *Repository) {},
			wantPending: 0, wantDone: 0, wantTotal: 0,
		},
		{
			name: "all pending",
			setup: func(r *Repository) {
				r.Add("A", PriorityLow)
				r.Add("B", PriorityLow)
			},
			wantPending: 2, wantDone: 0, wantTotal: 2,
		},
		{
			name: "mixed pending and done",
			setup: func(r *Repository) {
				a, _ := r.Add("A", PriorityLow)
				r.Add("B", PriorityLow)
				r.Add("C", PriorityLow)
				r.MarkDone(a.ID)
			},
			wantPending: 2, wantDone: 1, wantTotal: 3,
		},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			repo := newTestRepo(t)
			c.setup(repo)

			stats, err := repo.Stats()
			if err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
			if stats != (TaskStats{Pending: c.wantPending, Done: c.wantDone, Total: c.wantTotal}) {
				t.Errorf("Stats() = %+v; want {Pending:%d Done:%d Total:%d}", stats, c.wantPending, c.wantDone, c.wantTotal)
			}
		})
	}
}
