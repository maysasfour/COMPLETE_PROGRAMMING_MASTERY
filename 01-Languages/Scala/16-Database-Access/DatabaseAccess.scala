// 16 - Database Access
// Direct JDBC (java.sql) against SQLite via the sqlite-jdbc driver -- Scala has no
// database library of its own, so it reaches straight into Java's JDBC API, exactly
// as it does for file I/O (Lesson 10) and JSON (also Lesson 10).

import java.sql.{Connection, DriverManager, PreparedStatement, ResultSet, Statement}

@main def databaseAccessDemo(): Unit =
  Class.forName("org.sqlite.JDBC") // ensure the SQLite driver class is registered with DriverManager

  val dbPath = "demo.db"
  val conn: Connection = DriverManager.getConnection(s"jdbc:sqlite:$dbPath")
  try
    val stmt: Statement = conn.createStatement()
    stmt.execute("DROP TABLE IF EXISTS users")
    stmt.execute("CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT NOT NULL, email TEXT NOT NULL)")
    stmt.close()

    println("--- inserting rows via a PreparedStatement (safe parameter binding) ---")
    val insertSql = "INSERT INTO users (name, email) VALUES (?, ?)"
    val rows = List(("Ada Lovelace", "ada@example.com"), ("Alan Turing", "alan@example.com"))
    for (name, email) <- rows do
      val ps: PreparedStatement = conn.prepareStatement(insertSql)
      try
        ps.setString(1, name)
        ps.setString(2, email)
        ps.executeUpdate()
      finally ps.close()
    println(s"inserted ${rows.size} rows")

    println("\n--- querying all rows ---")
    val queryStmt = conn.createStatement()
    val rs: ResultSet = queryStmt.executeQuery("SELECT id, name, email FROM users ORDER BY id")
    try
      while rs.next() do
        println(s"  id=${rs.getInt("id")} name=${rs.getString("name")} email=${rs.getString("email")}")
    finally
      rs.close()
      queryStmt.close()

    println("\n--- SQL-injection safety: PreparedStatement binds values, never concatenates ---")
    val maliciousInput = "x'; DROP TABLE users; --"
    val safePs = conn.prepareStatement("SELECT COUNT(*) AS cnt FROM users WHERE name = ?")
    try
      safePs.setString(1, maliciousInput) // bound as a literal STRING VALUE, not executable SQL
      val safeRs = safePs.executeQuery()
      safeRs.next()
      println(s"query with malicious-looking input as a bound parameter: cnt=${safeRs.getInt("cnt")} (table intact, no injection)")
      safeRs.close()
    finally safePs.close()

    // Prove the table really is still intact and wasn't dropped by the injection attempt.
    val checkStmt = conn.createStatement()
    val checkRs = checkStmt.executeQuery("SELECT COUNT(*) AS cnt FROM users")
    checkRs.next()
    println(s"users table row count after attempted injection: ${checkRs.getInt("cnt")}")
    checkRs.close()
    checkStmt.close()

    println("\n--- UNSAFE comparison: what string concatenation WOULD do (demonstrated, not executed for real damage) ---")
    val unsafeQuery = s"SELECT COUNT(*) AS cnt FROM users WHERE name = '$maliciousInput'"
    println(s"a naively concatenated query would look like: $unsafeQuery")
    println("(this is exactly the shape of a SQL-injection vector -- PreparedStatement above avoids it entirely)")

  finally
    conn.close()
    java.nio.file.Files.deleteIfExists(java.nio.file.Paths.get(dbPath)) // clean up the demo database file
