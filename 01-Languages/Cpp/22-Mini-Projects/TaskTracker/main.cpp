// main.cpp - the CLI entry point: hand-rolled argv parsing (C++ has no built-in CLI
// argument-parsing library, an honest gap in the same spirit as Lessons 10/16/17's
// "no built-in JSON/database/HTTP client" observations), dispatching to a thin
// TaskRepository call per command. Deliberately kept free of any SQL/business logic
// itself, so TaskRepository stays independently testable (see tests/test_TaskRepository.cpp).
#include <iostream>
#include <iomanip>
#include <vector>
#include <string>
#include <sstream>
#include "TaskRepository.hpp"
#include "TaskNotFoundException.hpp"

void printUsage() {
    std::cout <<
        "Usage:\n"
        "  app add <title> [--priority low|medium|high]\n"
        "  app list [--status pending|done]\n"
        "  app done <id>\n"
        "  app delete <id>\n"
        "  app stats\n";
}

void printTask(const TaskItem& t) {
    std::cout << (t.status == Status::Done ? "[x] " : "[ ] ")
               << "#" << t.id << "  "
               << std::left << std::setw(28) << t.title
               << "priority=" << std::setw(7) << toString(t.priority)
               << "created=" << t.createdAt << std::endl;
}

int main(int argc, char* argv[]) {
    std::vector<std::string> args(argv + 1, argv + argc);
    if (args.empty()) {
        printUsage();
        return 0;
    }

    TaskRepository repo("tasks.db");
    const std::string& command = args[0];

    try {
        if (command == "add") {
            if (args.size() < 2) { std::cout << "Error: 'add' requires a title.\n"; return 1; }
            std::string title = args[1];
            Priority priority = Priority::Medium;
            for (size_t i = 2; i + 1 < args.size(); ++i) {
                if (args[i] == "--priority") priority = parsePriority(args[i + 1]);
            }
            int id = repo.addTask(title, priority);
            std::cout << "Added task #" << id << ": " << title << " (priority=" << toString(priority) << ")\n";

        } else if (command == "list") {
            std::optional<Status> filter;
            for (size_t i = 1; i + 1 < args.size(); ++i) {
                if (args[i] == "--status") filter = parseStatus(args[i + 1]);
            }
            auto tasks = repo.listTasks(filter);
            if (tasks.empty()) {
                std::cout << "(no tasks)\n";
            } else {
                for (const auto& t : tasks) printTask(t);
            }

        } else if (command == "done") {
            if (args.size() < 2) { std::cout << "Error: 'done' requires an id.\n"; return 1; }
            int id = std::stoi(args[1]);
            repo.markDone(id);
            std::cout << "Marked task #" << id << " as done.\n";

        } else if (command == "delete") {
            if (args.size() < 2) { std::cout << "Error: 'delete' requires an id.\n"; return 1; }
            int id = std::stoi(args[1]);
            repo.deleteTask(id);
            std::cout << "Deleted task #" << id << ".\n";

        } else if (command == "stats") {
            TaskStats stats = repo.getStats();
            std::cout << "Pending: " << stats.pending << "  Done: " << stats.done
                       << "  Total: " << stats.total() << "\n";

        } else {
            printUsage();
        }
    } catch (const TaskNotFoundException& e) {
        // Caught separately from the generic branch below so this specific, expected
        // failure mode (a bad id typed by the user) reads as "Error: ..." rather than
        // an unhandled-crash-looking message -- exactly the polymorphic-catch pattern
        // from 20-Exercises/Exercise 04, applied to a real CLI instead of a toy demo.
        std::cout << "Error: " << e.what() << "\n";
        return 1;
    } catch (const std::exception& e) {
        std::cout << "Error: " << e.what() << "\n";
        return 1;
    }

    return 0;
}
