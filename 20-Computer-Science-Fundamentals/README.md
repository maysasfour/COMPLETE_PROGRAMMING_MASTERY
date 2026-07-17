# 20 — Computer Science Fundamentals

[Back to repository root](../README.md)

## What Computer Science Fundamentals Covers

This module covers core CS concepts underlying everything else in this repository: binary/hex representation and boolean logic, networking (DNS/TCP/HTTP), OS fundamentals (processes, threads, scheduling), and the CAP theorem/distributed systems basics. Every lesson demonstrates its concept with real, compiled, and run Java code — including a genuine network partition, a genuine measured race condition, and real proof that HTTP is just text over TCP.

## Why Java as This Module's Reference Language

This repository's concept modules each pick one reference language rather than duplicating every lesson across every language in `01-Languages` (see [19-Command-Line-and-Operating-Systems](../19-Command-Line-and-Operating-Systems/README.md) for the contrasting case where the tooling itself, not a language, is the subject). This module's concepts are genuinely language-agnostic, but Java's explicit typing (making the signed-byte bug in Lesson 01 concrete), built-in networking APIs (`Socket`, `HttpServer`, `InetAddress`), and `java.util.concurrent` package (making Lesson 03's race condition and its fix directly demonstrable) make it a strong fit for verifying these concepts with real, runnable code.

## Why It Matters / Where It's Used

- **These are the concepts every other module in this repository ultimately rests on** — every HTTP server built in [04-Backend-Development](../04-Backend-Development/README.md) or [13-Software-Architecture](../13-Software-Architecture/README.md) relies on the TCP/HTTP fundamentals in Lesson 02; every concurrent/threaded example relies on the OS scheduling fundamentals in Lesson 03.
- **Every lesson demonstrates a genuinely real, sometimes surprising finding**: a real data-corruption bug from Java's signed byte, real proof that HTTP is nothing but formatted text over a plain socket, a real, repeatable race condition losing 50-70% of expected increments, and real, measured data divergence from an actual (not simulated) network partition.
- **Interviews**: "explain two's complement," "what happens during a TCP handshake," "explain the CAP theorem," and "what causes a race condition" are some of the most common computer science fundamentals interview questions, directly covered by this module's four lessons.

## Advantages of This Approach

- Every concept is backed by real, observed evidence rather than description: a real corrupted value (`-1` instead of `255`), real dramatically different shift results, a real `NullPointerException` from `&` vs `&&`, real DNS-resolved IP addresses, a real raw-socket HTTP round trip, a real measured race condition (reliably losing over half of expected increments across multiple runs), and a real network partition (an actual stopped server) producing real, verified data divergence.
- Lesson 04 goes beyond typical CAP theorem explanations by actually running two separate HTTP servers and genuinely stopping one to create a real partition — the resulting divergence is measured directly, not asserted.
- Lesson 03's race condition was verified not once but across multiple separate runs, confirming it's a reliable, repeatable consequence of the underlying concurrency issue, not a one-off fluke.

## Disadvantages / Trade-offs

- Lesson 04's distributed systems simulation runs both "replica nodes" as HTTP servers within a single JVM process — this is sufficient to genuinely demonstrate the CAP tradeoff (the servers are real, separate, and communicate over real sockets), but is simpler than a true multi-machine distributed deployment.
- This module covers foundational breadth rather than deep specialization in any one area (e.g., full TCP handshake mechanics, detailed CPU scheduling algorithms) — appropriate for a fundamentals module, with deeper treatment available in dedicated networking or OS coursework.

## How to Run the Examples

Each lesson is a single, self-contained Java file — no build tool or dependencies required.

```bash
cd 20-Computer-Science-Fundamentals/01-Binary-Hex-and-Boolean-Logic
javac Example.java
java Example
```

Lesson 02's DNS lookup requires network access (the raw-socket HTTP demo works fully offline). Requires only a JDK (this module was built and verified against JDK 25). `.class` files are not committed — recompile locally after cloning.

## Common Beginner Mistakes

- **Converting a signed `byte` to `int` without masking** — verified live in Lesson 01 to silently corrupt an intended unsigned value.
- **Using `&`/`|` instead of `&&`/`||` for boolean conditions with a guard clause** — verified live in Lesson 01 to cause a real, avoidable exception.
- **Treating HTTP as a mysterious binary protocol** — verified live in Lesson 02 to be nothing more than specifically-formatted text over a plain TCP socket.
- **Assuming `counter++` is atomic** — verified live in Lesson 03, across multiple runs, to reliably lose a large fraction of concurrent increments.
- **Treating network partitions as a rare, theoretical edge case** — Lesson 04 demonstrates a real partition and its real, concrete data-divergence cost.

## Best Practices

- Mask signed bytes (`& 0xFF`) when treating them as unsigned data; use `>>>` specifically for unsigned/raw-bit shifting.
- Default to short-circuit `&&`/`||` for boolean conditions.
- Use `java.util.concurrent.atomic` types or proper synchronization for any shared mutable state accessed by multiple threads.
- Make an explicit, deliberate choice between consistency and availability for distributed state, with a real conflict-resolution strategy ready for when a partition heals.

## Interview Questions

1. Why does converting a Java `byte` representing an unsigned value to `int` sometimes produce a negative number, and how do you fix it?
2. What's the real difference between `&&` and `&`, or `||` and `|`, beyond style?
3. In what sense is HTTP "just text over TCP"?
4. Why isn't `counter++` atomic, and what's the correct way to fix a race condition on a shared counter?
5. What does the CAP theorem actually say, and what's the real cost of choosing Availability over Consistency during a partition?

(Detailed, verified answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Binary/Hex and Boolean Logic](01-Binary-Hex-and-Boolean-Logic/README.md) | A real signed-byte corruption bug; `>>` vs `>>>`; short-circuit vs non-short-circuit operators |
| 02 | [Networking](02-Networking/README.md) | Real DNS resolution; real proof HTTP is text over a raw TCP socket |
| 03 | [OS Fundamentals](03-OS-Fundamentals/README.md) | A real, repeatable race condition from OS thread scheduling; `AtomicInteger` |
| 04 | [CAP Theorem and Distributed Systems Basics](04-CAP-Theorem-and-Distributed-Systems/README.md) | A real network partition; real, verified data divergence from choosing Availability |

## Suggested Path

Work through 01 → 04 in order — each lesson builds toward increasingly larger-scale systems concepts (single-value representation, then a single network exchange, then a single machine's concurrency, then multiple machines' coordination). See also [04-Backend-Development](../04-Backend-Development/README.md) and [13-Software-Architecture](../13-Software-Architecture/README.md) for where these fundamentals are applied at the scale of real applications and services.

**Previous module:** [19-Command-Line-and-Operating-Systems](../19-Command-Line-and-Operating-Systems/README.md)
