# 22 — Mini-Projects

[Back to course overview](../README.md) | [Previous: Solutions](../21-Solutions/README.md)

## [Task-Tracker](Task-Tracker/README.md)

A CLI task tracker (`add`/`list`/`done`/`remove`) that pulls together Perl core-language skills from across this course: `bless`-free struct-like hashrefs, `JSON::PP` file persistence, `eval`/`die` error handling, and a real `Test::More` test suite.

Two environment-driven design decisions, both verified live rather than assumed (see the project's own README for the full detail):

- **Persistence is file-based JSON, not SQLite** — [16-Database-Access](../16-Database-Access/README.md) confirmed `DBI`/`DBD::SQLite` are not installed in this Perl build.
- **Tests are run directly with `perl -I lib t/task_store.t`, not `prove`** — [18-Testing](../18-Testing/README.md) confirmed `prove` is broken in this environment (missing `TAP::Harness::Env`), while `Test::More` itself works fine.
