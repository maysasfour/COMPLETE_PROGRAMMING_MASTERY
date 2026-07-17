# Security Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../16-Security/README.md)

## SQL Injection
```java
// VULNERABLE:
String sql = "SELECT * FROM users WHERE username = '" + username + "'";
// SAFE:
PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE username = ?");
stmt.setString(1, username);
```
`' OR '1'='1' --` achieved a complete, verified authentication bypass against the vulnerable version, correctly blocked by the parameterized version. See [16-Security/01](../../16-Security/01-SQL-Injection/README.md).

## Secure Password Storage
```java
PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 120_000, 256);
SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec);
```
Never use MD5/SHA-1 for passwords — verified live: MD5 let identical passwords produce identical hashes, and was ~86,000x cheaper to brute-force than PBKDF2. See [16-Security/02](../../16-Security/02-Secure-Password-Storage/README.md).

## XSS / Output Encoding
```java
String safe = input.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
```
A real `<script>` tag was verified present in an unescaped HTTP response body; HTML-encoding neutralized it into inert text. See [16-Security/03](../../16-Security/03-Input-Validation-and-Output-Encoding/README.md).

## HTTPS and Security Headers
```
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Content-Security-Policy: default-src 'self'
Strict-Transport-Security: max-age=63072000
```
HTTPS protects data in transit; it does NOT protect against XSS, clickjacking, or MIME-sniffing — those need the headers above. Verified live with a real TLS 1.3 handshake in [16-Security/04](../../16-Security/04-HTTPS-and-Security-Headers/README.md).

## OWASP Top 10 Quick Map
| Category | Covered in this repo |
|---|---|
| Injection | [16-Security/01](../../16-Security/01-SQL-Injection/README.md) |
| Broken Authentication | [14-APIs-and-Integrations/03](../../14-APIs-and-Integrations/03-Authentication/README.md) |
| Sensitive Data Exposure | [16-Security/02](../../16-Security/02-Secure-Password-Storage/README.md) |
| XSS | [16-Security/03](../../16-Security/03-Input-Validation-and-Output-Encoding/README.md) |
| Security Misconfiguration | [16-Security/04](../../16-Security/04-HTTPS-and-Security-Headers/README.md) |

See the [full Security module](../../16-Security/README.md) for verified, real exploits and fixes for everything above.
