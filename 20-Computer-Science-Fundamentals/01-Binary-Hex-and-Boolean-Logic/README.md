# 01 — Binary/Hex and Boolean Logic

[Back to module overview](../README.md)

## Beginner: A Real Data-Corruption Bug From Signed Bytes

Computers store everything in binary; hexadecimal is just a compact, human-readable way to write binary values (each hex digit represents exactly 4 bits). This lesson demonstrates three real, verified bugs rooted directly in how Java represents binary data and boolean logic — not abstract descriptions.

## The Violation: Java's Signed `byte` Silently Corrupts Data

```java
byte fileByte = (byte) 0xFF; // represents the UNSIGNED byte value 255 in a binary file
int wrongInt = fileByte;     // BUG: direct conversion sign-extends
```

Java's `byte` type is **signed**, ranging from -128 to 127 — there is no unsigned byte type. A byte meant to represent the unsigned value `255` (`0xFF`) is actually stored as `-1`. Verified live:

```
Raw byte value (Java's signed interpretation): -1
Direct byte->int conversion: -1  <- WRONG: should be 255, got -1
Masked with & 0xFF: 255  <- correct: genuinely 255
```

Converting a `byte` directly to `int` **sign-extends** it — all the new high bits are filled with the sign bit (`1` for negative values), turning `-1` (`byte`) into `-1` (`int`) instead of the intended `255`. This is a genuinely common, real bug when parsing binary file formats or network protocols, where byte values are conceptually unsigned. The fix, `fileByte & 0xFF`, masks off the sign-extended bits, correctly yielding `255`.

## Arithmetic (`>>`) vs Logical (`>>>`) Shift — Real, Different Results

```java
int value = -8;           // binary: 11111111111111111111111111111000
int arithmetic = value >> 1;  // sign-extends
int logical = value >>> 1;    // zero-fills
```

Verified live:

```
value >>  1 = -4 (binary: 11111111111111111111111111111100)  <- sign-preserving
value >>> 1 = 2147483644 (binary: 01111111111111111111111111111100)  <- zero-filling, VERY different real result
```

`>>` (arithmetic shift) preserves the sign by filling new high bits with the original sign bit — correct for typical signed-integer division-like operations. `>>>` (logical shift) always fills with `0` — correct when treating the value as raw, unsigned bits. Using the wrong one on a negative number produces a **dramatically** different, real result (`-4` vs. `2147483644`).

## Short-Circuit (`&&`) vs Non-Short-Circuit (`&`) — A Real Behavioral Difference

```java
String maybeNull = null;
if (maybeNull != null && maybeNull.length() > 0) { ... }  // short-circuits safely
if (maybeNull != null &  maybeNull.length() > 0) { ... }  // evaluates BOTH sides
```

Verified live:

```
Using short-circuit && (correctly avoids evaluating the right side when the left is false):
  Correctly skipped calling .length() on null -- no exception
Using non-short-circuit & (evaluates BOTH sides regardless):
  Caught a REAL NullPointerException: & evaluated maybeNull.length() even though the left side was already false!
```

`&&` and `||` are **short-circuit** operators — if the left side already determines the result, the right side is never evaluated. `&` and `|` (also valid as boolean operators in Java, not just bitwise ones) always evaluate both sides — a real, exploitable difference whenever the right side has a side effect or might throw, as demonstrated here with a genuine `NullPointerException`.

## Detailed Example

See [Example.java](Example.java) — all three real, verified bugs.

## Run It

```bash
cd 20-Computer-Science-Fundamentals/01-Binary-Hex-and-Boolean-Logic
javac Example.java
java Example
```

## Expected Output

A real byte sign-extension bug (`-1` instead of `255`) and its mask-based fix; genuinely different real results from `>>` vs `>>>` on a negative number; a real `NullPointerException` from `&` evaluating both sides, correctly avoided by `&&`.

## Common Mistakes

- Converting a `byte` meant to represent an unsigned value directly to `int` without masking (`& 0xFF`) — verified live to silently corrupt the value via sign extension.
- Using `>>` when `>>>` (or vice versa) is actually needed — verified live to produce dramatically different real results on negative numbers.
- Using `&`/`|` instead of `&&`/`||` for boolean conditions with a null-check or other guard on the left side — verified live to cause a real exception the short-circuit version would have safely avoided.

## Best Practices

- Always mask (`& 0xFF`) when converting a `byte` representing unsigned binary/protocol data to a wider integer type.
- Use `>>>` specifically when treating a value as raw, unsigned bits; use `>>` for normal signed arithmetic.
- Default to `&&`/`||` for boolean conditions; reserve `&`/`|` for the rare cases where evaluating both sides unconditionally is genuinely intended.

## Real-World Usage

The signed-byte sign-extension bug is a classic, real source of errors when parsing binary file formats, network packets, or cryptographic data in Java — any protocol using bytes 128-255 as legitimate unsigned values will corrupt silently without proper masking. The short-circuit vs non-short-circuit distinction is a common real interview question and a genuine, occasionally-encountered production bug (a null-check guard written with `&` instead of `&&`).

## Summary

- Java's signed `byte` type was shown, live, to corrupt an intended unsigned value (`255` became `-1`) via sign extension on direct conversion to `int`, fixed by masking with `& 0xFF`.
- Arithmetic (`>>`) and logical (`>>>`) right shift were shown, live, to produce dramatically different real results on a negative number.
- Non-short-circuit `&` was shown, live, to cause a real `NullPointerException` that short-circuit `&&` correctly avoided.

## Key Terms

- **Sign extension** — filling the new, higher-order bits with the sign bit when widening a signed integer type, preserving its numeric value (or corrupting an intended unsigned interpretation).
- **Arithmetic vs. logical shift** — `>>` preserves sign (fills with the sign bit); `>>>` always fills with zero.
- **Short-circuit evaluation** — stopping evaluation of a boolean expression as soon as the result is determined, skipping any remaining, unevaluated operands.

## Interview Questions

1. **Why does converting a Java `byte` holding the bit pattern for 255 directly to `int` produce `-1` instead of `255`, and how is this fixed?**
   Java's `byte` type is signed, so the bit pattern `11111111` represents `-1`, not `255` — there is no unsigned byte type in Java. When that `byte` is widened to `int`, Java sign-extends it: the new high-order bits are filled with the original sign bit (`1`), producing `-1` as an `int` too, not the `255` a protocol or file format might have intended. This was verified live: `int wrongInt = fileByte;` produced `-1`, while `fileByte & 0xFF` correctly masked off the sign-extended bits, producing the intended `255`.

2. **What is the real, functional difference between `&&` and `&` when used as boolean operators, beyond style?**
   `&&` short-circuits — if the left operand already determines the result (e.g., `false` for `&&`), the right operand is never evaluated at all. `&` always evaluates both operands, regardless of whether the left one already determined the outcome. This was verified live with a genuine consequence: `maybeNull != null && maybeNull.length() > 0` safely skipped calling `.length()` on a `null` reference once `maybeNull != null` was `false`, while the identical expression written with `&` instead of `&&` still called `.length()` on the `null` reference, throwing a real `NullPointerException` — proving the difference is a real behavioral one, not merely stylistic.

## Recommended Next Lesson

[02 — Networking (TCP/IP, DNS, HTTP)](../02-Networking/README.md)
