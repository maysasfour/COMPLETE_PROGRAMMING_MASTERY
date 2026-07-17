// cli.ts - command-line entry point. Parses argv, drives TaskStore, formats output.

import { TaskStore, TaskNotFoundError } from "./db";
import { isPriority, type Priority, type Task } from "./models";

// Overridable so the test suite (and this file's own verified-output run) can point at a
// throwaway database instead of always touching the real tasks.db on disk.
const DB_PATH = process.env.TASK_TRACKER_DB ?? "tasks.db";

function formatTask(task: Task): string {
  const marker = task.done ? "[x]" : "[ ]";
  return `${marker} #${task.id} (${task.priority}) ${task.title}`;
}

function readFlag(args: string[], name: string): string | undefined {
  const index = args.indexOf(name);
  if (index === -1 || index === args.length - 1) return undefined;
  return args[index + 1];
}

// Narrows an optional raw flag value into `Priority | undefined` in one place, rather than
// repeating "is it undefined, and if not, is it actually valid" at every call site.
function parseOptionalPriority(raw: string | undefined): Priority | undefined {
  if (raw === undefined) return undefined;
  if (!isPriority(raw)) {
    throw new Error(`Invalid priority "${raw}" -- must be low, medium, or high`);
  }
  return raw;
}

function main(): void {
  const [command, ...rest] = process.argv.slice(2);
  const store = new TaskStore(DB_PATH);

  try {
    switch (command) {
      case "add": {
        const title = rest.find((arg) => !arg.startsWith("--"));
        if (!title) {
          console.log("Usage: cli add <title> [--priority low|medium|high]");
          return;
        }
        const priority = parseOptionalPriority(readFlag(rest, "--priority")) ?? "medium";
        const task = store.addTask(title, priority);
        console.log(`Added task ${formatTask(task)}`);
        break;
      }
      case "list": {
        const tasks = store.listTasks({
          priority: parseOptionalPriority(readFlag(rest, "--priority")),
          done: rest.includes("--done") ? true : rest.includes("--pending") ? false : undefined,
        });
        if (tasks.length === 0) {
          console.log("No tasks found.");
        } else {
          tasks.forEach((task) => console.log(formatTask(task)));
        }
        break;
      }
      case "done": {
        const id = Number(rest[0]);
        const task = store.completeTask(id);
        console.log(`Completed ${formatTask(task)}`);
        break;
      }
      case "delete": {
        const id = Number(rest[0]);
        const deleted = store.deleteTask(id);
        console.log(deleted ? `Deleted task #${id}` : `No task #${id} to delete`);
        break;
      }
      case "stats": {
        const s = store.stats();
        console.log(`Total: ${s.total}  Done: ${s.done}  Pending: ${s.pending}`);
        console.log(
          `By priority: low=${s.byPriority.low} medium=${s.byPriority.medium} high=${s.byPriority.high}`
        );
        break;
      }
      default:
        console.log("Usage: cli <add|list|done|delete|stats> [args]");
    }
  } catch (err) {
    if (err instanceof TaskNotFoundError) {
      console.log(`Error: ${err.message}`);
    } else if (err instanceof Error) {
      console.log(`Error: ${err.message}`);
    } else {
      throw err;
    }
  } finally {
    store.close();
  }
}

main();
