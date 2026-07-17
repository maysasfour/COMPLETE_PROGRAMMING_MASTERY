# Computer Science Fundamentals Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../20-Computer-Science-Fundamentals/README.md)

## Binary/Hex and Boolean Logic
```java
int wrong = signedByte;          // sign-extends -- 255 becomes -1
int correct = signedByte & 0xFF; // masked -- correctly 255
value >> 1;   // arithmetic shift -- preserves sign
value >>> 1;  // logical shift -- always zero-fills
a && b;  // short-circuits -- safe with a null-check guard
a & b;   // evaluates BOTH sides -- can throw where && wouldn't
```
See [20-Computer-Science-Fundamentals/01](../../20-Computer-Science-Fundamentals/01-Binary-Hex-and-Boolean-Logic/README.md) for all four, verified live.

## Networking
DNS resolves hostnames to IP addresses (often multiple, for redundancy/IPv4+IPv6). HTTP is genuinely just formatted text sent over a plain TCP socket — proven live by manually writing a raw HTTP request with no library involved. See [20-Computer-Science-Fundamentals/02](../../20-Computer-Science-Fundamentals/02-Networking/README.md).

## OS Fundamentals
```java
AtomicInteger counter = new AtomicInteger(0);
counter.incrementAndGet(); // atomic -- immune to scheduler interleaving
```
`counter++` is really 3 steps (read/modify/write) — verified live: 4 threads incrementing 100,000 times each reliably lost over half their updates without synchronization. See [20-Computer-Science-Fundamentals/03](../../20-Computer-Science-Fundamentals/03-OS-Fundamentals/README.md).

## CAP Theorem
A distributed system chooses at most two of Consistency, Availability, Partition tolerance during a real partition. Verified live: CP mode rejected a write with `503` when replication couldn't be confirmed; AP mode accepted it, producing real, measured data divergence once the partition healed. See [20-Computer-Science-Fundamentals/04](../../20-Computer-Science-Fundamentals/04-CAP-Theorem-and-Distributed-Systems/README.md).

See the [full Computer Science Fundamentals module](../../20-Computer-Science-Fundamentals/README.md) for verified, runnable code for everything above.
