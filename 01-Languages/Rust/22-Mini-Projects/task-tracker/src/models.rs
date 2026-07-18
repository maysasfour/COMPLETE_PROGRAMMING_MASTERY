//! models.rs - the Task/Priority domain types and this crate's error type.
//!
//! Kept separate from db.rs so the *shape* of a task and the *rules* around
//! it (what a valid Priority string is, what can go wrong) are visible
//! without reading any SQL at all -- the same separation of concerns as the
//! Python mini-project's models.py/db.py split.

use std::fmt;
use std::str::FromStr;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Priority {
    Low,
    Medium,
    High,
}

impl Priority {
    // A plain fn rather than relying solely on Display keeps a stable,
    // lowercase string available for both SQL storage and CLI parsing,
    // decoupled from whatever Display chooses to render for humans.
    pub fn as_str(&self) -> &'static str {
        match self {
            Priority::Low => "low",
            Priority::Medium => "medium",
            Priority::High => "high",
        }
    }
}

impl fmt::Display for Priority {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.as_str())
    }
}

#[derive(Debug)]
pub struct InvalidPriorityError(pub String);

impl fmt::Display for InvalidPriorityError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "invalid priority '{}' (expected low, medium, or high)",
            self.0
        )
    }
}

impl std::error::Error for InvalidPriorityError {}

impl FromStr for Priority {
    type Err = InvalidPriorityError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s.to_lowercase().as_str() {
            "low" => Ok(Priority::Low),
            "medium" => Ok(Priority::Medium),
            "high" => Ok(Priority::High),
            other => Err(InvalidPriorityError(other.to_string())),
        }
    }
}

#[derive(Debug, Clone)]
pub struct Task {
    pub id: i64,
    pub title: String,
    pub priority: Priority,
    pub done: bool,
    pub created_at: String,
}

#[derive(Debug)]
pub struct TaskStats {
    pub pending: i64,
    pub done: i64,
    pub total: i64,
}

// One error type for everything the repository layer can fail with, so
// callers (the CLI, the tests) match on a single TaskError rather than
// juggling rusqlite::Error and InvalidPriorityError separately at every
// call site -- the same "wrap the lower-level errors" idiom Lesson 09
// covers, with two `From` impls below doing the wrapping automatically so
// `?` works uniformly through db.rs.
#[derive(Debug)]
pub enum TaskError {
    NotFound(i64),
    EmptyTitle,
    InvalidPriority(InvalidPriorityError),
    Database(rusqlite::Error),
}

impl fmt::Display for TaskError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            TaskError::NotFound(id) => write!(f, "no task found with id {id}"),
            TaskError::EmptyTitle => write!(f, "task title must not be empty"),
            TaskError::InvalidPriority(e) => write!(f, "{e}"),
            TaskError::Database(e) => write!(f, "database error: {e}"),
        }
    }
}

impl std::error::Error for TaskError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            TaskError::InvalidPriority(e) => Some(e),
            TaskError::Database(e) => Some(e),
            TaskError::NotFound(_) | TaskError::EmptyTitle => None,
        }
    }
}

impl From<rusqlite::Error> for TaskError {
    fn from(e: rusqlite::Error) -> Self {
        TaskError::Database(e)
    }
}

impl From<InvalidPriorityError> for TaskError {
    fn from(e: InvalidPriorityError) -> Self {
        TaskError::InvalidPriority(e)
    }
}
