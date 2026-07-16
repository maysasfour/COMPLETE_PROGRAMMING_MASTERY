# Technology Comparison

Head-to-head guides to help you choose between similar technologies. Each comparison covers syntax, learning curve, performance, ecosystem, use cases, and job-market relevance.

## Table of Contents

- [Python vs Java](#python-vs-java)
- [JavaScript vs TypeScript](#javascript-vs-typescript)
- [SQL vs NoSQL](#sql-vs-nosql)
- [REST vs GraphQL vs gRPC](#rest-vs-graphql-vs-grpc)
- [Monolith vs Microservices](#monolith-vs-microservices)

> More comparisons (C vs C++, Java vs C#, Go vs Rust, React vs Angular vs Vue, Flutter vs React Native, Django vs Flask vs FastAPI, MVC vs MVVM, Docker vs VMs) will be added as their respective modules are built — see [BUILD_STATUS.md](BUILD_STATUS.md).

## Python vs Java

| Aspect | Python | Java |
|---|---|---|
| Typing | Dynamic, optional type hints | Static, mandatory |
| Learning curve | Very gentle | Moderate (more ceremony/boilerplate) |
| Performance | Slower for CPU-bound work (interpreted) | Faster (JIT-compiled bytecode) |
| Ecosystem | Data science, scripting, backend (Django/FastAPI), automation | Enterprise backend, Android (historically), large-scale systems |
| Concurrency | GIL limits true parallel threads (use multiprocessing/async) | Native threads, virtual threads (Java 21+) |
| Job market | Very strong in data/ML/backend | Very strong in enterprise/finance/backend |
| Recommended when | Rapid development, scripting, ML, APIs | Large teams, strict typing needed, enterprise systems, Android legacy code |

## JavaScript vs TypeScript

| Aspect | JavaScript | TypeScript |
|---|---|---|
| Typing | Dynamic | Static (compiles to JS) |
| Tooling | Simpler setup | Requires a build step (or `ts-node`/bundler) |
| Error detection | Runtime | Compile-time (catches many bugs before running) |
| Learning curve | Lower initially | Slightly higher, pays off in larger codebases |
| Use case | Small scripts, quick prototypes | Any codebase beyond a few hundred lines, teams |
| Job market | Still dominant on the surface | Increasingly the default for serious frontend/backend JS work |
| Recommended when | Tiny scripts, learning basics first | Anything you'll maintain for more than a few weeks |

## SQL vs NoSQL

| Aspect | SQL (Relational) | NoSQL (e.g., MongoDB, DynamoDB) |
|---|---|---|
| Schema | Fixed, defined upfront | Flexible/schema-less |
| Relationships | First-class (JOINs, foreign keys) | Modeled via embedding or app-level joins |
| Consistency | Strong (ACID transactions) | Often eventual consistency (tunable) |
| Scaling | Vertical primarily, horizontal is harder | Horizontal scaling is a core design goal |
| Best for | Structured data with relationships: finance, inventory, ERP | High-volume, flexible/evolving data: catalogs, logs, real-time feeds |
| Recommended when | Data integrity and relationships matter most | Scale and schema flexibility matter most |

## REST vs GraphQL vs gRPC

| Aspect | REST | GraphQL | gRPC |
|---|---|---|---|
| Data fetching | Fixed shape per endpoint | Client specifies exact fields needed | Strongly-typed RPC calls |
| Over-fetching | Common problem | Solved by design | N/A (call-based, not resource-based) |
| Caching | Easy (HTTP caching) | Harder (single endpoint, POST-based) | N/A (not typically HTTP-cached) |
| Performance | Good, text-based (JSON) | Good, but complex queries can be expensive | Excellent (binary protobuf, HTTP/2) |
| Learning curve | Low | Moderate | Moderate-high |
| Best for | Public APIs, simple CRUD | Complex, nested data from multiple sources (mobile apps, dashboards) | Internal service-to-service communication, low latency |

## Monolith vs Microservices

| Aspect | Monolith | Microservices |
|---|---|---|
| Deployment | Single unit | Independently deployable services |
| Complexity | Lower operationally, can grow messy internally | Higher operationally (networking, observability), cleaner boundaries |
| Scaling | Scale the whole app | Scale services independently |
| Team structure | Works well for small teams | Suits multiple independent teams |
| Failure modes | One bug can affect the whole app | Failures can be isolated, but distributed failures are harder to debug |
| Recommended when | Small-to-medium teams, early-stage products | Large orgs, clear service boundaries, independent scaling needs |

---

**See also:** [13-Software-Architecture](13-Software-Architecture/) for deep dives on the architectural options mentioned above.
