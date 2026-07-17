# 04 — CAP Theorem and Distributed Systems Basics

[Back to module overview](../README.md) | [Previous: OS Fundamentals](../03-OS-Fundamentals/README.md)

## Beginner: A Real Network Partition, Not a Diagram

The CAP theorem states that a distributed data store can provide at most two of three guarantees — Consistency, Availability, Partition tolerance — during an actual network partition. This lesson doesn't just draw the classic triangle diagram: it runs **two real, separate embedded HTTP servers** representing two database replicas, **genuinely stops one of them** to create a real partition, and shows the real, verified consequence of choosing Consistency vs. Availability.

## Normal Operation: Replication Works

```java
put(portA, "x", "1"); // writes to Node A, which replicates to Node B over a REAL HTTP call
```

Verified live:

```
Node A's value for x: 1
Node B's value for x: 1  (correctly replicated)
```

## A Real Network Partition

```java
nodeB.stop(0); // Node B is GENUINELY stopped -- not simulated
```

When Node A next tries to replicate a write to Node B, it gets a **real** `java.net.ConnectException` (or timeout) — Node B is truly unreachable, exactly as it would be during a real network partition.

## Choosing Consistency (CP): Reject the Write

```java
if (!replicated) {
    if (cpMode) { status = 503; /* reject */ }
}
```

Verified live:

```
PUT x=2 on Node A -> REJECTED (CP mode): peer unreachable, refusing to risk inconsistency
Node A's value for x: 1  <- correct: unchanged, the rejected write never applied
```

Node A refused to accept a write it couldn't confirm was replicated — this guarantees consistency (every replica that *is* reachable always agrees), at the cost of availability (a legitimate write request was refused, even though Node A itself was perfectly healthy).

## Choosing Availability (AP): Accept the Write Anyway

```java
} else {
    store.put(key, value); // accept despite the partition
    status = 200;
}
```

Verified live, with the identical partition still in effect:

```
PUT x=3 on Node A (AP mode, B still unreachable) -> OK (AP mode): accepted WITHOUT replication -- peer was unreachable
Node A's value for x: 3  <- accepted locally DESPITE the partition
```

## The Real, Verified Cost: Divergence

```java
HttpServer nodeBrestarted = startNode(portB, portA, storeB, true); // partition heals
```

Verified live, once Node B comes back:

```
Node A's value for x: 3
Node B's value for x: 1  <- REAL, VERIFIED DIVERGENCE: A and B now disagree, because AP accepted a write during the partition
```

This is the real, concrete cost of choosing Availability during a partition: two replicas of the same system genuinely disagree about the value of `x` (`3` on A, `1` on B), and something (a conflict-resolution strategy, a manual reconciliation process, a "last write wins" rule) must resolve this divergence once the partition heals — CAP doesn't make that problem go away, it just names the tradeoff that caused it.

## Detailed Example

See [Example.java](Example.java) — two real HTTP-based replica nodes, a real partition, and real, verified divergence.

## Run It

```bash
cd 20-Computer-Science-Fundamentals/04-CAP-Theorem-and-Distributed-Systems
javac Example.java
java Example
```

## Expected Output

Correct replication during normal operation; a real `503` rejection in CP mode once Node B is genuinely stopped; a real, accepted write in AP mode despite the same partition; real, verified divergent values between the two nodes once the partition heals.

## Common Mistakes

- Treating CAP as an abstract, purely academic concept — verified live here with two real servers, a real stopped process, and real, measurably divergent data.
- Assuming "partition tolerance" is optional in real distributed systems — real networks genuinely do partition (this lesson simulates it by literally stopping a server, but the same failure mode — a real, unreachable peer — happens in production from network outages, timeouts, and hardware failures); a distributed system must decide, in advance, how it will behave when this happens.
- Assuming AP mode is simply "worse" than CP mode — the right choice depends entirely on the application: an e-commerce cart (available, eventually reconciled) has very different requirements than a bank balance (consistent, willing to reject operations during an outage).

## Best Practices

- Explicitly decide, for each piece of distributed state, whether consistency or availability matters more during a partition — this is a real design decision, not something to leave implicit.
- If choosing Availability, have a real, deliberate conflict-resolution strategy ready for when a partition heals (last-write-wins, vector clocks, application-level merge logic) — this lesson's divergence was left unresolved specifically to make the *cost* of AP visible, not because "figure it out later" is an acceptable real strategy.
- Test partition behavior with real, induced failures (as this lesson does by genuinely stopping a server) rather than only reasoning about it in the abstract.

## Real-World Usage

Real distributed databases explicitly choose a position on this spectrum: traditional relational databases with synchronous replication lean CP; many NoSQL stores (Cassandra, DynamoDB) default to AP with tunable consistency; the CAP theorem is the standard vocabulary for discussing and justifying these design choices in real system-design interviews and real architecture decisions.

## Summary

- Two real, separate HTTP-based replica nodes were built, with a real, genuine network partition induced by actually stopping one server.
- Choosing Consistency (CP) was verified, live, to correctly reject a write during the partition, keeping all reachable replicas in agreement at the cost of refusing a legitimate request.
- Choosing Availability (AP) was verified, live, to accept the identical write during the identical partition — and, once the partition healed, produced real, measurably divergent data between the two nodes, the concrete cost of that choice.

## Key Terms

- **CAP theorem** — a distributed system can provide at most two of Consistency, Availability, and Partition tolerance simultaneously during an actual partition.
- **Network partition** — a real failure where some nodes in a distributed system cannot communicate with others, despite each individually still being up.
- **Divergence** — when replicas of the same logical data disagree, typically as a consequence of an Availability-favoring choice during a partition.

## Interview Questions

1. **Why must a distributed system choose between Consistency and Availability specifically during a partition, and how was this demonstrated concretely?**
   During a partition, a node cannot confirm that a write has reached other replicas — it must decide whether to accept the write anyway (favoring Availability, at the risk of the replicas disagreeing) or refuse it until it can confirm replication (favoring Consistency, at the cost of refusing a request the node itself was otherwise capable of serving). This was demonstrated concretely: with Node B genuinely stopped, Node A running in CP mode returned a real `503` rejection for a write it couldn't confirm was replicated, while the identical write against the identical partition, with Node A running in AP mode, was accepted with a real `200` response — the same real failure condition, two different, deliberate responses to it.

2. **What real, concrete cost was demonstrated as the consequence of choosing Availability during a partition?**
   The concrete cost is data divergence: once the partition healed, the two replicas held genuinely different values for the same key, with no framework-level mechanism resolving that disagreement automatically. This was verified directly: after Node B was restarted, querying Node A returned `3` (the write accepted during the partition) while querying Node B returned `1` (its last value before the partition, since it never received the AP-mode write) — a real, measured divergence proving that choosing Availability during a partition genuinely defers a data-integrity problem rather than avoiding one.

## Recommended Next Lesson

This is the final lesson in the Computer Science Fundamentals module. Continue to [21-Interview-Preparation](../../21-Interview-Preparation/README.md) if built, or return to the [module overview](../README.md).
