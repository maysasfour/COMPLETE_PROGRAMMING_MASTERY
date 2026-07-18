//! task_tracker - a persistent CLI task tracker backed by SQLite.
//!
//! Exposed as a library (not just a binary) specifically so `tests/`
//! integration tests can exercise the real public API the way an external
//! consumer would, per Lesson 18's unit-vs-integration-test distinction.

pub mod db;
pub mod models;
