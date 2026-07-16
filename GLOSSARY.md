# Glossary

Alphabetical reference of key terms used throughout this repository. Each major module also defines its own "Key Terms" at the end of each lesson — this file is the cross-cutting index.

## A

- **Abstraction** — Hiding implementation detail behind a simpler interface.
- **ACID** — Atomicity, Consistency, Isolation, Durability — guarantees a database transaction system provides.
- **API (Application Programming Interface)** — A contract that lets two pieces of software communicate.
- **Asynchronous programming** — Code that can start a long-running operation and continue other work before it finishes.

## B

- **Big O notation** — Describes how an algorithm's runtime or memory grows as input size grows, in the worst case.
- **Big-endian / Little-endian** — Byte ordering for multi-byte values in memory.

## C

- **Closure** — A function that retains access to variables from its enclosing scope even after that scope has exited.
- **Compiler** — Translates source code into another form (often machine code) before execution.
- **Concurrency** — Structuring a program so multiple tasks can make progress during overlapping time periods (not necessarily simultaneously).
- **CRUD** — Create, Read, Update, Delete — the four basic data operations.

## D

- **DRY (Don't Repeat Yourself)** — A principle against duplicating logic.
- **Dependency Injection** — Supplying an object's dependencies from outside rather than having it construct them itself.

## E

- **Encapsulation** — Bundling data and the methods that operate on it, restricting direct access to internal state.
- **Eventual consistency** — A distributed-systems guarantee that replicas will converge to the same value, given enough time without new updates.

## G

- **Garbage collection** — Automatic reclamation of memory no longer reachable by the program.

## H

- **Hoisting** — JavaScript behavior where variable/function declarations are conceptually moved to the top of their scope.
- **Higher-order function** — A function that takes another function as an argument or returns one.

## I

- **Idempotency** — A request that can be made multiple times without changing the result beyond the first successful call.
- **Interpreter** — Executes source code directly, without a separate compilation step to machine code.
- **Inversion of Control** — A design where the framework/container calls your code, rather than your code calling the framework.

## J

- **JWT (JSON Web Token)** — A compact, signed token format commonly used for stateless authentication.

## M

- **Mutability** — Whether a value can be changed after creation.
- **Microservices** — An architectural style where an application is composed of small, independently deployable services.

## N

- **Normalization** — Organizing relational database tables to reduce redundancy.

## O

- **ORM (Object-Relational Mapper)** — A library that maps database rows to objects in application code.
- **OWASP Top 10** — The most critical web application security risks, as tracked by the Open Worldwide Application Security Project.

## P

- **Polymorphism** — The ability of different types to be used through the same interface.
- **Pure function** — A function whose output depends only on its inputs and that has no observable side effects.

## R

- **Race condition** — A bug caused by the timing/order of concurrent operations being non-deterministic.
- **REST (Representational State Transfer)** — An architectural style for APIs built around resources and standard HTTP verbs.
- **Recursion** — A function that calls itself to solve smaller instances of the same problem.

## S

- **Scope** — The region of code where a variable name is valid/accessible.
- **SOLID** — Five object-oriented design principles: Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion.
- **Serialization** — Converting an in-memory data structure into a storable/transmittable format (e.g., JSON).

## T

- **Type system** — The rules a language uses to classify values and check operations on them (static/dynamic, strong/weak).
- **Thread** — An independent sequence of execution within a process.

## Y

- **YAGNI (You Aren't Gonna Need It)** — A principle against building functionality before it's actually needed.

---

Terms are added as new modules are built. See [BUILD_STATUS.md](BUILD_STATUS.md) for current coverage.
