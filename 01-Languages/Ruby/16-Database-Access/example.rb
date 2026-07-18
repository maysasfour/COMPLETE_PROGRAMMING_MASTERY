# Lesson 16 -- Database Access (sqlite3 gem)
require "sqlite3"

db_path = File.join(__dir__, "lesson16_temp.db")
File.delete(db_path) if File.exist?(db_path)

db = SQLite3::Database.new(db_path)
db.results_as_hash = true

db.execute(<<~SQL)
  CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL
  )
SQL

# CREATE
insert = db.prepare("INSERT INTO users (name, email) VALUES (?, ?)")
insert.execute("Ada Lovelace", "ada@example.com")
insert.execute("Grace Hopper", "grace@example.com")
insert.close
puts "inserted #{db.execute('SELECT COUNT(*) AS c FROM users').first['c']} rows"

# READ
db.execute("SELECT * FROM users ORDER BY id") do |row|
  puts "#{row['id']}: #{row['name']} <#{row['email']}>"
end

# UPDATE (parameterized)
db.execute("UPDATE users SET email = ? WHERE name = ?", ["ada@newmail.com", "Ada Lovelace"])
puts db.execute("SELECT email FROM users WHERE name = ?", ["Ada Lovelace"]).first["email"]

# DELETE (parameterized)
db.execute("DELETE FROM users WHERE name = ?", ["Grace Hopper"])
puts "remaining rows: #{db.execute('SELECT COUNT(*) AS c FROM users').first['c']}"

# --- SQL injection: the same demonstration as every other language course ---
# UNSAFE: building SQL via string interpolation lets attacker-controlled
# input change the query's STRUCTURE, not just its data.
malicious_name = "x' OR '1'='1"
unsafe_sql = "SELECT * FROM users WHERE name = '#{malicious_name}'"
puts "unsafe query text: #{unsafe_sql}"
unsafe_results = db.execute(unsafe_sql)
puts "UNSAFE query returned #{unsafe_results.length} row(s) -- the injected OR '1'='1' matched everything!"

# SAFE: a parameterized query treats the same malicious string as pure DATA,
# never as part of the SQL structure -- it matches nothing, correctly.
safe_results = db.execute("SELECT * FROM users WHERE name = ?", [malicious_name])
puts "SAFE parameterized query returned #{safe_results.length} row(s) -- injection defused"

db.close
File.delete(db_path)
puts "cleaned up temp db: #{!File.exist?(db_path)}"
