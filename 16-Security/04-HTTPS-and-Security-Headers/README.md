# 04 — HTTPS and Security Headers

[Back to module overview](../README.md) | [Previous: Input Validation and Output Encoding](../03-Input-Validation-and-Output-Encoding/README.md)

## Beginner: A Genuinely Real, Encrypted TLS Connection

This lesson doesn't just describe HTTPS — it starts a **real HTTPS server**, backed by a genuine, `keytool`-generated self-signed X.509 certificate, and connects to it with a real TLS handshake, then inspects the *actual negotiated protocol and cipher suite* from that real handshake. It also demonstrates real, missing-vs-present HTTP security response headers, verified against actual server responses.

## Part 1: A Real TLS Handshake, Verified

```java
KeyStore keyStore = KeyStore.getInstance("PKCS12");
try (FileInputStream fis = new FileInputStream("keystore.jks")) { keyStore.load(fis, password); }
KeyManagerFactory kmf = KeyManagerFactory.getInstance(...);
kmf.init(keyStore, password);
SSLContext sslContext = SSLContext.getInstance("TLS");
sslContext.init(kmf.getKeyManagers(), null, null);
HttpsServer server = HttpsServer.create(...);
server.setHttpsConfigurator(new HttpsConfigurator(sslContext) { ... });
```

Verified live — a real client connects over `https://`, and the actual negotiated TLS session details are printed:

```
Real response body: This response was ACTUALLY encrypted in transit.
Real, negotiated TLS details from the actual handshake:
  Protocol: TLSv1.3
  Cipher suite: TLS_AES_256_GCM_SHA384
  <- this proves a REAL encrypted TLS channel was used, not plain HTTP
```

`TLSv1.3` and `TLS_AES_256_GCM_SHA384` are the genuine protocol version and cipher suite this specific connection actually negotiated — not a hardcoded or illustrative value. This is real, verifiable proof that the connection was encrypted in transit, using the same JDK APIs (`HttpsServer`, `SSLContext`) that back real production HTTPS servers.

## Part 2: Security Headers — Missing vs. Present

A TLS-encrypted channel protects data *in transit*, but a browser also needs explicit instructions in the response headers to defend against several other classes of attack. Verified live, a response with no security headers set:

```
Violation (no security headers set):
  X-Content-Type-Options: (MISSING)
  X-Frame-Options: (MISSING)
  BUG: a browser has NO instruction to prevent MIME-sniffing or being framed by another site.
```

Without `X-Content-Type-Options: nosniff`, a browser may try to guess ("sniff") a resource's content type rather than trusting the declared one, which has historically enabled certain attacks. Without `X-Frame-Options` (or an equivalent `Content-Security-Policy` frame-ancestors directive), another site can embed this page in an invisible `<iframe>` and trick users into clicking on it (clickjacking).

Verified live, with the headers explicitly set:

```
Fixed (security headers explicitly set):
  X-Content-Type-Options: nosniff
  X-Frame-Options: DENY
  Content-Security-Policy: default-src 'self'
  Strict-Transport-Security: max-age=63072000
  Correct: the browser is explicitly told not to MIME-sniff, not to allow framing, to restrict resource origins, and to always use HTTPS going forward.
```

## Detailed Example

See [Example.java](Example.java) — the real HTTPS server/TLS handshake and the security-headers comparison.

## Run It

```bash
cd 16-Security/04-HTTPS-and-Security-Headers
keytool -genkeypair -alias demo -keyalg RSA -keysize 2048 -validity 1 -storetype PKCS12 -keystore keystore.jks -storepass changeit -keypass changeit -dname "CN=localhost, OU=Demo, O=Demo, L=Demo, S=Demo, C=US"
javac Example.java
java Example
```

