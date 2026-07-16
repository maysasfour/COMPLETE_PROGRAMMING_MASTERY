# 01 — SQL Injection

[Back to module overview](../README.md)

## Beginner: OWASP's Most Notorious Vulnerability, Demonstrated Live

SQL injection happens when user input is concatenated directly into a SQL string, letting an attacker's input change the query's actual logic. This lesson doesn't just describe the attack — it executes a **real, working exploit** against a real H2 database, bypassing authentication with no valid password at all, then shows the same attack correctly failing once the code is fixed.

## The Violation: A Real, Successful Authentication Bypass

```java
static boolean loginVulnerable(Connection conn, String username, String password) throws SQLException {
    String sql = "SELECT * FROM users WHERE username = '" + username + "' AND password = '" + password + "'";
    // ... executes this concatenated string directly
}
```

An attacker submits the username `' OR '1'='1' --` (the password field is irrelevant). Verified live, the actual SQL executed against the real database was:

```
Actual SQL executed: SELECT * FROM users WHERE username = '' OR '1'='1' --' AND password = 'anything, doesn't matter'
Login result: true  <- BUG: attacker is now logged in WITHOUT knowing any real password!
```

The injected `' OR '1'='1' --` turned the query's `WHERE` clause into something that matches *every row* (`'1'='1'` is always true), and `--` comments out the rest of the original query (the password check) entirely. The attacker is logged in without knowing any real user's password — a genuine, complete authentication bypass, verified against a real database returning a real matching row.

## The Fix: Parameterized SQL, the Identical Attack Correctly Fails

```java
static boolean loginSafe(Connection conn, String username, String password) throws SQLException {
    String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, username); // bound as DATA, never interpreted as SQL syntax
        stmt.setString(2, password);
        ...
    }
}
```

Verified live, submitting the **identical** injection payload:

```
Login result: false  <- correct: the injection payload is treated as LITERAL text, not SQL
```

`PreparedStatement` sends the query structure and the parameter values to the database *separately* — the database knows `username = ?` is a fixed comparison, and whatever value is bound to `?` (even something containing `' OR '1'='1' --`) is only ever compared as a literal string value, never re-parsed as SQL syntax. A genuinely valid login (a real user, a real password) was verified to still work correctly through the exact same fixed code.

## Detailed Example

See [pom.xml](pom.xml) and [Main.java](src/main/java/com/example/sqlinjection/Main.java) — the real exploit, the fix, and a confirming valid-login test, all against a real H2 database.

## Run It

```bash
cd 16-Security/01-SQL-Injection
mvn compile exec:java
```

## Expected Output

The real SQL string with the injected payload printed and executed, resulting in a successful (and wrong) login bypass; the identical attack against parameterized SQL correctly failing; a genuine, valid login still succeeding correctly through the fixed code.

## Common Mistakes

- Concatenating any user-controlled input directly into a SQL string — verified live to allow a complete authentication bypass with a well-known, simple payload.
- Assuming basic input "sanitization" (stripping quotes, escaping characters manually) is a sufficient defense — it's fragile and easy to get wrong; parameterized queries remove the entire class of vulnerability structurally.
- Believing SQL injection is only a risk for login forms — any query built by concatenating user input (search filters, sort parameters, report generators) is equally vulnerable.

## Best Practices

- Always use parameterized queries (`PreparedStatement` in Java, or your language/framework's equivalent) for any SQL built with user-controlled input — never string concatenation or formatting.
- Apply the principle of least privilege to database accounts used by application code, limiting the damage even if an injection vulnerability is somehow still present.
- Use static analysis / linting tools that flag string-concatenated SQL construction, catching this class of bug before it reaches production.

## Real-World Usage

SQL injection has been one of the most consistently exploited web application vulnerabilities for over two decades, responsible for numerous real, large-scale data breaches — it remains on the OWASP Top 10 precisely because the underlying mistake (string-concatenating untrusted input into a query) keeps recurring in real, production code, despite the fix (parameterized queries) being simple and well-established.

## Summary

- String-concatenated SQL was shown, live, to allow a complete authentication bypass using the classic `' OR '1'='1' --` payload, verified by an actual `true` login result requiring no real password.
- Parameterized SQL (`PreparedStatement`) was shown, live, to correctly reject the identical payload, while a genuinely valid login continued to work correctly.

## Key Terms

- **SQL injection** — a vulnerability where attacker-controlled input is interpreted as SQL syntax rather than data, due to unsafe string concatenation.
- **Parameterized query** — a query where values are bound separately from the query structure, so they can never be reinterpreted as SQL syntax.
- **Authentication bypass** — successfully gaining access without valid credentials, often via an injection vulnerability like the one demonstrated here.

## Interview Questions

1. **How does the `' OR '1'='1' --` payload actually work, and how was it verified to succeed?**
   When concatenated into `... WHERE username = '<payload>' AND password = '...'`, the payload closes the username string early, adds `OR '1'='1'` (a condition that's always true, making the `WHERE` clause match every row), and `--` comments out the rest of the original query, including the password check entirely. This was verified live: the actual SQL string executed against a real H2 database was printed, and the query genuinely returned a matching row (`Login result: true`), proving actual, complete authentication bypass rather than a hypothetical description.

2. **Why does a parameterized query prevent this attack structurally, rather than just filtering "bad" characters?**
   A parameterized query sends the query's structure (`WHERE username = ? AND password = ?`) to the database separately from the actual parameter values — the database never re-parses the bound values as SQL syntax at all, no matter what characters they contain. This was verified live: submitting the exact same `' OR '1'='1' --` payload as a bound parameter resulted in `Login result: false`, because the entire string was compared only as a literal value against the `username` column — there was no SQL syntax for it to "break out of," unlike the string-concatenated version.

## Recommended Next Lesson

[02 — Secure Password Storage](../02-Secure-Password-Storage/README.md)
