// example.dart - CRUD against SQLite via the `sqlite3` pub.dev package -- Dart has NO
// built-in database access at all, matching Swift and C++ (both covered earlier in this
// repository). This package bundles/loads the native SQLite library directly, requiring
// no separate system installation. Parameterized queries prevent SQL injection, the
// same pattern used throughout this repository's other language courses.

import 'package:sqlite3/sqlite3.dart';

void main() {
  final db = sqlite3.openInMemory();

  db.execute('''
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      done INTEGER NOT NULL DEFAULT 0
    )
  ''');

  print('--- CREATE (parameterized) ---');
  final insertStmt = db.prepare('INSERT INTO tasks (title) VALUES (?)');
  for (var title in ['Write lesson', 'Test examples', 'Ship it']) {
    insertStmt.execute([title]); // ? placeholder, bound safely -- no string concatenation
  }
  insertStmt.dispose();
  print('Inserted 3 rows.');

  print('\n--- READ (all) ---');
  final rows = db.select('SELECT id, title, done FROM tasks');
  for (var row in rows) {
    print('  id=${row['id']}, title=${row['title']}, done=${row['done']}');
  }

  print('\n--- UPDATE (parameterized) ---');
  db.execute('UPDATE tasks SET done = 1 WHERE id = ?', [1]);
  final doneStatus = db.select('SELECT done FROM tasks WHERE id = 1').first['done'];
  print('Row 1 done status after update: $doneStatus');

  print('\n--- DELETE (parameterized) ---');
  db.execute('DELETE FROM tasks WHERE id = ?', [3]);
  final count = db.select('SELECT COUNT(*) as cnt FROM tasks').first['cnt'];
  print('Remaining row count: $count');

  print('\n--- Parameterized queries prevent SQL injection ---');
  final maliciousTitle = "'; DROP TABLE tasks; --";
  db.execute('INSERT INTO tasks (title) VALUES (?)', [maliciousTitle]);
  final retrieved = db.select('SELECT title FROM tasks WHERE title = ?', [maliciousTitle]).first['title'];
  print('Malicious-looking string stored and retrieved as plain data: $retrieved');
  final finalCount = db.select('SELECT COUNT(*) as cnt FROM tasks').first['cnt'];
  print('Table still exists with all rows intact: $finalCount');

  db.dispose();
}
