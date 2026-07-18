<?php

declare(strict_types=1);

require_once __DIR__ . '/TaskItem.php';
require_once __DIR__ . '/TaskNotFoundException.php';

/**
 * All persistence for the CLI lives behind this one class, so cli.php never
 * touches PDO directly and the PHPUnit suite can exercise the exact same
 * CRUD logic against a fresh :memory: database per test -- the same split
 * this course's Lesson 16 (Database Access) and Lesson 18 (Testing)
 * demonstrate separately, combined here into one real application.
 */
final class TaskRepository
{
    public function __construct(private readonly PDO $pdo)
    {
        // Set explicitly rather than relying on the default -- PDO's own
        // default error mode is ERRMODE_SILENT, which would make a failed
        // query return false instead of throwing, exactly the mistake
        // Lesson 16 warns against.
        $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $this->createSchema();
    }

    private function createSchema(): void
    {
        $this->pdo->exec(
            'CREATE TABLE IF NOT EXISTS tasks (
                id         INTEGER PRIMARY KEY AUTOINCREMENT,
                title      TEXT NOT NULL,
                priority   TEXT NOT NULL,
                status     TEXT NOT NULL,
                created_at TEXT NOT NULL
            )',
        );
    }

    public function add(string $title, Priority $priority = Priority::Medium): TaskItem
    {
        $trimmed = trim($title);
        if ($trimmed === '') {
            // Caught at the repository boundary rather than left to the
            // database (SQLite's NOT NULL would happily accept an empty
            // string -- it isn't NULL) or to whatever calls add() next.
            throw new InvalidArgumentException('Task title must not be empty.');
        }

        $createdAt = (new DateTimeImmutable())->format('Y-m-d');

        $stmt = $this->pdo->prepare(
            'INSERT INTO tasks (title, priority, status, created_at)
             VALUES (:title, :priority, :status, :created_at)',
        );
        $stmt->execute([
            'title' => $trimmed,
            'priority' => $priority->value,
            'status' => Status::Pending->value,
            'created_at' => $createdAt,
        ]);

        $id = (int) $this->pdo->lastInsertId();

        return new TaskItem($id, $trimmed, $priority, Status::Pending, $createdAt);
    }

    /**
     * @return TaskItem[]
     */
    public function all(?Status $status = null): array
    {
        if ($status === null) {
            $stmt = $this->pdo->query('SELECT * FROM tasks ORDER BY id');
        } else {
            $stmt = $this->pdo->prepare('SELECT * FROM tasks WHERE status = :status ORDER BY id');
            $stmt->execute(['status' => $status->value]);
        }

        return array_map($this->hydrate(...), $stmt->fetchAll(PDO::FETCH_ASSOC));
    }

    public function find(int $id): TaskItem
    {
        $stmt = $this->pdo->prepare('SELECT * FROM tasks WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row === false) {
            throw new TaskNotFoundException($id);
        }

        return $this->hydrate($row);
    }

    public function markDone(int $id): TaskItem
    {
        $stmt = $this->pdo->prepare('UPDATE tasks SET status = :status WHERE id = :id');
        $stmt->execute(['status' => Status::Done->value, 'id' => $id]);

        // rowCount() == 0 means no row matched WHERE id = :id -- a single
        // UPDATE-then-check avoids a separate SELECT-then-UPDATE round trip
        // just to learn whether the id existed.
        if ($stmt->rowCount() === 0) {
            throw new TaskNotFoundException($id);
        }

        return $this->find($id);
    }

    public function delete(int $id): void
    {
        $stmt = $this->pdo->prepare('DELETE FROM tasks WHERE id = :id');
        $stmt->execute(['id' => $id]);

        if ($stmt->rowCount() === 0) {
            throw new TaskNotFoundException($id);
        }
    }

    public function stats(): TaskStats
    {
        $pending = (int) $this->pdo
            ->query("SELECT COUNT(*) FROM tasks WHERE status = 'pending'")
            ->fetchColumn();
        $done = (int) $this->pdo
            ->query("SELECT COUNT(*) FROM tasks WHERE status = 'done'")
            ->fetchColumn();

        return new TaskStats($pending, $done);
    }

    /**
     * @param array<string, mixed> $row
     */
    private function hydrate(array $row): TaskItem
    {
        return new TaskItem(
            (int) $row['id'],
            (string) $row['title'],
            Priority::from((string) $row['priority']),
            Status::from((string) $row['status']),
            (string) $row['created_at'],
        );
    }
}
