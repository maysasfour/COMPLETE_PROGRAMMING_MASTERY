# 18 — DevOps and Cloud

[Back to repository root](../README.md)

## What This Module Covers

Continuous Integration/Delivery, Infrastructure as Code, reverse proxying and load balancing, monitoring, and cloud fundamentals — **built entirely without Docker**. Docker Desktop is installed on this development machine but its backend would not start correctly (diagnosed root cause: a misconfigured Windows-containers-mode setting that a `DockerCli.exe -SwitchDaemon` + restart did not fix); rather than leave this module unbuilt indefinitely, every lesson here was deliberately chosen to be genuinely runnable with native, non-containerized tools instead — real standalone binaries for nginx, Prometheus, and Terraform, run directly on Windows.

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [CI/CD with GitHub Actions](01-CI-CD-with-GitHub-Actions/README.md) | A real GitHub Actions workflow (build matrix, dependency caching, artifact upload) for a genuine Maven/JUnit project — validated locally with `actionlint`, including a deliberately broken example it genuinely catches. |
| 02 | [Infrastructure as Code with Terraform](02-Infrastructure-as-Code-with-Terraform/README.md) | The full `init`/`plan`/`apply`/`destroy` lifecycle against Terraform's `local`/`random` providers — real files created and destroyed on disk, no cloud account needed. |
| 03 | [Reverse Proxy and Load Balancing with Nginx](03-Reverse-Proxy-and-Load-Balancing-with-Nginx/README.md) | A real nginx instance load-balancing across three real backend processes, with a genuine failover proof — one backend's OS process is killed mid-demo, and traffic transparently continues via the survivors. |
| 04 | [Monitoring with Prometheus](04-Monitoring-with-Prometheus/README.md) | A hand-instrumented `/metrics` endpoint (Prometheus's own text exposition format, written by hand rather than via a library, to make the format concrete), scraped by a real Prometheus instance, queried live via PromQL — including a genuine histogram bug found and fixed along the way. |
| 05 | [Cloud Fundamentals](05-Cloud-Fundamentals/README.md) | IaaS/PaaS/SaaS, major provider service equivalents, scaling, the shared responsibility model, and cost models — conceptual by necessity (no real cloud account used), cross-referencing the real local demos in Lessons 01–04 and this repository's CAP-theorem lessons for the underlying mechanics. |

## Why No Docker

Documented in detail in `BUILD_STATUS.md`: Docker Desktop's backend would not start on this machine, diagnosed as a `settings-store.json` misconfiguration (`UseWindowsContainers: true`) that survived a daemon-switch attempt and a full restart. Rather than block this entire module on that single tool, every lesson was chosen specifically because it has a genuine, real, non-containerized way to run: nginx, Prometheus, and Terraform all ship as plain standalone binaries; GitHub Actions workflows can be structurally and semantically validated with `actionlint` without needing to actually run them (running them for real would mean pushing to this repository's real GitHub remote, which requires the user's explicit sign-off — declined in favor of local-only verification this session).

## Verification Discipline

Every lesson's tools were genuinely downloaded, installed, and run on this machine — not simulated:

- `actionlint.exe`, `terraform.exe`, `nginx.exe`, and `prometheus.exe` were all downloaded as standalone Windows binaries and actually executed.
- Lesson 02's Terraform `apply` created a real file on disk, and `destroy` was verified (via a directory listing afterward, not just Terraform's own success message) to have genuinely removed it.
- Lesson 03's failover claim was proven by actually killing a real backend process with `taskkill` mid-demo and confirming client requests kept succeeding — not asserted from reading the nginx config alone.
- Lesson 04 found and fixed a real bug in its own hand-rolled histogram logic, caught by comparing curled `/metrics` output against the actual number of requests sent, before ever pointing Prometheus at it.

**Previous module:** [17-Git-and-GitHub](../17-Git-and-GitHub/README.md)
**Next module:** [19-Command-Line-and-Operating-Systems](../19-Command-Line-and-Operating-Systems/README.md)
