# 16 — Security

[Back to repository root](../README.md)

## What Security Covers

This module covers core application security concerns from the OWASP Top 10 and beyond: SQL injection, secure password storage, input validation/output encoding (XSS), and HTTPS/security headers. Every lesson executes a **real, working exploit** against genuinely vulnerable code, then a real, verified fix — not a hypothetical description of a vulnerability class.

## Why Java as This Module's Reference Language

This repository's concept modules each pick one reference language rather than duplicating every lesson across every language in `01-Languages` (see [15-Testing-and-Debugging](../15-Testing-and-Debugging/README.md) for the same reasoning). Lesson 01 reuses the real H2 database pattern from [07-Databases](../07-Databases/README.md); Lessons 03 and 04 reuse the real embedded HTTP server pattern from [13-Software-Architecture](../13-Software-Architecture/README.md) and [14-APIs-and-Integrations](../14-APIs-and-Integrations/README.md); Lesson 02 uses the JDK's own `javax.crypto`; Lesson 04 uses a genuine, `keytool`-generated self-signed certificate with the JDK's own `HttpsServer` and `SSLContext` for a real TLS handshake — no external security libraries or mocked cryptography anywhere in this module.

## Why It Matters / Where It's Used

- **Every vulnerability in this module has caused real, large-scale, well-documented production breaches** — SQL injection and XSS remain permanent fixtures of the OWASP Top 10 precisely because these mistakes keep recurring in real, deployed code.
- **Security bugs are uniquely costly** compared to most other bug categories — a single SQL injection or XSS vulnerability can compromise an entire user base's data, not just a single feature's correctness.
- **Interviews**: "how does SQL injection work and how do you prevent it," "why is bcrypt/PBKDF2 better than MD5 for passwords," "what is XSS," and "what security headers should a web response include" are extremely common security interview questions, directly covered by this module's four lessons.

## Advantages of This Approach

- Every lesson executes a **real, working exploit**: a genuine SQL injection authentication bypass against a real H2 database (Lesson 01), a real measured ~86,000x brute-force cost difference between MD5 and PBKDF2 (Lesson 02), a real, literal `<script>` tag embedded in an actual HTTP response body (Lesson 03), and a real TLS 1.3 handshake with its actual negotiated cipher suite printed (Lesson 04).
- Nothing in this module is described only in the abstract — every "vulnerable" code path was actually exploited, and every "fixed" code path was verified to correctly resist the identical attack.
- This module directly extends and cross-references [07-Databases](../07-Databases/README.md) (Lesson 01's `PreparedStatement` usage), [04-Backend-Development](../04-Backend-Development/README.md) (Lesson 02's password hashing, extending that module's BCrypt usage), and [13-Software-Architecture](../13-Software-Architecture/README.md)/[14-APIs-and-Integrations](../14-APIs-and-Integrations/README.md) (Lessons 03-04's real HTTP servers).

## Disadvantages / Trade-offs

- This module's self-signed certificate (Lesson 04) and trust-all client `TrustManager` are explicitly demo-only conveniences to make a self-contained, runnable example — real production HTTPS requires a certificate from a trusted CA and proper certificate validation, never a trust-all client.
- Security is a vast field; this module covers four foundational, high-frequency vulnerability classes rather than the full OWASP Top 10 — CSRF, insecure deserialization, broken access control, and security misconfiguration (beyond headers) are not separately covered here.

## How to Run the Examples

Lesson 01 is a Maven project using H2 (reusing the toolchain from [07-Databases](../07-Databases/README.md)); Lessons 02-04 are single, self-contained Java files.

```bash
cd 16-Security/01-SQL-Injection
mvn compile exec:java
```

Lesson 04 additionally requires generating a throwaway self-signed certificate via `keytool` (included in every JDK) before running — see that lesson's own README for the exact command. Requires only a JDK (this module was built and verified against JDK 25) and, for Lesson 01, Apache Maven (verified against Maven 3.9.16). `target/`/`.class`/`.jks` files are not committed — recompile/regenerate locally after cloning.

## Common Beginner Mistakes

- **Concatenating user input directly into SQL** — verified live in Lesson 01 to allow a complete authentication bypass.
- **Using a fast, unsalted hash (MD5) for password storage** — verified live in Lesson 02 to leak identical passwords as identical hashes and to be extremely cheap to brute-force.
- **Embedding user input directly into HTML output** — verified live in Lesson 03 to let an attacker's input become real, executable script.
- **Treating HTTPS alone as a complete security posture** — verified live in Lesson 04 that missing security headers leave real, separate vulnerabilities unaddressed even over a genuinely encrypted connection.

## Best Practices

- Always use parameterized queries for any SQL built with user-controlled input.
- Use a dedicated, slow key-derivation function (PBKDF2, bcrypt, Argon2) with a per-password random salt for password storage.
- HTML-encode user-controlled data at the point it's rendered into HTML output.
- Use a real, CA-issued TLS certificate in production, and set `X-Content-Type-Options`, `X-Frame-Options`/CSP, and `Strict-Transport-Security` on every response.

## Interview Questions

1. How does the classic `' OR '1'='1' --` SQL injection payload work, and why does a parameterized query prevent it structurally?
2. Why is a fast hash function like MD5 a real liability for password storage specifically?
3. How does HTML encoding prevent XSS, and why isn't input validation alone sufficient?
4. What does HTTPS actually protect against, and what does it not protect against?
5. What real attack does `X-Frame-Options` (or a CSP frame-ancestors directive) defend against?

(Detailed, verified answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [SQL Injection](01-SQL-Injection/README.md) | A real, working authentication bypass exploit, and its parameterized-query fix |
| 02 | [Secure Password Storage](02-Secure-Password-Storage/README.md) | MD5 vs. PBKDF2, with real hash outputs and a real ~86,000x measured cost difference |
| 03 | [Input Validation and Output Encoding](03-Input-Validation-and-Output-Encoding/README.md) | A real, literal `<script>` tag in an HTTP response, and its HTML-encoded fix |
| 04 | [HTTPS and Security Headers](04-HTTPS-and-Security-Headers/README.md) | A real TLS 1.3 handshake with genuine keytool-generated certificate; real security headers |

## Suggested Path

Work through 01 → 04 in order — each lesson covers an independent, high-frequency vulnerability class. See also [07-Databases](../07-Databases/README.md) for the underlying JDBC/`PreparedStatement` mechanics behind Lesson 01, and [13-Software-Architecture](../13-Software-Architecture/README.md)/[14-APIs-and-Integrations](../14-APIs-and-Integrations/README.md) for the real embedded HTTP server pattern reused in Lessons 03-04.

**Previous module:** [15-Testing-and-Debugging](../15-Testing-and-Debugging/README.md)
