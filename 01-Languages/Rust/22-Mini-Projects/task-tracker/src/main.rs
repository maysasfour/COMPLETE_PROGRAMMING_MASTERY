//! main.rs - CLI entry point: parses argv and dispatches to TaskRepository.
//!
//! Kept intentionally thin (argv parsing + printing) so all real logic
//! lives in the testable library crate (db.rs/models.rs) -- the CLI layer
//! itself has no tests because there's nothing worth testing here beyond
//! what the library's own tests already cover.

use std::env;
use std::process::ExitCode;

use task_tracker::db::TaskRepository;
use task_tracker::models::{Priority, Task, TaskStats};

const USAGE: &str = "Usage:
  task-tracker add <title> [--priority low|medium|high]
  task-tracker list [--status pending|done]
  task-tracker done <id>
  task-tracker delete <id>
  task-tracker stats";

fn main() -> ExitCode {
    let args: Vec<String> = env::args().skip(1).collect();

    let repo = match TaskRepository::open("tasks.db") {
        Ok(repo) => repo,
        Err(e) => {
            eprintln!("Failed to open database: {e}");
            return ExitCode::FAILURE;
        }
    };

    match run(&repo, &args) {
        Ok(()) => ExitCode::SUCCESS,
        Err(message) => {
            println!("{message}");
            ExitCode::FAILURE
        }
    }
}

fn run(repo: &TaskRepository, args: &[String]) -> Result<(), String> {
    match args.first().map(String::as_str) {
        Some("add") => cmd_add(repo, args),
        Some("list") => cmd_list(repo, args),
        Some("done") => cmd_done(repo, args),
        Some("delete") => cmd_delete(repo, args),
        Some("stats") => cmd_stats(repo),
        _ => {
            println!("{USAGE}");
            Ok(())
        }
    }
}

fn cmd_add(repo: &TaskRepository, args: &[String]) -> Result<(), String> {
    let title = args.get(1).ok_or("Error: 'add' requires a title.")?;

    // Hand-rolled flag parsing (no CLI-framework dependency), matching this
    // repository's other language courses' mini-projects: scan for
    // "--priority" and take the following token as its value.
    let priority = match args.iter().position(|a| a == "--priority") {
        Some(i) => {
            let value = args
                .get(i + 1)
                .ok_or("Error: --priority requires a value (low, medium, or high).")?;
            value.parse::<Priority>().map_err(|e| format!("Error: {e}"))?
        }
        None => Priority::Medium,
    };

    let id = repo
        .add_task(title, priority)
        .map_err(|e| format!("Error: {e}"))?;
    println!("Added task #{id}: {title} (priority={priority})");
    Ok(())
}

fn cmd_list(repo: &TaskRepository, args: &[String]) -> Result<(), String> {
    let status_filter = match args.iter().position(|a| a == "--status") {
        Some(i) => match args.get(i + 1).map(String::as_str) {
            Some("pending") => Some(false),
            Some("done") => Some(true),
            Some(other) => return Err(format!("Error: unknown status '{other}' (expected pending or done).")),
            None => return Err("Error: --status requires a value (pending or done).".to_string()),
        },
        None => None,
    };

    let tasks = repo.list_tasks(status_filter).map_err(|e| format!("Error: {e}"))?;
    if tasks.is_empty() {
        println!("(no tasks)");
        return Ok(());
    }
    for task in &tasks {
        print_task(task);
    }
    Ok(())
}

fn print_task(task: &Task) {
    let mark = if task.done { "x" } else { " " };
    println!(
        "[{}] #{:<3} {:<28} priority={:<7} created={}",
        mark, task.id, task.title, task.priority, task.created_at
    );
}

fn cmd_done(repo: &TaskRepository, args: &[String]) -> Result<(), String> {
    let id = parse_id_arg(args)?;
    repo.mark_done(id).map_err(|e| format!("Error: {e}"))?;
    println!("Marked task #{id} as done.");
    Ok(())
}

fn cmd_delete(repo: &TaskRepository, args: &[String]) -> Result<(), String> {
    let id = parse_id_arg(args)?;
    repo.delete_task(id).map_err(|e| format!("Error: {e}"))?;
    println!("Deleted task #{id}.");
    Ok(())
}

fn parse_id_arg(args: &[String]) -> Result<i64, String> {
    let raw = args.get(1).ok_or("Error: this command requires a task id.")?;
    raw.parse::<i64>()
        .map_err(|_| format!("Error: '{raw}' is not a valid task id."))
}

fn cmd_stats(repo: &TaskRepository) -> Result<(), String> {
    let TaskStats { pending, done, total } = repo.stats().map_err(|e| format!("Error: {e}"))?;
    println!("Pending: {pending}  Done: {done}  Total: {total}");
    Ok(())
}
