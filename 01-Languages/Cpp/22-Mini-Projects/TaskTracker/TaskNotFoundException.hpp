// TaskNotFoundException.hpp - a custom exception instead of throwing std::runtime_error
// for a domain-specific failure -- lets callers (CLI, tests) catch exactly this failure
// mode by type, matching Lesson 09/Exercise 04's "catch the specific thing you can
// actually handle differently" guidance, rather than a generic exception every failure
// in the whole program would also throw.
#pragma once
#include <exception>
#include <string>

class TaskNotFoundException : public std::exception {
    std::string message;
public:
    explicit TaskNotFoundException(int id)
        : message("No task found with id " + std::to_string(id)) {}
    const char* what() const noexcept override { return message.c_str(); }
};
