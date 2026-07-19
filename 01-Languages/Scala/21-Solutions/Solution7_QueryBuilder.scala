// Solution 7 -- parameterized query builder against an in-memory SQLite database (Lesson 16)

import java.sql.{Connection, DriverManager, PreparedStatement}

def insertProduct(conn: Connection, name: String, price: Double): Unit =
  val ps: PreparedStatement = conn.prepareStatement("INSERT INTO products (name, price) VALUES (?, ?)")
  try
    ps.setString(1, name)
    ps.setDouble(2, price)
    ps.executeUpdate()
  finally ps.close()

def findByName(conn: Connection, name: String): Option[(Int, String, Double)] =
  val ps = conn.prepareStatement("SELECT id, name, price FROM products WHERE name = ?")
  try
    ps.setString(1, name) // bound as data, never concatenated -- same safety as Lesson 16
    val rs = ps.executeQuery()
    try
      if rs.next() then Some((rs.getInt("id"), rs.getString("name"), rs.getDouble("price")))
      else None
    finally rs.close()
  finally ps.close()

@main def solution7QueryBuilder(): Unit =
  Class.forName("org.sqlite.JDBC")
  val conn = DriverManager.getConnection("jdbc:sqlite::memory:") // in-memory, no file left behind
  try
    val stmt = conn.createStatement()
    stmt.execute("CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT NOT NULL, price REAL NOT NULL)")
    stmt.close()

    insertProduct(conn, "Keyboard", 49.99)
    insertProduct(conn, "Mouse", 19.99)
    println("inserted 2 products")

    findByName(conn, "Mouse") match
      case Some((id, name, price)) => println(s"found: id=$id name=$name price=$price")
      case None                    => println("not found")

    findByName(conn, "Monitor") match
      case Some(_) => println("unexpectedly found Monitor")
      case None    => println("Monitor correctly not found")
  finally conn.close()
