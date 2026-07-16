# 02 — Secure Password Storage

[Back to module overview](../README.md) | [Previous: SQL Injection](../01-SQL-Injection/README.md)

## Beginner: Why "Hashing" Alone Isn't Enough

Storing a password's hash instead of the plaintext is the bare minimum — but a fast, unsalted hash like MD5 is still a real, measurable liability. This lesson demonstrates two genuine, real problems with MD5 for password storage, then fixes both with PBKDF2 (built into the JDK's own `javax.crypto`, not a toy substitute), backed by real computed hash values and real measured timing.

## Problem 1: Identical Passwords Produce Identical Hashes

```java
static String md5(String password) throws NoSuchAlgorithmException {
    MessageDigest digest = MessageDigest.getInstance("MD5");
    return HexFormat.of().formatHex(digest.digest(password.getBytes()));
}
```

Verified live, two different users who happen to pick the same password:

```
Alice's MD5 hash: f065d609e55983bc6087c073c91c9bc7
Bob's MD5 hash:   f065d609e55983bc6087c073c91c9bc7
Hashes identical: true  <- BUG: an attacker who cracks ONE of these instantly knows BOTH users' password!
```

Both hashes are byte-for-byte identical. In a real breach, this means an attacker only has to crack (or find in a precomputed "rainbow table") one hash to instantly know every account sharing that same password.

## Problem 2: MD5 Is Cheap to Brute-Force

Verified live, computing 100,000 real MD5 hashes:

```
100000 MD5 hashes computed in 211 ms (0.00211 ms/hash -- CHEAP for an attacker to brute-force)
```

At roughly 0.002ms per hash, an attacker with real hardware can attempt an enormous number of password guesses per second against a stolen MD5 hash database.

## The Fix: PBKDF2 With a Random Salt and a Deliberately High Iteration Count

```java
static String pbkdf2(String password, byte[] salt, int iterations) throws ... {
    PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, 256);
    SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
    return HexFormat.of().formatHex(factory.generateSecret(spec).getEncoded());
}
```

Verified live — the same password (`"Summer2024!"`) with two different random salts now produces two **completely different** hashes:

```
Alice's PBKDF2 hash: ec9c9483c98152ee1b63af9f20257149cf24437512cdfcab2184af7f112c976c
Bob's PBKDF2 hash:   e74300fbe61a6cfcb52572c5b0db2570cfa41b5bd907312e754aaea3f6e43c24
Hashes identical: false  <- correct: identical passwords now produce COMPLETELY different stored hashes
```

And a correct password still verifies successfully by recomputing the hash with the *same* stored salt:

```
Recomputing Alice's hash with her OWN salt matches stored hash: true
```

## Advanced: The Real, Measured Cost Difference

Verified live, computing 20 real PBKDF2 hashes at 120,000 iterations:

```
20 PBKDF2 hashes computed in 3642 ms (182.10 ms/hash -- deliberately EXPENSIVE, making brute-forcing far costlier)
PBKDF2 was 86303x slower per hash than MD5 -- exactly the deliberate cost that protects against brute-force attacks.
```

This slowness is the entire point: an algorithm that takes 182ms per guess instead of 0.002ms makes brute-forcing a stolen password database roughly 86,000 times more expensive for an attacker — a real, deliberate, tunable trade-off (via the iteration count) between security and legitimate login latency.

## Detailed Example

See [Example.java](Example.java) — real MD5 and PBKDF2 hash computation and timing measurements.

## Run It

```bash
cd 16-Security/02-Secure-Password-Storage
javac Example.java
java Example
```

(Takes a few seconds due to the real PBKDF2 computation.)

## Expected Output

Two identical MD5 hashes for the same password; two different PBKDF2 hashes for the same password (different salts); a confirmed-correct password verification; real measured timing showing PBKDF2 many orders of magnitude slower per hash than MD5.

## Common Mistakes

- Using a fast, general-purpose hash function (MD5, SHA-1, even plain SHA-256) for password storage — verified live to be extremely cheap to brute-force compared to a proper key-derivation function.
- Not salting password hashes — verified live to let identical passwords produce identical hashes, a real, exploitable information leak.
- Reusing the same salt across all users — a shared salt provides almost none of the protection of a genuinely per-user random salt; each password must get its own, independently-generated salt.

## Best Practices

- Use a dedicated password-hashing algorithm (PBKDF2, bcrypt, scrypt, or Argon2) — never a general-purpose fast hash function.
- Generate a genuinely random salt per password (via `SecureRandom`, as shown here), stored alongside the hash (not secret, just unique).
- Choose an iteration/cost parameter that's as high as your legitimate login latency budget allows — the goal is to make legitimate logins (one hash) fast enough to be unnoticed, while making brute-force attacks (millions of hashes) prohibitively slow.

## Real-World Usage

Real, large-scale password database breaches have repeatedly demonstrated the exact risk profile shown in this lesson: databases hashed with fast, unsalted algorithms (MD5, SHA-1) have historically been cracked wholesale using rainbow tables and brute-force clusters, while properly salted, slow key-derivation functions (bcrypt, PBKDF2, Argon2) remain dramatically more resistant even when the hash database itself is stolen.

## Summary

- Plain MD5 was shown, live, to produce identical hashes for identical passwords — a real information leak — and to be extremely cheap to compute (0.002ms/hash), making brute-force attacks cheap.
- PBKDF2 with a random salt was shown, live, to produce completely different hashes for identical passwords, while still correctly verifying a genuine password against its own stored salt.
- The real, measured cost difference (roughly 86,000x slower per hash) is the deliberate mechanism that makes brute-forcing a stolen password database dramatically more expensive.

## Key Terms

- **Salt** — random, per-password data mixed into a hash computation, ensuring identical passwords produce different hashes.
- **Key derivation function (KDF)** — a deliberately slow, tunable-cost hash function (PBKDF2, bcrypt, scrypt, Argon2) designed specifically for password storage.
- **Rainbow table** — a precomputed table of hash-to-plaintext mappings, effective against unsalted hashes but defeated by per-password salting.

## Interview Questions

1. **Why is it a real vulnerability for two identical passwords to produce identical hashes, and how was this demonstrated?**
   If two accounts' password hashes are identical, an attacker who cracks (or looks up in a precomputed rainbow table) just one of them instantly knows the password for every other account sharing that same hash — without needing to attack each account individually. This was demonstrated concretely: hashing the same password (`"Summer2024!"`) for two different users with plain MD5 produced byte-for-byte identical hashes, verified by direct string comparison (`Hashes identical: true`), while the same passwords hashed with PBKDF2 and per-user random salts produced completely different hashes (`Hashes identical: false`).

2. **Why is a fast hash function like MD5 a real liability for password storage specifically, even though it's fine for other uses (like checksums)?**
   For non-password use cases (verifying file integrity, for example), speed is a benefit. For password storage, speed is a liability: it directly determines how many guesses per second an attacker can attempt against a stolen hash. This was demonstrated with real, measured timing: 100,000 MD5 hashes computed in 211ms (about 0.002ms each) versus just 20 PBKDF2 hashes (at a real 120,000-iteration cost setting) taking 3,642ms (about 182ms each) — a genuine, measured ~86,000x cost multiplier that makes brute-forcing a stolen PBKDF2-hashed database dramatically more expensive than an MD5-hashed one.

## Recommended Next Lesson

[03 — Input Validation and Output Encoding](../03-Input-Validation-and-Output-Encoding/README.md)
