# 02 — Integration Testing

[Back to module overview](../README.md) | [Previous: Unit Testing](../01-Unit-Testing/README.md)

## Beginner: Why This Bug Could Only Be Caught With Real I/O

An integration test verifies that multiple real components work together correctly — here, `FileNoteRepository` and the **actual file system**, using JUnit 5's `@TempDir` to get a real, temporary directory on real disk. This lesson demonstrates a real bug that a mocked-out "unit test" of the file system would never have caught, because the bug only manifests from real I/O timing.

## The Bug: A Real, Verified File I/O Failure

```java
public void save(Path file, String content) throws IOException {
    FileWriter writer = new FileWriter(file.toFile());
    writer.write(content);
    // BUG: writer is never flushed or closed!
}
```

Verified live, running a real integration test against a real temporary file:

```
FileNoteRepositoryIntegrationTest.savedNoteCanBeLoadedBackWithTheSameContent:24
  content read back from a REAL file should match what was saved ==> expected: <Buy milk> but was: <>
Tests run: 1, Failures: 1, Errors: 0, Skipped: 0
```

The saved content was completely lost — `load()` read back an **empty string**, because `FileWriter`'s internal buffer was never flushed to the actual file before `Files.readString()` tried to read it. A bonus, equally real finding from the same test run: because the `FileWriter` was also never *closed*, Windows refused to let JUnit clean up the temporary directory afterward:

```
java.nio.file.FileSystemException: ...\note.txt: The process cannot access the file because it is being used by another process
```

Neither of these failures would ever appear in a unit test that mocked the file system — a mock would simply record that `write()` was called and report success, with no way to notice that the *actual bytes* never reached disk. This is exactly why integration tests exist: some bugs only exist in the real interaction between components.

## The Fix, Verified Green

```java
public void save(Path file, String content) throws IOException {
    try (FileWriter writer = new FileWriter(file.toFile())) {
        writer.write(content); // try-with-resources guarantees flush+close
    }
}
```

Re-running the identical integration test after the fix:

```
Tests run: 1, Failures: 0, Errors: 0
BUILD SUCCESS
```

The content is now correctly read back, and the temporary directory cleanup (which requires the file handle to actually be closed) also succeeded silently, with no `FileSystemException`.

## Detailed Example

See [FileNoteRepository.java](src/main/java/com/example/integrationtesting/FileNoteRepository.java) (now the fixed version) and [FileNoteRepositoryIntegrationTest.java](src/test/java/com/example/integrationtesting/FileNoteRepositoryIntegrationTest.java) — the actual test that caught this real bug.

## Run It

```bash
cd 15-Testing-and-Debugging/02-Integration-Testing
mvn test
```

To see the original failure for yourself, temporarily remove the `try`-with-resources (back to a bare `FileWriter writer = new FileWriter(...)` with no `close()`/`flush()`) and rerun `mvn test`.

## Expected Output

`Tests run: 1, Failures: 0, Errors: 0` and `BUILD SUCCESS` against the current (fixed) code.

## Common Mistakes

- Not using try-with-resources (or an explicit `finally`-block close) for any `Closeable` resource — verified live to cause both a real data-loss bug (empty file content) and a real resource-leak bug (a file the OS refuses to let go of).
- Testing file/database/network interactions exclusively with mocks — verified live that a mock would never have caught this bug, because it only manifests from the real timing of when bytes actually reach the underlying file.
- Not using a real temporary directory (`@TempDir`) for file-based integration tests — writing to a fixed, shared path risks test pollution and flaky failures across test runs.

## Best Practices

- Always use try-with-resources for any `Closeable`/`AutoCloseable` resource (file handles, streams, connections) — it's not just style, it's what guarantees data is actually flushed and the resource is actually released.
- Use integration tests specifically for the boundaries where your code meets a real external system (file system, database, network) — this is exactly where mocked unit tests provide a false sense of safety.
- Use a real, isolated, disposable resource (like JUnit 5's `@TempDir`) for integration tests so they're both realistic and don't leave test pollution behind.

## Real-World Usage

Unflushed/unclosed file or network handles are a common, real category of production bug — "the code looks right and the mocked test passes, but the real system loses data" is precisely the gap integration tests are designed to close. This lesson's bug is a faithful, small-scale reproduction of that exact category of real-world incident.

## Summary

- A real bug — an unflushed, unclosed `FileWriter` — was caught by a real integration test against a real temporary file, verified by an actual failing assertion (`expected: <Buy milk> but was: <>`) and a real Windows file-lock error during cleanup.
- Using try-with-resources fixed both issues at once, verified by a rerun of the identical test passing cleanly.
- This bug specifically could not have been caught by a unit test that mocked the file system, since it depends on real I/O buffering behavior.

## Key Terms

- **Integration test** — a test that verifies multiple real components (including real external systems like a file system or database) work correctly together.
- **Try-with-resources** — Java syntax that guarantees a resource's `close()` method is called automatically, even if an exception occurs.
- **Resource leak** — a bug where a resource (file handle, connection, memory) is never properly released, potentially exhausting a limited pool of such resources.

## Interview Questions

1. **Why couldn't a unit test with a mocked file system have caught this lesson's bug?**
   A mock only simulates the *interface* of a dependency — it would record that `write(content)` was called and report success, with no actual bytes ever written anywhere, and critically, no way to reveal that a real `FileWriter`'s internal buffer hadn't yet reached the actual file. The bug in this lesson depended entirely on the real, observable behavior of an actual file system under real I/O buffering — verified by an integration test using a genuine temporary directory (`@TempDir`), which caught the content loss (`expected: <Buy milk> but was: <>`) that a mock-based test structurally could not have detected.

2. **Why does forgetting to close a `FileWriter` cause two distinct real problems, and how did this lesson observe both?**
   Not closing a `FileWriter` means its internal buffer is never flushed (data loss — the file may appear empty or truncated) and the underlying OS file handle is never released (a resource leak — on Windows, this can make the file inaccessible to other processes, including cleanup code). This lesson observed both directly in a single test run: the failing assertion (`expected: <Buy milk> but was: <>`) demonstrated the data-loss half, and the `FileSystemException: The process cannot access the file because it is being used by another process` during JUnit's `@TempDir` cleanup demonstrated the resource-leak half — both disappeared after switching to try-with-resources.

## Recommended Next Lesson

[03 — End-to-End Testing](../03-End-to-End-Testing/README.md)
