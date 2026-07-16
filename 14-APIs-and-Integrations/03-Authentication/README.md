# 03 — Authentication: Validity vs. Scope

[Back to module overview](../README.md) | [Previous: REST Design and Versioning](../02-REST-Design-and-Versioning/README.md)

## Beginner: A Valid Token Is Not the Same as a Permitted Action

A token can be **genuinely, cryptographically valid** — correctly signed, unmodified, issued by a real, trusted source — while still not being **allowed** to perform a specific action. This is exactly what OAuth2-style **scopes** exist to express: a token can prove *who* it belongs to (authentication) without granting permission to do *everything* (authorization). This lesson demonstrates a real bug caused by checking only validity, using a genuinely working HMAC-signed token built with the JDK's own `javax.crypto` — not a mocked stand-in.

Note: this lesson focuses specifically on scope-based authorization, distinct from [04-Backend-Development Lesson 04](../../04-Backend-Development/04-Authentication-and-Authorization/README.md), which covers JWT-based role authentication and Spring Security's actual default behaviors in depth.

## The Violation: A Real Scope-Bypass Bug

```java
static String deleteRecordViolation(String token) throws Exception {
    Claims claims = verifyToken(token); // only checks: is this signature genuine?
    return "Deleted record on behalf of " + claims.subject() + " (scope was: " + claims.scope() + ")";
    // BUG: never checked whether claims.scope() actually permits deletion!
}
```

`verifyToken()` performs real signature verification via HMAC-SHA256 — it genuinely proves the token wasn't tampered with. But the endpoint stops there, never checking whether the token's `scope` claim actually grants write access. Verified live, with a token issued with only `"read"` scope:

```
A READ-ONLY token (issued to alice, scope="read") is used to call DELETE:
  Deleted record on behalf of alice (scope was: read)  <- BUG: a read-only token was allowed to perform a DESTRUCTIVE write operation!
```

The token is completely genuine and unmodified — this isn't a forgery or a cryptographic weakness. The bug is purely that the endpoint never asked the second, distinct question: *is this specific token allowed to do this specific thing?*

## The Fix: Check Both Validity AND Scope

```java
static String deleteRecordFixed(String token) throws Exception {
    Claims claims = verifyToken(token); // step 1: authentication
    if (!claims.scope().contains("write")) { // step 2: authorization
        throw new SecurityException("... write access required, request denied");
    }
    return "Deleted record on behalf of " + claims.subject() + " ...";
}
```

Verified live — the identical read-only token is now correctly rejected, while a token that actually has write scope is correctly accepted:

```
The SAME read-only token is rejected for DELETE:
  Rejected: Token for alice has scope "read" -- write access required, request denied
A token WITH write scope (issued to bob, scope="read write") is correctly accepted:
  Deleted record on behalf of bob (scope was: read write)
```

## Advanced: A Genuinely Tampered Token Is Still Rejected

Signature verification remains essential — it's a separate, equally important check from scope. Verified live, a token with its signature corrupted is rejected before scope is even considered:

```
Rejected: Invalid token signature  <- correct: a genuinely tampered token is caught by signature verification
```

## Detailed Example

See [Example.java](Example.java) — a genuinely working HMAC-SHA256-signed token, the real scope-bypass bug, and the fix.

## Run It

```bash
cd 14-APIs-and-Integrations/03-Authentication
javac Example.java
java Example
```

## Expected Output

A read-only token successfully (and wrongly) permitted to delete in the violation; the same token correctly rejected, and a write-scoped token correctly accepted, in the fix; a genuinely tampered token correctly rejected by signature verification regardless of scope.

## Common Mistakes

- Checking only that a token is validly signed, without checking what it's actually scoped/permitted to do — verified live to let a read-only token perform a destructive write operation.
- Treating authentication ("who is this?") and authorization ("what are they allowed to do?") as the same check — this exact confusion is what [04-Backend-Development Lesson 04](../../04-Backend-Development/04-Authentication-and-Authorization/README.md) also demonstrates from a role-based angle, and it recurs here from a scope-based one.
- Issuing tokens with overly broad scopes "just in case," which defeats the purpose of scoping — a token should only ever be issued with the narrowest scope the client actually needs.

## Best Practices

- Always perform authorization (scope/role/permission checks) as a distinct step after authentication (signature/validity checks) — never assume validity implies permission.
- Issue tokens with the narrowest scope that satisfies the client's actual need (a read-only integration should get a read-only token, never a read-write one "to be safe").
- Verify signatures using a real, well-tested cryptographic primitive (as this lesson does with `javax.crypto`'s `Mac`/`HmacSHA256`) rather than a hand-rolled comparison.

## Real-World Usage

OAuth2's scope system (`read:users`, `write:repos`, etc., as seen in GitHub's and Google's OAuth implementations) exists specifically to let a client request — and a user grant — only the minimum access actually needed, rather than all-or-nothing access to an account. The scope-bypass bug demonstrated in this lesson is a real, documented category of API security vulnerability (broken function-level authorization), distinct from and just as dangerous as a broken or forgeable signature.

## Summary

- A cryptographically valid token was shown, live, to be wrongly accepted for an operation its scope didn't actually grant, because the endpoint checked only validity, not scope.
- Adding an explicit scope check fixed this, verified live by the same token now being correctly rejected, and a properly-scoped token being correctly accepted.
- A genuinely tampered token was still correctly caught by signature verification, confirming that validity and scope are two separate, both-necessary checks.

## Key Terms

- **Authentication** — verifying who a request claims to be from (here, verifying the token's signature).
- **Authorization** — verifying what an authenticated identity is actually allowed to do (here, checking the token's scope).
- **Scope** — a claim within a token expressing what specific actions/resources it grants access to.

## Interview Questions

1. **Why isn't a validly-signed token sufficient to authorize every action, and how was this demonstrated concretely?**
   A token's signature only proves it's genuine and unmodified (authentication) — it says nothing about what specific actions the token's issuer intended to permit (authorization). This was demonstrated concretely: a token issued with only `"read"` scope passed `verifyToken()`'s genuine HMAC-SHA256 signature check without any issue, and `deleteRecordViolation()` incorrectly treated that successful verification as sufficient to allow a destructive delete — verified live by the operation actually "succeeding" for a read-only token.

2. **How does adding a scope check differ from, and complement, signature verification?**
   Signature verification (authentication) answers "is this token genuine, and does it really say what it claims to say?" Scope checking (authorization) answers a separate question: "does what this token claims actually permit this specific action?" Both were verified independently in this lesson: a token with a corrupted signature was rejected by `verifyToken()` itself, regardless of what scope it claimed to have, while a token that passed signature verification perfectly (genuinely unmodified) was still correctly rejected by the added scope check when its scope (`"read"`) didn't include `"write"` — proving the two checks catch different, independent classes of problems.

## Recommended Next Lesson

[04 — API Documentation](../04-API-Documentation/README.md)
