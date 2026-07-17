# Skill Assessment

Referenced by [STUDY_PLAN.md](STUDY_PLAN.md) as the tool for identifying weak areas before the final "polish and apply" stretch of any study plan. This is not a test with a score to submit anywhere — it's a self-honesty checkpoint. Answer each question from memory, without looking anything up, then check yourself against the linked lesson. If you can't answer a question without checking, that's real signal: the topic needs another pass, not a rationalization.

## Table of Contents

- [How to Use This](#how-to-use-this)
- [Part 1 — Self-Assessment Questions](#part-1--self-assessment-questions)
- [Part 2 — Practical Tests](#part-2--practical-tests)
- [Scoring Yourself Honestly](#scoring-yourself-honestly)
- [What To Do With the Result](#what-to-do-with-the-result)

## How to Use This

1. Pick a section below (or do all of them if you're at the Month 12 "polish" stage of the [one-year plan](STUDY_PLAN.md)).
2. Answer every question out loud or in writing, in your own words, before checking the linked lesson.
3. For each question, mark: **Solid** (could explain this to someone else and defend it under follow-up questions), **Shaky** (got the gist but couldn't defend an edge case), or **Gap** (didn't know, or got it wrong).
4. Anything marked Shaky or Gap goes back into your rotation — revisit that lesson's README, re-run its `example`/`implementation` file yourself, and redo its exercises before moving on.
5. Do the Part 2 practical tests without any reference material open. They mirror what a real technical interview or a real production bug actually demands — recall under mild pressure, not recognition with the answer in front of you.

## Part 1 — Self-Assessment Questions

Each question links to the specific lesson that answers it — every one of these was built and verified with real, executed code in this repository, not just described in prose.

### Programming Fundamentals

1. What's the actual difference between a compiler and an interpreter, and where does Python's `.pyc` bytecode fit? — [00-Programming-Fundamentals/01](00-Programming-Fundamentals/01-How-Computers-Run-Programs/README.md)
2. Why does `0.1 + 0.2 != 0.3` in nearly every language? — [00-Programming-Fundamentals/02](00-Programming-Fundamentals/02-Variables-and-Types/README.md)
3. What's on the stack vs. the heap, and why does that matter for recursion depth? — [00-Programming-Fundamentals/05](00-Programming-Fundamentals/05-Memory-Concepts/README.md)
4. What's a closure, concretely — not the definition, but what value does it actually capture and when? — [00-Programming-Fundamentals/04](00-Programming-Fundamentals/04-Functions-and-Scope/README.md)
5. Why is catching a bare `except:`/generic exception usually a mistake? — [00-Programming-Fundamentals/06](00-Programming-Fundamentals/06-Error-Handling/README.md)

### Object-Oriented Programming

6. Give a real example of a Liskov Substitution violation, not just the definition. — [11-Design-Principles/01](11-Design-Principles/01-SOLID-Principles/README.md), [09-Object-Oriented-Programming/05](09-Object-Oriented-Programming/05-Polymorphism/README.md)
7. When is composition the correct choice over inheritance, concretely? — [09-Object-Oriented-Programming/06](09-Object-Oriented-Programming/06-Composition-vs-Inheritance/README.md)
8. What's the actual mechanical difference between an interface and an abstract class in a language that has both? — [09-Object-Oriented-Programming/07](09-Object-Oriented-Programming/07-Interfaces-and-Abstract-Classes/README.md)

### Data Structures and Algorithms

9. Why does inserting 1000 already-sorted values into a naive BST produce a structure with height ~999 instead of ~10? — [08-Data-Structures-and-Algorithms/09](08-Data-Structures-and-Algorithms/09-Trees-and-Binary-Search-Trees/README.md)
10. Walk through why greedy coin-change gives a wrong answer for the coin set `[1, 3, 4]` and amount 6. — [08-Data-Structures-and-Algorithms/13](08-Data-Structures-and-Algorithms/13-Greedy-Algorithms/README.md)
11. What's the actual time/space tradeoff between the naive, memoized, and tabulated versions of the same DP problem? — [08-Data-Structures-and-Algorithms/12](08-Data-Structures-and-Algorithms/12-Dynamic-Programming/README.md)
12. When would you reach for a heap over a sorted array for a priority queue? — [08-Data-Structures-and-Algorithms/10](08-Data-Structures-and-Algorithms/10-Heaps-and-Priority-Queues/README.md)

### Databases and SQL

13. Name all four ACID properties and describe a concrete failure each one prevents. — [07-Databases/03](07-Databases/03-Transactions-and-ACID/README.md)
14. What's the N+1 query problem, and how does `JOIN FETCH`/eager loading fix it? — [07-Databases/05](07-Databases/05-Using-an-ORM/README.md)
15. Why did adding an index turn a 73ms query into a 1ms query — what changed in the execution plan? — [07-Databases/04](07-Databases/04-Indexes-and-Query-Optimization/README.md)

### Web Development

16. What HTTP status code should a non-idempotent retry actually return, and how do you make a `POST` idempotent? — [14-APIs-and-Integrations/01](14-APIs-and-Integrations/01-HTTP-Fundamentals/README.md)
17. Why does an unauthenticated request often return `403` instead of the commonly-assumed `401`? — [04-Backend-Development/04](04-Backend-Development/04-Authentication-and-Authorization/README.md)
18. Why is a `useEffect` cleanup function's timing important, and how would you prove it actually ran? — [03-Frontend-Development/03](03-Frontend-Development/03-State-and-Hooks/README.md)

### System Design

19. Walk through the CAP theorem with a real example — what does a system choosing CP do differently from one choosing AP during a network partition? — [20-Computer-Science-Fundamentals/04](20-Computer-Science-Fundamentals/04-CAP-Theorem-and-Distributed-Systems/README.md), [22-Projects/Advanced](22-Projects/Advanced/)
20. What's the difference between horizontal and vertical scaling, and when does each stop working? — [18-DevOps-and-Cloud/05](18-DevOps-and-Cloud/05-Cloud-Fundamentals/README.md)

### Security

21. Explain, mechanically, why a `PreparedStatement` stops SQL injection when string concatenation doesn't. — [16-Security/01](16-Security/01-SQL-Injection/README.md)
22. Why is MD5 unsuitable for password storage even though it's "just a hash," and what does PBKDF2/bcrypt/Argon2 do differently? — [16-Security/02](16-Security/02-Secure-Password-Storage/README.md)

### Behavioral

23. Prepare one real story using the STAR method for: a conflict with a teammate, a mistake you made and how you recovered, and a time you had to learn something under a deadline. — [21-Interview-Preparation/07](21-Interview-Preparation/07-Behavioral-Questions.md)

## Part 2 — Practical Tests

Do these without notes. Each one is scoped to something this repository actually built, ran, and verified — so a real, checkable answer exists.

1. **From memory, write** a function that reverses a singly linked list, then check it against [08-Data-Structures-and-Algorithms/03-Linked-Lists](08-Data-Structures-and-Algorithms/03-Linked-Lists/implementation.py).
2. **From memory, write** the SOLID-violating "Rectangle/Square" Liskov example and its fix, then check against [11-Design-Principles/01](11-Design-Principles/01-SOLID-Principles/).
3. **Design a REST API** for a library system (endpoints, status codes, request/response shapes) before looking, then compare against the real, running one in [22-Projects/Intermediate/Library-Management-System](22-Projects/Intermediate/).
4. **Write a SQL query** with a `JOIN` and a `GROUP BY` against a two-table schema you invent, then compare your instinct against [07-Databases/01-SQL-Fundamentals](07-Databases/01-SQL-Fundamentals/README.md).
5. **Trace by hand** what happens when two threads increment an unsynchronized shared counter 100,000 times each — predict the final value's *range*, not the exact number — then compare your prediction against the real measured runs in [20-Computer-Science-Fundamentals/03-OS-Fundamentals](20-Computer-Science-Fundamentals/03-OS-Fundamentals/README.md).
6. **Pick any two languages** you've studied in [01-Languages](01-Languages/) and write, from memory, how each one handles null/absence (e.g. Python's `None`, Java's `null`, Rust's `Option<T>`, Kotlin's `String?`) — then check your answer against both courses' Lesson 03.

## Scoring Yourself Honestly

There's no numeric score here on purpose — a percentage invites gaming the assessment instead of using it. Instead:

- **Mostly Solid across a section** → move on to the next module in [ROADMAP.md](ROADMAP.md).
- **A mix of Shaky and Gap in a section** → don't move on yet. Re-read that module's lessons, and — this matters more than re-reading — actually re-run the example/implementation code yourself and redo its exercises. Every lesson in this repository was built around runnable, verified code specifically so "I re-read it" and "I re-ran it and it worked the way I predicted" are different, checkable things.
- **Gaps concentrated in one whole module** (e.g. all of Databases) rather than scattered → that's a signal to slow down and spend a full extra week there before continuing, not to push through.

## What To Do With the Result

Update [PROGRESS_TRACKER.md](PROGRESS_TRACKER.md) honestly — don't check off a topic in the tracker just because the folder exists and you skimmed it once. The tracker and this assessment are only useful to you if they reflect what you actually know, not what you've merely opened.

**Next:** if this assessment went well across the board, move to [21-Interview-Preparation](21-Interview-Preparation/) for full mock-interview-style practice. If it surfaced real gaps, go back to [ROADMAP.md](ROADMAP.md) and re-enter at the phase containing your weakest section.
