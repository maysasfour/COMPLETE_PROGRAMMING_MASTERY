#!/usr/bin/env node
// cli.js - command-line entry point for the task tracker.
//
// Parses process.argv by hand rather than pulling in a third-party CLI
// framework (commander, yargs) - this course's Node lessons deliberately
// use zero npm installs throughout (Lesson 16's node:sqlite, Lesson 17's
// built-in fetch), and a handful of positional args/flags doesn't need a
// dependency to parse.
//
// Run with:
//   node cli.js add "Write lesson" --priority high
//   node cli.js list
//   node cli.js list --status pending
//   node cli.js done 1
//   node cli.js delete 2
//   node cli.js summary

const { DatabaseSync } = require("node:sqlite");
const path = require("node:path");
const {
  TaskNotFoundError,
  initDb,
  addTask,
  listTasks,
  markDone,
  deleteTask,
  summary,
} = require("./db");

const DB_FILENAME = path.join(__dirname, "tasks.db");

// Extracts "--flag value" pairs out of the remaining argv, returning both
// the flags found and whatever positional args are left once flags (and
// their values) are removed - avoids a parsing dependency for two flags.
function parseFlags(args) {
  const flags = {};
  const positional = [];
  for (let i = 0; i < args.length; i++) {
    if (args[i].startsWith("--")) {
      const key = args[i].slice(2);
      flags[key] = args[i + 1];
      i++; // skip the value we just consumed
    } else {
      positional.push(args[i]);
    }
  }
  return { flags, positional };
}

function main(argv) {
  const [command, ...rest] = argv;
  const { flags, positional } = parseFlags(rest);

  const db = new DatabaseSync(DB_FILENAME);
  initDb(db);

  try {
    switch (command) {
      case "add": {
        const title = positional[0];
        const priority = flags.priority ?? "medium";
        const id = addTask(db, title, priority);
        console.log(`Added task #${id}: [${priority}] ${title}`);
        break;
      }

      case "list": {
        const tasks = listTasks(db, { status: flags.status ?? null });
        if (tasks.length === 0) {
          console.log("No tasks found.");
        } else {
          for (const task of tasks) console.log(task.toString());
        }
        break;
      }

      case "done": {
        const id = Number(positional[0]);
        markDone(db, id);
        console.log(`Marked task #${id} done`);
        break;
      }

      case "delete": {
        const id = Number(positional[0]);
        deleteTask(db, id);
        console.log(`Deleted task #${id}`);
        break;
      }

      case "summary": {
        const counts = summary(db);
        console.log(`Total: ${counts.total}  Pending: ${counts.pending}  Done: ${counts.done}`);
        break;
      }

      default:
        console.error(`Unknown command: ${command}`);
        console.error("Usage: node cli.js <add|list|done|delete|summary> [args]");
        db.close();
        return 1;
    }
  } catch (err) {
    if (err instanceof RangeError || err instanceof TaskNotFoundError) {
      console.error(`Error: ${err.message}`);
      db.close();
      return 1;
    }
    db.close();
    throw err; // an unexpected error is a real bug, not a user-input problem - don't swallow it
  }

  db.close();
  return 0;
}

if (require.main === module) {
  process.exitCode = main(process.argv.slice(2));
}

module.exports = { main, parseFlags };
