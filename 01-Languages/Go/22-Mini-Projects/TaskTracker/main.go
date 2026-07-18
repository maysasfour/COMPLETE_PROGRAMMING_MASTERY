// main.go - the CLI entry point. Its only job is argv parsing and dispatch; every actual
// database operation lives in repository.go so it can be unit-tested without spawning a
// subprocess or parsing stdout.
package main

import (
	"database/sql"
	"fmt"
	"os"
	"strconv"

	_ "modernc.org/sqlite" // blank import: registers the "sqlite" driver, same as Lesson 16
)

func printUsage() {
	fmt.Println(`Usage:
  tasktracker add <title> [--priority low|medium|high]
  tasktracker list [--status pending|done]
  tasktracker done <id>
  tasktracker delete <id>
  tasktracker stats`)
}

func main() {
	// os.Args[0] is the program name -- everything the user actually typed starts at index 1,
	// mirroring how every other language course in this repository separates argv[0].
	if len(os.Args) < 2 {
		printUsage()
		return
	}

	db, err := sql.Open("sqlite", "tasks.db")
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error opening database:", err)
		os.Exit(1)
	}
	defer db.Close()

	repo := NewRepository(db)
	if err := repo.Init(); err != nil {
		fmt.Fprintln(os.Stderr, "Error initializing database:", err)
		os.Exit(1)
	}

	command := os.Args[1]
	args := os.Args[2:]

	var cmdErr error
	switch command {
	case "add":
		cmdErr = runAdd(repo, args)
	case "list":
		cmdErr = runList(repo, args)
	case "done":
		cmdErr = runDone(repo, args)
	case "delete":
		cmdErr = runDelete(repo, args)
	case "stats":
		cmdErr = runStats(repo)
	default:
		printUsage()
		return
	}

	if cmdErr != nil {
		fmt.Fprintln(os.Stderr, "Error:", cmdErr)
		os.Exit(1)
	}
}

// findFlagValue does a minimal hand-rolled scan for "--name value" pairs -- deliberately not
// using the flag package, since flag.Parse() expects flags before positional args and this
// CLI's shape (command, then positional arg, then optional flags) doesn't fit that cleanly.
func findFlagValue(args []string, name string) (string, bool) {
	for i, a := range args {
		if a == name && i+1 < len(args) {
			return args[i+1], true
		}
	}
	return "", false
}

func runAdd(repo *Repository, args []string) error {
	if len(args) == 0 {
		return fmt.Errorf("add requires a title, e.g. tasktracker add \"Write report\"")
	}
	title := args[0]

	priority := PriorityMedium // default, matching the mini-project's C# counterpart
	if raw, ok := findFlagValue(args, "--priority"); ok {
		parsed, err := ParsePriority(raw)
		if err != nil {
			return err
		}
		priority = parsed
	}

	task, err := repo.Add(title, priority)
	if err != nil {
		return err
	}
	fmt.Printf("Added task #%d: %s (priority=%s)\n", task.ID, task.Title, task.Priority)
	return nil
}

func runList(repo *Repository, args []string) error {
	var statusFilter *Status
	if raw, ok := findFlagValue(args, "--status"); ok {
		parsed, err := ParseStatus(raw)
		if err != nil {
			return err
		}
		statusFilter = &parsed
	}

	tasks, err := repo.List(statusFilter)
	if err != nil {
		return err
	}
	for _, t := range tasks {
		mark := " "
		if t.Status == StatusDone {
			mark = "x"
		}
		fmt.Printf("[%s] #%-3d %-30s priority=%-6s created=%s\n", mark, t.ID, t.Title, t.Priority, t.CreatedAt)
	}
	return nil
}

func parseID(args []string, command string) (int64, error) {
	if len(args) == 0 {
		return 0, fmt.Errorf("%s requires an id, e.g. tasktracker %s 1", command, command)
	}
	id, err := strconv.ParseInt(args[0], 10, 64)
	if err != nil {
		return 0, fmt.Errorf("invalid id %q: must be a whole number", args[0])
	}
	return id, nil
}

func runDone(repo *Repository, args []string) error {
	id, err := parseID(args, "done")
	if err != nil {
		return err
	}
	if err := repo.MarkDone(id); err != nil {
		return err
	}
	fmt.Printf("Marked task #%d as done.\n", id)
	return nil
}

func runDelete(repo *Repository, args []string) error {
	id, err := parseID(args, "delete")
	if err != nil {
		return err
	}
	if err := repo.Delete(id); err != nil {
		return err
	}
	fmt.Printf("Deleted task #%d.\n", id)
	return nil
}

func runStats(repo *Repository) error {
	stats, err := repo.Stats()
	if err != nil {
		return err
	}
	fmt.Printf("Pending: %d  Done: %d  Total: %d\n", stats.Pending, stats.Done, stats.Total)
	return nil
}
