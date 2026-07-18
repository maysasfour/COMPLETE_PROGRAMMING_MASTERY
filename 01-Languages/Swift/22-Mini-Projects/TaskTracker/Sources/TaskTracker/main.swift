// main.swift -- hand-rolled `CommandLine.arguments` parsing, matching this repository's
// other language courses' mini-projects (no third-party CLI-argument-parsing package),
// since Swift Package Manager's registry isn't assumed reachable in this environment and
// the parsing needed here is simple enough not to justify a dependency anyway.

import Foundation
import TaskTrackerCore

func printUsage() {
    print("""
    Task Tracker -- a tiny CLI backed by SQLite (Lesson 16's raw C API approach)

    Usage:
      tasktracker add <title> [--priority low|medium|high]
      tasktracker list
      tasktracker done <id>
      tasktracker delete <id>
      tasktracker stats
    """)
}

let dbPath = ProcessInfo.processInfo.environment["TASKTRACKER_DB"] ?? "tasks.db"
let repository = TaskRepository(path: dbPath)

let arguments = Array(CommandLine.arguments.dropFirst())

guard let command = arguments.first else {
    printUsage()
    exit(1)
}

func priorityIcon(_ priority: Priority) -> String {
    switch priority {
    case .high: return "!!!"
    case .medium: return "!! "
    case .low: return "!  "
    }
}

switch command {
case "add":
    let rest = Array(arguments.dropFirst())
    guard !rest.isEmpty else {
        print("Error: 'add' requires a title.")
        printUsage()
        exit(1)
    }
    var priority = Priority.medium
    var titleParts: [String] = []
    var i = 0
    while i < rest.count {
        if rest[i] == "--priority", i + 1 < rest.count {
            guard let parsed = Priority(rawValue: rest[i + 1]) else {
                print("Error: --priority must be one of \(Priority.allCases.map(\.rawValue))")
                exit(1)
            }
            priority = parsed
            i += 2
        } else {
            titleParts.append(rest[i])
            i += 1
        }
    }
    let title = titleParts.joined(separator: " ")
    let task = repository.addTask(title: title, priority: priority)
    print("Added task #\(task.id): \(task.title) [\(task.priority.rawValue)]")

case "list":
    let tasks = repository.allTasks()
    if tasks.isEmpty {
        print("No tasks yet.")
    } else {
        for task in tasks {
            let status = task.done ? "[x]" : "[ ]"
            print("\(status) #\(task.id) \(priorityIcon(task.priority)) \(task.title)")
        }
    }

case "done":
    guard let idString = arguments.dropFirst().first, let id = Int(idString) else {
        print("Error: 'done' requires a numeric task id.")
        exit(1)
    }
    do {
        try repository.markDone(id: id)
        print("Marked task #\(id) done.")
    } catch let error as TaskTrackerError {
        print("Error: \(error)")
        exit(1)
    }

case "delete":
    guard let idString = arguments.dropFirst().first, let id = Int(idString) else {
        print("Error: 'delete' requires a numeric task id.")
        exit(1)
    }
    do {
        try repository.delete(id: id)
        print("Deleted task #\(id).")
    } catch let error as TaskTrackerError {
        print("Error: \(error)")
        exit(1)
    }

case "stats":
    let stats = repository.stats()
    print("Total: \(stats.total)  Done: \(stats.done)  Pending: \(stats.pending)")

default:
    print("Unknown command: \(command)")
    printUsage()
    exit(1)
}
