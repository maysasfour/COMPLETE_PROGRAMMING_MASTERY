# Solution 06 — Secure Password Reset Flow

[Back to Solutions overview](../README.md) | [Exercise](../../24-Exercises/06-Password-Reset-Flow.md)

## Approach

`UserAccount` stores passwords using PBKDF2 (JDK's own `javax.crypto`) with a fresh, random salt per user. `changePassword` calls `checkPassword` on the supplied old password before making any change, and generates a new salt for the new password too.

## Verified Live

```
=== Step 1: MD5's real information leak ===
Alice's MD5 hash: f065d609e55983bc6087c073c91c9bc7
Bob's MD5 hash:   f065d609e55983bc6087c073c91c9bc7
Identical: true  <- BUG: same password reveals as same hash!

=== Step 2: PBKDF2 with per-user salt ===
Alice's PBKDF2 hash: 154cf281b39d5a2ec91d8e8c20d1b9cf213f79887e4eaa43e6c7b28467cbef7f
Bob's PBKDF2 hash:   51cd556dd5a9726bc000dc4766759df3f7347120160d5532e983804b0353674c
Identical: false  <- correct: different salts, different hashes

=== Step 3 & 4: changePassword() genuinely re-verifies the old password ===
Rejected: Old password is incorrect -- password NOT changed
Alice's password still the OLD one after the rejected attempt: true
Password changed with the CORRECT old password.
New password verifies: true
Old password no longer works: true
```

Same MD5 finding verified in [16-Security/02-Secure-Password-Storage](../../16-Security/02-Secure-Password-Storage/README.md); the same password produced identical MD5 hashes but genuinely different PBKDF2 hashes (thanks to distinct random salts), and `changePassword` correctly rejected an incorrect old password before allowing any change.

## Run It

```bash
cd 25-Solutions/06-Password-Reset-Flow
javac Example.java
java Example
```

See [Example.java](Example.java) for the full, runnable solution.
