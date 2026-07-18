// integration_test.rs -- black-box tests against the public task_tracker
// API only (this file is its own separate crate, per Lesson 18's
// tests/-directory convention), exercising a full add -> list -> done ->
// delete -> stats lifecycle the way an external consumer of the library
// actually would, rather than reaching into TaskRepository's private state.

use task_tracker::db::TaskRepository;
use task_tracker::models::Priority;

#[test]
fn full_task_lifecycle() {
    let repo = TaskRepository::open_in_memory().unwrap();

    let id1 = repo.add_task("Write project README", Priority::High).unwrap();
    let id2 = repo.add_task("Review pull requests", Priority::Medium).unwrap();
    let id3 = repo.add_task("Water the plants", Priority::Low).unwrap();
    assert_eq!((id1, id2, id3), (1, 2, 3));

    let all = repo.list_tasks(None).unwrap();
    assert_eq!(all.len(), 3);

    repo.mark_done(id1).unwrap();
    let pending = repo.list_tasks(Some(false)).unwrap();
    let done = repo.list_tasks(Some(true)).unwrap();
    assert_eq!(pending.len(), 2);
    assert_eq!(done.len(), 1);
    assert_eq!(done[0].id, id1);

    let stats_before_delete = repo.stats().unwrap();
    assert_eq!(stats_before_delete.total, 3);
    assert_eq!(stats_before_delete.done, 1);
    assert_eq!(stats_before_delete.pending, 2);

    repo.delete_task(id3).unwrap();
    let stats_after_delete = repo.stats().unwrap();
    assert_eq!(stats_after_delete.total, 2);

    let remaining = repo.list_tasks(None).unwrap();
    assert!(remaining.iter().all(|t| t.id != id3));
}

#[test]
fn operating_on_a_missing_id_returns_an_error_not_a_panic() {
    let repo = TaskRepository::open_in_memory().unwrap();
    repo.add_task("Only task", Priority::Low).unwrap();

    // The public API surfaces failure as Result::Err, never a panic --
    // black-box proof that a consumer with no access to TaskRepository's
    // internals still gets a recoverable error for an invalid id.
    assert!(repo.mark_done(999).is_err());
    assert!(repo.delete_task(999).is_err());
}

#[test]
fn each_in_memory_repository_is_independent() {
    // Two separately-opened in-memory repositories must not share state --
    // this is what makes it safe for every test in this suite (and in
    // db.rs's own unit tests) to run without interfering with each other.
    let repo_a = TaskRepository::open_in_memory().unwrap();
    let repo_b = TaskRepository::open_in_memory().unwrap();

    repo_a.add_task("Only in A", Priority::Low).unwrap();

    assert_eq!(repo_a.list_tasks(None).unwrap().len(), 1);
    assert_eq!(repo_b.list_tasks(None).unwrap().len(), 0);
}
