# 01 — CI/CD with GitHub Actions

[Back to 18-DevOps-and-Cloud](../README.md)

## What This Lesson Covers

- **What CI/CD actually is**: automatically building and testing every push/PR (Continuous Integration), and — in a fuller pipeline than this lesson builds — automatically deploying a change that passes (Continuous Deployment/Delivery). This lesson focuses on the CI half, since that's the part verifiable without needing a real deployment target.
- **A real GitHub Actions workflow** (`.github/workflows/ci.yml`) for a genuine Maven/JUnit 5 project: triggers on `push`/`pull_request` to `main`, a build **matrix** running the same job once per JDK version (17 and 21) so a version-specific regression is actually caught, dependency **caching** keyed on `pom.xml` to avoid re-downloading the entire Maven repository on every run, and an `if: always()` artifact upload so test reports are inspectable even when the job fails.
- **Validating a workflow without needing to push it**: `actionlint` (a real static analyzer for GitHub Actions YAML, run entirely locally, no Docker or GitHub account needed) parses the workflow, checks its schema, and — critically — type-checks `${{ }}` expressions against the actual context available at that point (job outputs, matrix values, etc.).

## Verification Scope (Read Before Trusting the Rest of This Lesson)

This lesson's workflow was **not** pushed to GitHub to trigger a real, GitHub-hosted Actions run — that would modify this repository's real, shared GitHub remote, which requires the user's explicit sign-off (asked for and declined in favor of local-only verification during this session). Instead, verification here is genuinely thorough but entirely local:

1. `actionlint` validates the workflow's structure and expression types.
2. The exact command the workflow runs (`mvn --batch-mode --no-transfer-progress test`) was run directly on this machine against the same `sample-app/` project, with real, captured output.

This is an honest, disclosed boundary, not a claim that the workflow has been proven to run correctly *on GitHub's actual runners* — only that its YAML is valid and its underlying commands genuinely work.

## A Real Mistake, Caught by `actionlint`

[`broken-example/ci-broken.yml`](broken-example/ci-broken.yml) is a deliberately introduced typo: `${{ matrix.java-versoin }}` instead of `java-version`. This is exactly the kind of mistake that would otherwise silently produce an empty/wrong value at runtime, since GitHub Actions expressions don't error on referencing an undefined property — they just evaluate to nothing. `actionlint` catches it as a real type error:

```
$ actionlint broken-example/ci-broken.yml
broken-example\ci-broken.yml:16:29: property "java-versoin" is not defined in object type {java-version: number} [expression]
   |
16 |           java-version: ${{ matrix.java-versoin }}
   |                             ^~~~~~~~~~~~~~~~~~~
```

The real, fixed workflow at `.github/workflows/ci.yml` passes with no output at all (a clean exit code `0` from a linter is itself the "all good" signal — no news is good news):

```
$ actionlint .github/workflows/ci.yml
$ echo $?
0
```

## Files

- [`.github/workflows/ci.yml`](.github/workflows/ci.yml) — the real, valid workflow.
- [`broken-example/ci-broken.yml`](broken-example/ci-broken.yml) — the deliberately broken version, kept side-by-side for comparison.
- [`sample-app/`](sample-app/) — a minimal Maven + JUnit 5 project (`Calculator`, 3 tests) that the workflow builds and tests.

## How to Run

```bash
# Validate the workflow (no Docker, no GitHub account needed):
cd 18-DevOps-and-Cloud/01-CI-CD-with-GitHub-Actions
actionlint .github/workflows/ci.yml

# Run the exact command the workflow itself runs:
cd sample-app
mvn test
```

(`actionlint.exe` was downloaded as a standalone binary from its GitHub releases — no installation, no Docker, no Go toolchain needed.)

## Verified Behavior (Real Output)

```
$ mvn test
[INFO] Running com.example.calculator.CalculatorTest
[INFO] Tests run: 3, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.100 s
[INFO] BUILD SUCCESS
```

## Suggested Improvements / Next Steps

A real deployment stage (e.g., pushing a built artifact somewhere, or running against an actual cloud target) is the natural extension once a target environment exists — see [05-Cloud-Fundamentals](../05-Cloud-Fundamentals/README.md) for the conceptual groundwork this repository covers instead of assuming access to a real paid cloud account.

Continue to [02-Infrastructure-as-Code-with-Terraform](../02-Infrastructure-as-Code-with-Terraform/README.md) — real, runnable Terraform, executed genuinely locally against Terraform's `local` provider (no cloud account or Docker required).

**Next lesson:** [02-Infrastructure-as-Code-with-Terraform](../02-Infrastructure-as-Code-with-Terraform/README.md)
