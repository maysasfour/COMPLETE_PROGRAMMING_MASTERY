// TaskItem.hpp - the domain model: a task record plus the enums that replace
// free-text "priority"/"status" strings a real project would otherwise scatter
// typo-prone string literals for (Lesson 05's spirit, applied to a real model).
#pragma once
#include <string>
#include <ostream>

enum class Priority { Low, Medium, High };
enum class Status { Pending, Done };

// A small, free-standing conversion instead of overloading operator<< directly on
// the enum -- keeps the enum itself a plain, dependency-free type while still giving
// every caller (CLI output, tests) one authoritative string form to agree on.
inline std::string toString(Priority p) {
    switch (p) {
        case Priority::Low:    return "Low";
        case Priority::Medium: return "Medium";
        case Priority::High:   return "High";
    }
    return "Unknown"; // unreachable for a valid enum value, but keeps the function total
}

inline std::string toString(Status s) {
    return s == Status::Done ? "Done" : "Pending";
}

// Parsing is the inverse direction: CLI argv text -> a validated enum value, throwing
// rather than silently defaulting on garbage input (e.g. "--priority extreme").
inline Priority parsePriority(const std::string& text) {
    if (text == "low")    return Priority::Low;
    if (text == "medium") return Priority::Medium;
    if (text == "high")   return Priority::High;
    throw std::invalid_argument("Unknown priority: '" + text + "' (expected low|medium|high)");
}

inline Status parseStatus(const std::string& text) {
    if (text == "pending") return Status::Pending;
    if (text == "done")    return Status::Done;
    throw std::invalid_argument("Unknown status: '" + text + "' (expected pending|done)");
}

// Plain aggregate, not a class with getters/setters -- every field is meant to be
// read directly by the CLI layer, and TaskRepository is the only code that mutates
// rows (via SQL), so encapsulation would add ceremony without preventing any real bug here.
struct TaskItem {
    int id = 0;
    std::string title;
    Priority priority = Priority::Medium;
    Status status = Status::Pending;
    std::string createdAt; // stored as SQLite's own TEXT timestamp -- see TaskRepository
};

struct TaskStats {
    int pending = 0;
    int done = 0;
    int total() const { return pending + done; }
};