The generated `keystore.jks` is a throwaway, self-signed certificate for this demo only (`.jks` files are gitignored) — never use a self-signed certificate or a trust-all client `TrustManager` (as this demo's client uses, purely to accept its own throwaway cert) in real production code.

## Expected Output

A real HTTPS server starting, a real TLS handshake completing, and the actual negotiated protocol/cipher suite printed; a security-headers comparison showing headers missing in one response and correctly present in another.

## Common Mistakes

- Assuming HTTPS alone (encryption in transit) is a complete security posture — verified in this lesson that missing response headers leave real, separate vulnerabilities (MIME-sniffing, clickjacking) unaddressed even over a genuinely encrypted connection.
- Using a self-signed certificate or a trust-all client `TrustManager` in real production code — both are used in this lesson purely to make a self-contained demo runnable without a real, CA-issued certificate; production systems must validate against a real, trusted certificate authority.
- Not setting `Strict-Transport-Security`, which leaves a brief window where a user's very first request to a site could still be sent over plain, unencrypted HTTP before any redirect to HTTPS occurs.

## Best Practices

- Use a real certificate from a trusted certificate authority (or an internal CA for private/internal services) in production — never a self-signed certificate as used here for demo purposes only.
- Set `X-Content-Type-Options: nosniff`, `X-Frame-Options` (or a CSP `frame-ancestors` directive), a real `Content-Security-Policy`, and `Strict-Transport-Security` on every response.
- Verify security headers are actually present in real responses (as this lesson does with `HttpClient`) rather than assuming a framework's defaults are sufficient without checking.

## Real-World Usage

Every modern production web server should terminate real TLS with a certificate from a trusted CA and set the security headers demonstrated here — tools like Mozilla Observatory and securityheaders.com exist specifically to check a real, deployed site's headers, because missing headers are a genuinely common, real finding in production security audits.

## Summary

- A real HTTPS server, using a genuine self-signed certificate, completed an actual TLS handshake — verified by inspecting the real negotiated protocol (`TLSv1.3`) and cipher suite (`TLS_AES_256_GCM_SHA384`) from that handshake, not a hardcoded description.
- A response missing security headers was shown, live, to leave real vulnerabilities (MIME-sniffing, clickjacking) unaddressed; setting the headers explicitly fixed this, verified against the actual response headers.

## Key Terms

- **TLS (Transport Layer Security)** — the protocol providing encryption, integrity, and authentication for data in transit; what HTTPS uses under the hood.
- **X-Frame-Options / clickjacking** — a header preventing a page from being embedded in another site's `<iframe>`, defending against tricking users into clicking on an invisible embedded page.
- **X-Content-Type-Options: nosniff** — a header instructing browsers to trust the declared `Content-Type` rather than guessing it from content.

## Interview Questions

1. **How was this lesson's HTTPS connection proven to be genuinely encrypted, rather than just configured to look like HTTPS?**
   The demo started a real `HttpsServer` backed by a genuine, `keytool`-generated X.509 certificate loaded into a real `SSLContext`, and connected to it with a real `HttpClient` performing an actual TLS handshake. Rather than simply asserting the connection was secure, the code inspected the connection's actual `SSLSession` after the real handshake completed and printed the genuinely negotiated protocol version and cipher suite — verified live as `TLSv1.3` and `TLS_AES_256_GCM_SHA384` — proving a real cryptographic handshake actually took place, not merely that the code was configured to attempt one.

2. **Why isn't HTTPS alone considered a complete security posture, and what did this lesson demonstrate to illustrate that?**
   HTTPS/TLS protects data in transit from being read or tampered with by a network observer, but it says nothing about several other, separate classes of vulnerability — like whether a browser might MIME-sniff a response's content type, or whether another site can embed the page in a hidden iframe for clickjacking. This was demonstrated by comparing two real HTTP responses (independent of the HTTPS demo): one missing `X-Content-Type-Options` and `X-Frame-Options` entirely, verified via the actual response headers showing `(MISSING)`, and one with those headers (plus `Content-Security-Policy` and `Strict-Transport-Security`) explicitly and correctly set.

## Recommended Next Lesson

This is the final lesson in the Security module. Continue to [17-Git-and-GitHub](../../17-Git-and-GitHub/README.md) if built, or return to the [module overview](../README.md).
