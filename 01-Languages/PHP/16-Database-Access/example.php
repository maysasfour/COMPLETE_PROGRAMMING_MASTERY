<?php
declare(strict_types=1);
// example.php - CRUD against SQLite via PDO (PHP Data Objects) -- a built-in, driver-agnostic
// database abstraction layer, requiring only the pdo_sqlite extension (verified enabled in
// Lesson 01). Parameterized queries prevent SQL injection, the same pattern as every other
// language course in this repository.

$pdo = new PDO("sqlite::memory:");
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); // throw on errors, not silent failure

$pdo->exec("
    CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        done INTEGER NOT NULL DEFAULT 0
    )
");

echo "--- CREATE (parameterized) ---\n";
$stmt = $pdo->prepare("INSERT INTO tasks (title) VALUES (:title)");
foreach (["Write lesson", "Test examples", "Ship it"] as $title) {
    $stmt->execute(["title" => $title]); // named placeholder, bound safely
}
echo "Inserted 3 rows.\n";

echo "\n--- READ (all) ---\n";
foreach ($pdo->query("SELECT id, title, done FROM tasks") as $row) {
    echo "  id={$row['id']}, title={$row['title']}, done={$row['done']}\n";
}

echo "\n--- UPDATE (parameterized) ---\n";
$pdo->prepare("UPDATE tasks SET done = 1 WHERE id = :id")->execute(["id" => 1]);
$doneStatus = $pdo->query("SELECT done FROM tasks WHERE id = 1")->fetchColumn();
echo "Row 1 done status after update: {$doneStatus}\n";

echo "\n--- DELETE (parameterized) ---\n";
$pdo->prepare("DELETE FROM tasks WHERE id = :id")->execute(["id" => 3]);
$count = (int) $pdo->query("SELECT COUNT(*) FROM tasks")->fetchColumn();
echo "Remaining row count: {$count}\n";

echo "\n--- Parameterized queries prevent SQL injection ---\n";
$maliciousTitle = "'; DROP TABLE tasks; --";
$pdo->prepare("INSERT INTO tasks (title) VALUES (:title)")->execute(["title" => $maliciousTitle]);
$stmt = $pdo->prepare("SELECT title FROM tasks WHERE title = :title");
$stmt->execute(["title" => $maliciousTitle]);
$retrieved = $stmt->fetchColumn();
echo "Malicious-looking string stored and retrieved as plain data: {$retrieved}\n";

$finalCount = (int) $pdo->query("SELECT COUNT(*) FROM tasks")->fetchColumn();
echo "Table still exists with all rows intact: {$finalCount}\n";
