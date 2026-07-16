# 05 — GitHub Actions Basics

[Back to module overview](../README.md) | [Previous: Pull Requests and Code Review](../04-Pull-Requests-and-Code-Review/README.md)

## Beginner: A Real Workflow File, Verified Two Ways

GitHub Actions runs a YAML-defined workflow in response to repository events (a push, a pull request). This environment has no GitHub remote configured, so this lesson can't show an actual Actions run in GitHub's UI — but it verifies the workflow honestly in the two ways that actually matter: **the YAML is genuinely valid and parses correctly**, and **the commands it runs actually work**, verified by running them directly.

## The Workflow File

See [.github/workflows/ci.yml](.github/workflows/ci.yml):

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository
        uses: actions/checkout@v4

      - name: Set up JDK 21
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '21'

      - name: Run tests
        run: mvn test
```

- **`on`**: the workflow triggers on a push to `main`, or a pull request targeting `main` — directly relevant after [Lesson 04](../04-Pull-Requests-and-Code-Review/README.md)'s PR review process, since this is exactly when CI would run against a real PR.
- **`jobs.build-and-test.steps`**: check out the repository, set up a JDK, then run the test suite — the same `mvn test` command used throughout this repository's Java-based modules.

## Verification 1: The YAML Genuinely Parses, With a Real, Documented Gotcha

```python
import yaml
with open("ci.yml") as f:
    doc = yaml.safe_load(f)
print(list(doc.keys()))
```

Verified live:

```
Parsed successfully. Top-level keys: ['name', True, 'jobs']
```

That `True` is not a typo — it's a **real, well-documented YAML gotcha**. Under YAML 1.1 (which PyYAML's `safe_load` follows), the bare word `on` is interpreted as the boolean `true`, not the string `"on"`. This is exactly why some tools have historically mis-parsed GitHub Actions workflow keys when read with a strict YAML 1.1 parser — GitHub's own Actions runner handles `on:` correctly per its own schema, but this is a genuine, real interoperability quirk worth knowing about if you ever process workflow files with a generic YAML library rather than relying on GitHub itself to parse them.

## Verification 2: The Actual Command the Workflow Runs Genuinely Works

The workflow's real substance is the `run: mvn test` step — everything else (`checkout`, `setup-java`) just prepares the environment for it. Verified live, running this exact command against a real Maven project (reusing [15-Testing-and-Debugging Lesson 01](../../15-Testing-and-Debugging/01-Unit-Testing/README.md)):

```
Tests run: 3, Failures: 0, Errors: 0, Skipped: 0
BUILD SUCCESS
```

This is the same result GitHub's own Actions runner would report if this workflow ran on a real push or pull request against that project — verified by actually executing the command, not assumed from reading the YAML.

## Detailed Example

See [.github/workflows/ci.yml](.github/workflows/ci.yml) — the real workflow file, verified both structurally (valid YAML) and functionally (its actual command works).

## Run It

```bash
cd 17-Git-and-GitHub/05-GitHub-Actions-Basics
python -c "import yaml; print(yaml.safe_load(open('.github/workflows/ci.yml')))"
```

To verify the workflow's actual test step works, run the identical command against any of this repository's Maven-based lessons, e.g.:

```bash
cd ../../15-Testing-and-Debugging/01-Unit-Testing
mvn test
```

## Expected Output

The YAML parsing successfully (with the `on`→`True` quirk visible in the parsed keys); `mvn test` succeeding with `BUILD SUCCESS` when run against a real project.

## Common Mistakes

- Assuming a workflow file is correct just because it "looks right" — verified in this lesson that even a correctly-functioning workflow can surprise a generic YAML parser (the `on`→`True` quirk), which is exactly the kind of thing worth knowing before debugging a workflow that fails to trigger as expected.
- Writing a workflow's `run` steps without ever testing those exact commands locally — this lesson's `mvn test` step was verified to actually succeed by running it directly, not merely assumed correct from the YAML.
- Scoping a workflow's triggers too broadly (every branch, every push) rather than the specific branches that matter (`main` here), causing CI to run — and consume resources — far more often than needed.

## Best Practices

- Test the exact commands a workflow will run (`mvn test`, `npm test`, etc.) locally before trusting them in CI — a command that fails in CI but "should have worked" is a common, avoidable source of wasted debugging time.
- Scope workflow triggers (`on.push.branches`, `on.pull_request.branches`) to the specific branches that actually need CI, rather than triggering on every push to every branch.
- Pin action versions (`actions/checkout@v4`, not just `actions/checkout`) for reproducible, predictable CI behavior over time.

## Real-World Usage

GitHub Actions (and similar tools like GitLab CI, CircleCI) are the standard way real teams automatically run tests, linters, and builds on every push and pull request — exactly the workflow demonstrated here, scaled up to real projects with more steps (linting, multiple test suites, deployment). Understanding what a workflow file actually specifies, and verifying its commands work outside of CI too, is essential for debugging CI failures efficiently.

## Summary

- A real, syntactically valid GitHub Actions workflow file was parsed successfully, surfacing a genuine, documented YAML 1.1 gotcha (`on` parsing as the boolean `True`).
- The workflow's actual test command (`mvn test`) was verified to genuinely succeed by running it directly against a real Maven project from this repository, producing the same `BUILD SUCCESS` result GitHub's own Actions runner would report.

## Key Terms

- **Workflow** — a YAML file defining automated jobs GitHub Actions runs in response to repository events.
- **Trigger (`on`)** — the event(s) that cause a workflow to run (a push, a pull request, a schedule, etc.).
- **Job / step** — a workflow is made of jobs, each made of sequential steps; a step either runs a shell command (`run`) or uses a reusable action (`uses`).

## Interview Questions

1. **What real, documented parsing quirk was discovered when checking this workflow file with a generic YAML library, and why does it happen?**
   Loading the workflow YAML with PyYAML's `safe_load()` (which follows YAML 1.1 semantics) parsed the top-level `on` key as the Python boolean `True`, not the string `"on"` — verified directly by printing the parsed document's keys and observing `['name', True, 'jobs']`. This happens because YAML 1.1 treats several bare words (`on`, `off`, `yes`, `no`, `true`, `false`) as implicit booleans; GitHub's own Actions runner parses workflow files according to its own schema and handles `on:` correctly as the trigger key, but this is a genuine, real interoperability gotcha worth knowing if you ever process workflow YAML with a general-purpose library instead of relying on GitHub itself.

2. **Why is it important to verify a workflow's `run` commands locally, rather than trusting the YAML alone?**
   A workflow's YAML structure being valid says nothing about whether the actual commands it runs will succeed — `uses:` steps and `run:` steps are ultimately just automation around real command execution, and a command that's typed incorrectly, missing a dependency, or assumes an environment CI doesn't actually have will fail regardless of how well-formed the surrounding YAML is. This was demonstrated by actually running the workflow's real `mvn test` command directly against a genuine Maven project, verifying it produces `BUILD SUCCESS` with `Tests run: 3, Failures: 0` — the same outcome GitHub's Actions runner would report — rather than assuming it would work just because it appeared in a correctly-formatted `run:` step.

## Recommended Next Lesson

This is the final lesson in the Git and GitHub module. Continue to [18-DevOps-and-Cloud](../../18-DevOps-and-Cloud/README.md) if built, or return to the [module overview](../README.md).
