# Contributing

This repository is meant to grow module by module. If you (or future-you) are extending it, follow these rules to keep quality consistent.

## Ground Rules

1. **No empty files.** Every file must contain real, useful content — not a "TODO" placeholder.
2. **Follow the standard lesson structure**: Beginner → Intermediate → Advanced → Real-world usage → Exercises → Solutions → Mini-project → Interview questions.
3. **Every README needs**: what/why/where it's used, advantages, disadvantages, install instructions, how to run examples, common beginner mistakes, best practices, interview questions, and a table of contents.
4. **Comments explain intent, not syntax.** Never write `// increment i`. Explain *why*, not *what* (the code already says what).
5. **Keep exercises and solutions separate** — exercises live in an `Exercises/` folder, solutions in a matching `Solutions/` folder.
6. **No real secrets.** Use `.env.example` files with placeholder values and explain secret management in prose.
7. **Update [BUILD_STATUS.md](BUILD_STATUS.md)** after finishing any folder — mark it complete, list what was tested, and note any known limitations.
8. **Prefer fewer, complete files over many empty ones.**

## Adding a New Language Course

Copy the folder structure from [01-Languages/Python](01-Languages/Python/) and adapt section names for language features that don't map 1:1 (e.g., a language without generics should say so explicitly rather than leaving the folder empty).

## Adding a New Project

Follow the project template used in [22-Projects/Beginner/Task-Management-CRUD](22-Projects/Beginner/Task-Management-CRUD/): requirements, architecture, ER diagram (Mermaid), API endpoints, step-by-step implementation, working solution, and a testing plan.

## Style

- Markdown: ATX headings (`#`), fenced code blocks with language tags, tables for comparisons.
- Code: consistent naming conventions per language (see each language's `19-Best-Practices` folder), meaningful names, no dead code.
- Diagrams: Mermaid syntax only, and verify it renders before committing.

## Checklist Before Marking a Module Complete

See [Section 37 of the original brief, mirrored here] — before marking any section done:

- [ ] Files are not empty
- [ ] Code compiles/runs where applicable
- [ ] Commands and paths are correct
- [ ] Internal links resolve
- [ ] Mermaid diagrams are valid
- [ ] Exercises have matching solutions
- [ ] No secrets or real credentials
- [ ] Every topic has more than just a title
