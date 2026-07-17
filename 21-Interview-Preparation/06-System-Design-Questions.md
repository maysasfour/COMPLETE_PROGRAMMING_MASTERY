# System Design Interview Questions

[Back to module overview](README.md)

## 1. What does the CAP theorem actually say, and what's the real cost of choosing Availability over Consistency during a partition?

A distributed data store can provide at most two of Consistency, Availability, and Partition tolerance simultaneously during an actual network partition. This was demonstrated with a genuinely real partition (an actual stopped server, not simulated) in [20-Computer-Science-Fundamentals/04-CAP-Theorem-and-Distributed-Systems](../20-Computer-Science-Fundamentals/04-CAP-Theorem-and-Distributed-Systems/README.md): a system prioritizing Consistency correctly rejected a write it couldn't confirm was replicated, while one prioritizing Availability accepted it — and once the partition healed, the two replicas held genuinely different, verified values for the same key, the real cost of that choice.

## 2. What's the difference between a monolith and microservices, and what makes something a genuine microservice?

A monolith deploys all functionality as one unit; microservices split functionality into independently deployable services. The defining property of a genuine microservice isn't just being a separate process — it's that each service owns its state completely, exposed only through a validating API boundary. This was demonstrated in [13-Software-Architecture/03-Microservices-Fundamentals](../13-Software-Architecture/03-Microservices-Fundamentals/README.md): direct shared-state access allowed a real overselling bug, while a real HTTP API boundary correctly rejected the identical oversell attempt with an actual `409 Conflict`.

## 3. What is a "distributed monolith," and why is it worse than either a true monolith or true microservices?

It's a system split into separately deployed services that still share data directly (a shared database, or shared memory) instead of going through each other's validating APIs — it has all the operational complexity of microservices (network calls, deployment coordination) with none of the data-integrity safety a true microservice boundary provides.

## 4. How would you design an API endpoint to be safely retryable?

Make the operation idempotent — typically via a client-supplied identifier or an explicit idempotency key, so retrying the identical request produces the same end result rather than a duplicate. Verified live in [14-APIs-and-Integrations/01-HTTP-Fundamentals](../14-APIs-and-Integrations/01-HTTP-Fundamentals/README.md): a non-idempotent `POST` retried twice created 2 separate orders, while an idempotent `PUT` with a client-supplied ID retried twice left exactly 1.

## 5. How would you prevent a single slow dependency from cascading into a system-wide outage?

Configure explicit timeouts on every external call (rather than allowing unbounded waits), pair them with a real fallback/retry strategy, and consider circuit breakers to stop calling a dependency that's clearly failing. Verified live in [14-APIs-and-Integrations/05-Consuming-Third-Party-APIs](../14-APIs-and-Integrations/05-Consuming-Third-Party-APIs/README.md): a client with no timeout took the full delay a slow dependency imposed, while one with an explicit timeout failed fast and predictably.

## 6. Why should non-critical side effects (logging, analytics, notifications) not block a critical operation's success?

If a non-critical dependency's failure is allowed to propagate synchronously, it can prevent an otherwise fully successful critical operation from completing. This was demonstrated live in [13-Software-Architecture/04-Event-Driven-Architecture-Basics](../13-Software-Architecture/04-Event-Driven-Architecture-Basics/README.md): a synchronous analytics call failure prevented an order's completion message from ever printing, despite inventory and email steps having already succeeded — fixed with an event bus that isolates each subscriber's exceptions individually.

## 7. What's the difference between a layered (N-tier) architecture and a hexagonal (ports and adapters) architecture?

Layered architecture organizes code into horizontal layers (presentation, business, data access), each depending only on the layer beneath it — demonstrated in [13-Software-Architecture/01-Layered-N-tier-Architecture](../13-Software-Architecture/01-Layered-N-tier-Architecture/README.md), where skipping the service layer let invalid data reach storage unchecked. Hexagonal architecture instead organizes around a dependency *direction*: the domain defines abstractions ("ports") that infrastructure implements ("adapters"), so the domain never depends on infrastructure — demonstrated in [13-Software-Architecture/02-Clean-and-Hexagonal-Architecture](../13-Software-Architecture/02-Clean-and-Hexagonal-Architecture/README.md), where a domain class hard-wired to a concrete infrastructure class couldn't be exercised under a different scenario without editing that infrastructure class.

## 8. How would you design a system to handle a "backorder" or inventory-reservation scenario correctly under concurrent requests?

Ensure the check-and-decrement of available stock happens atomically (behind a real transaction, or a single, validating API endpoint) rather than as separate, racy steps — verified live in [13-Software-Architecture/03-Microservices-Fundamentals](../13-Software-Architecture/03-Microservices-Fundamentals/README.md), where a real HTTP endpoint correctly rejected an oversell attempt that direct, unsynchronized field access would have allowed.

## 9. Why is indexing every column in a database not a free performance win?

Every index speeds up reads that filter/sort on it, but slows down every write to that column (the index must also be updated), and consumes additional storage — the right approach is indexing based on actual, measured query patterns. Verified live in [07-Databases/04-Indexes-and-Query-Optimization](../07-Databases/04-Indexes-and-Query-Optimization/README.md) with a real, measured 73x speedup for a query that actually benefited from an index.

## 10. How would you decide between a relational and a document (NoSQL) database for a given feature?

Favor relational when data has many relationships requiring referential integrity and joins (verified throughout [07-Databases](../07-Databases/README.md) Lessons 01-05). Favor a document database when data is naturally self-contained, varies in shape between records, and is usually read together as a whole — verified live in [07-Databases/06-NoSQL-Databases](../07-Databases/06-NoSQL-Databases/README.md), while noting that over-embedding reintroduces exactly the redundancy risk normalization exists to prevent.

## Recommended Next File

[07 — Behavioral Questions](07-Behavioral-Questions.md)
