# Exercise 06 — Secure Password Reset Flow

[Back to Exercises overview](README.md) | [Solution](../25-Solutions/06-Password-Reset-Flow/README.md)

**Combines:** [16-Security](../16-Security/README.md) (secure password storage) + [04-Backend-Development](../04-Backend-Development/README.md) (REST API design)

## Problem

You're given a `UserAccount` class storing passwords with plain MD5, no salt:

```java
String hashed = md5(newPassword); // no salt, fast hash -- both real, verified problems
```

1. Demonstrate, with real computed hashes, that two users choosing the identical password produce identical MD5 hashes — a real information leak.
2. Redesign password storage to use PBKDF2 with a random, per-user salt (as verified live in [16-Security/02](../16-Security/02-Secure-Password-Storage/README.md)).
3. Implement a `changePassword(String oldPassword, String newPassword)` method that: (a) verifies the old password against the stored hash before allowing the change, and (b) stores the new password using the secure PBKDF2 approach.
4. Verify live: an incorrect "old password" is correctly rejected; a correct one succeeds and the new password is stored securely (different hash than another user with the same new password, thanks to a distinct salt).

## Constraints

- Do not use any external cryptography library beyond the JDK's own `javax.crypto` (as used throughout [16-Security](../16-Security/README.md)).
- `changePassword` must genuinely re-verify the old password — it must not be possible to change a password without providing the correct current one.

## Success Criteria

- The MD5 information leak is demonstrated with real, identical computed hashes for two users with the same password.
- The PBKDF2-based redesign is demonstrated to produce different hashes for the same password across two users.
- `changePassword` is verified to reject an incorrect old password and correctly accept a correct one.
