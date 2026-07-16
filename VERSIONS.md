# Versions

This repository assumes the following stable, current versions at time of writing (2026). When a language or tool has a feature that differs meaningfully between versions, the relevant lesson calls it out explicitly.

| Technology | Version Assumed | Notes |
|---|---|---|
| Python | 3.12+ | Uses `match` statements, modern type hints (`list[int]` not `List[int]`) |
| Node.js | 20 LTS+ | ES2022+ syntax, native `fetch` |
| TypeScript | 5.x | |
| JavaScript | ES2022+ | |
| Java | 21 LTS | Records, pattern matching, virtual threads noted where relevant |
| C# | 12 / .NET 8 | |
| Go | 1.22+ | |
| Rust | 1.75+ (2021 edition) | |
| Kotlin | 1.9+ | |
| Swift | 5.9+ | |
| PHP | 8.3+ | |
| Ruby | 3.3+ | |
| Dart / Flutter | Dart 3.x / Flutter 3.19+ | Null safety assumed everywhere |
| React | 18.x | Function components + hooks only, no class components taught as primary |
| Next.js | 14.x (App Router) | |
| Angular | 17+ | Standalone components |
| Vue | 3.x (Composition API) | |
| PostgreSQL | 16.x | |
| MySQL | 8.x | |
| MongoDB | 7.x | |
| Docker | 24.x+ / Compose v2 | `docker compose`, not `docker-compose` |
| Git | 2.4x+ | |
| Git default branch | `main` | |

## General Rules Followed Throughout

- No hardcoded secrets anywhere in this repository. Look for `.env.example` files.
- Package manager commands shown for Windows, macOS, and Linux where they differ.
- Deprecated/obsolete syntax (e.g., Python 2, JavaScript `var`-first style, class components as the primary React teaching model) is avoided as the primary teaching example, though sometimes mentioned for historical context.

Last updated: 2026-07-14.
