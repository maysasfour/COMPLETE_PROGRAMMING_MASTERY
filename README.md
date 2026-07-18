# Complete Programming Mastery

A single, self-contained repository that acts as a full software-development course, syntax reference, hands-on practice environment, and interview-preparation resource — from your first `print("Hello, World")` to shipping a deployed, tested, multi-service application.

> **Status:** This is a living repository. See [BUILD_STATUS.md](BUILD_STATUS.md) for exactly which modules are fully built out versus scaffolded. New material is added module-by-module; nothing here pretends to be finished when it isn't.

## Table of Contents

- [Purpose](#purpose)
- [Who This Is For](#who-this-is-for)
- [Prerequisites](#prerequisites)
- [How To Use This Repository](#how-to-use-this-repository)
- [Recommended Learning Path](#recommended-learning-path)
- [Repository Structure](#repository-structure)
- [Technology Coverage](#technology-coverage)
- [Study Plans](#study-plans)
- [Progress Tracking](#progress-tracking)
- [Projects](#projects)
- [Interview Preparation](#interview-preparation)
- [Contributing](#contributing)
- [Disclaimer](#disclaimer)

## Purpose

This repository exists to be **one place** that covers:

- Programming fundamentals and computer-science theory
- Multiple programming languages, taught with the same structure so they're easy to compare
- Frontend, backend, mobile, and desktop development
- Databases (relational and NoSQL) and SQL
- Data structures and algorithms with complexity analysis
- Object-oriented and functional programming
- Software design principles, design patterns, and architecture
- APIs, authentication, and third-party integrations
- Testing, debugging, and secure coding
- Git, GitHub, Docker, CI/CD, and cloud deployment
- Realistic, portfolio-worthy projects
- Structured interview preparation

## Who This Is For

- Beginners who want a guided path from zero to job-ready.
- Intermediate developers who want to fill gaps or compare languages/frameworks.
- Anyone revising fast before an interview or a new job.
- Self-taught developers who want CS fundamentals they may have skipped.

## Prerequisites

- A computer running Windows, macOS, or Linux.
- Willingness to install language runtimes as you reach each module (each module's README has OS-specific install steps).
- A code editor (VS Code recommended) and Git installed — see [17-Git-and-GitHub](17-Git-and-GitHub/).

## How To Use This Repository

1. Start with [ROADMAP.md](ROADMAP.md) to see the recommended global order.
2. Pick a [STUDY_PLAN.md](STUDY_PLAN.md) duration that fits your schedule (30/60/90-day, 6-month, 1-year).
3. Work through a module top to bottom: **README → Beginner → Intermediate → Advanced → Real-world usage → Exercises → Solutions → Mini-project → Interview questions.**
4. Check off topics in [PROGRESS_TRACKER.md](PROGRESS_TRACKER.md) as you complete them.
5. Do the exercises **before** looking at solutions. Solutions live in a separate folder on purpose.
6. Use [23-Cheat-Sheets](23-Cheat-Sheets/) for fast syntax lookups once you already understand the concepts.
7. Use [21-Interview-Preparation](21-Interview-Preparation/) in the final stretch before interviews.

## Recommended Learning Path

```
00 Programming Fundamentals
        │
        ▼
01 Languages (pick one deeply, e.g. Python)
        │
        ▼
09 Object-Oriented Programming ──► 10 Functional Programming
        │
        ▼
08 Data Structures & Algorithms
        │
        ▼
02 Markup & Styling ──► 03 Frontend ──► 04 Backend ──► 07 Databases
        │
        ▼
14 APIs & Integrations ──► 11 Design Principles ──► 12 Design Patterns ──► 13 Architecture
        │
        ▼
15 Testing ──► 16 Security ──► 17 Git/GitHub ──► 18 DevOps & Cloud
        │
        ▼
22 Projects (build portfolio) ──► 21 Interview Preparation
```

Mobile (05) and Desktop (06) development branch off after you're comfortable with a core language and APIs.

## Repository Structure

```text
Complete-Programming-Mastery/
├── README.md                          This file
├── ROADMAP.md                         Recommended global study order
├── STUDY_PLAN.md                      30/60/90-day, 6-month, 1-year plans
├── PROGRESS_TRACKER.md                Checklist of every subject
├── TECHNOLOGY_COMPARISON.md           Head-to-head tech comparisons
├── INTERVIEW_PREPARATION.md           Index into 21-Interview-Preparation
├── GLOSSARY.md                        Definitions of key terms
├── VERSIONS.md                        Exact tool/language versions assumed
├── BUILD_STATUS.md                    What's done, in progress, remaining
├── CONTRIBUTING.md                    How to extend this repository
├── LICENSE
│
├── 00-Programming-Fundamentals/       How computers run programs, variables, control flow, memory...
├── 01-Languages/                      Python, JavaScript, TypeScript, Java, C#, Go, Rust, ...
├── 02-Markup-and-Styling/             HTML, CSS, JSON, YAML, Sass, Tailwind, ...
├── 03-Frontend-Development/           React, Next.js, Angular, Vue, ...
├── 04-Backend-Development/            Node/Express, Django, Spring Boot, ASP.NET Core, ...
├── 05-Mobile-Development/             Android/Kotlin, iOS/Swift, Flutter, React Native, ...
├── 06-Desktop-Development/            WPF, JavaFX, Electron, Tauri, ...
├── 07-Databases/                      SQL, PostgreSQL, MongoDB, ORMs, ...
├── 08-Data-Structures-and-Algorithms/ Complexity analysis, DS, algorithms, practice problems
├── 09-Object-Oriented-Programming/    Classes, inheritance, polymorphism, patterns of OOP
├── 10-Functional-Programming/         Pure functions, immutability, higher-order functions
├── 11-Design-Principles/              SOLID, DRY, KISS, YAGNI, ...
├── 12-Design-Patterns/                GoF creational/structural/behavioral + enterprise patterns
├── 13-Software-Architecture/          Layered, Clean, Hexagonal, Microservices, DDD, ...
├── 14-APIs-and-Integrations/          REST, GraphQL, auth, third-party integrations
├── 15-Testing-and-Debugging/          Unit/integration/e2e testing, TDD, debugging
├── 16-Security/                       OWASP Top 10, secure coding
├── 17-Git-and-GitHub/                 Git commands, branching, GitHub Actions
├── 18-DevOps-and-Cloud/               CI/CD, Terraform, nginx load balancing, Prometheus, cloud fundamentals (no Docker in this environment)
├── 19-Command-Line-and-Operating-Systems/  Bash, PowerShell, Linux, processes
├── 20-Computer-Science-Fundamentals/  Binary, networking, OS theory, distributed systems
├── 21-Interview-Preparation/          Categorized interview Q&A
├── 22-Projects/                       Beginner, intermediate, advanced guided projects
├── 23-Cheat-Sheets/                   One-page references per topic
├── 24-Exercises/                      Cross-cutting practice problems
└── 25-Solutions/                      Matching solutions, kept separate from exercises
```

## Technology Coverage

See [VERSIONS.md](VERSIONS.md) for the exact versions this repository assumes, and [TECHNOLOGY_COMPARISON.md](TECHNOLOGY_COMPARISON.md) for head-to-head guidance on choosing between them.

## Study Plans

See [STUDY_PLAN.md](STUDY_PLAN.md).

## Progress Tracking

See [PROGRESS_TRACKER.md](PROGRESS_TRACKER.md) — check items off as you complete them (edit the file and tick the Markdown checkboxes).

## Projects

See [22-Projects](22-Projects/) for beginner, intermediate, and advanced portfolio projects, including a Task Management CRUD app implemented across multiple stacks.

## Interview Preparation

See [21-Interview-Preparation](21-Interview-Preparation/) and [INTERVIEW_PREPARATION.md](INTERVIEW_PREPARATION.md).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Disclaimer

Software technology moves fast. Version numbers, APIs, and best practices in this repository reflect what was current at the time of writing (see [VERSIONS.md](VERSIONS.md)). Always cross-check against official documentation before relying on version-specific details in production.                                                                                                                                             


