# 01 — Setup

[Back to course overview](../README.md)

## What Is R, Practically Speaking

R is a language and environment built specifically for **statistical computing and data analysis**. Unlike Python or JavaScript, R was never designed as a general-purpose language first — everything about it (vectors as the base type, data frames as a first-class citizen, 1-based indexing matching mathematical/statistical convention) reflects its origin as a tool for statisticians (it's a free, open-source reimplementation of the older commercial language S).

## Ways to Run R

1. **`Rscript`** — runs a `.R` file non-interactively from the command line, like `python file.py`. This is what every example in this course uses.
   ```bash
   Rscript example.R
   ```
2. **The interactive R console** — launched by running `R` at a terminal. You get a `>` prompt and evaluate expressions one at a time, seeing results immediately (similar to Python's REPL).
3. **RStudio** — the dominant IDE for R (free, from Posit). It is not required — everything in this course runs from plain `Rscript` — but in real-world data science work almost everyone uses RStudio for its integrated console, plotting pane, and data viewer. We mention it here for completeness but do not depend on it.

## Installing R

### Windows
Download the installer from [CRAN](https://cran.r-project.org/bin/windows/base/) and run it. It does **not** require admin rights if you choose a per-user install directory during setup (or run silently with `/CURRENTUSER /DIR=<path>`).

### macOS
```bash
brew install r
```

### Linux (Debian/Ubuntu)
```bash
sudo apt update && sudo apt install r-base
```

### Verify the install
```bash
R --version
Rscript --version
```

**This course was built and verified against R 4.6.1** (installed in a non-system, per-user directory with no admin rights required — CRAN's Windows installer supports `/CURRENTUSER` mode for exactly this scenario).

## Installing Packages: `install.packages()`

R's package ecosystem is CRAN (Comprehensive R Archive Network). From an R console or script:

```r
install.packages("jsonlite")   # downloads, compiles/unpacks, and installs from CRAN
library(jsonlite)              # loads it into the current session
```

Packages used later in this course (`jsonlite`, `RSQLite`, `httr`, `testthat`) were all installed this way against live CRAN during the build of this course, into a custom (non-system) library path — see Lesson 15 for details on library paths.

## How to Run the Examples

Every lesson folder has a `README.md` and a runnable `example.R`:

```bash
cd 01-Languages/R/03-Variables-and-Data-Types
Rscript example.R
```

Lessons with `Exercises/` and `Solutions/` work the same way:

```bash
Rscript Solutions/solution-01.R
```

## Common Beginner Mistakes

- Expecting `=` and `<-` to be identical in every context — they're *almost* always interchangeable for assignment, but `<-` is the idiomatic choice and behaves differently inside function-call argument lists (Lesson 02).
- Assuming R indexes from 0 like most languages — R vectors and lists are **1-indexed** (Lesson 05).
- Forgetting that a single number in R is actually a length-1 vector, not a distinct "scalar" type (Lesson 03).
- Not realizing `install.packages()` needs a writable library directory — on locked-down systems this can silently fail or prompt to create a personal library.

## Best Practices

- Use `<-` for assignment, reserving `=` for named function arguments — this is close to universal R style.
- Keep a project-local working directory mindset; use `here::here()` or relative paths rather than hardcoded absolute paths in real projects.
- Check `sessionInfo()` when debugging package/version issues — it prints R version, platform, and loaded package versions.

## Interview Questions

1. **What's the difference between running `R` and `Rscript`?**
   `R` launches an interactive REPL/console; `Rscript` runs a `.R` file non-interactively start-to-finish, the way `python file.py` does, and is what's used for scripts, cron jobs, and automated pipelines.

2. **What is CRAN?**
   The Comprehensive R Archive Network — R's central package repository, analogous to PyPI for Python or npm for JavaScript. `install.packages()` downloads from CRAN by default.

3. **Do you need RStudio to use R?**
   No. RStudio is a popular IDE that adds a console, plotting pane, and data viewer, but R itself is just a language/runtime — `Rscript` and the base `R` console work with nothing else installed.

## Table of Contents

See the [course README](../README.md) for the full lesson list.

## Suggested Next Lesson

[02 — Syntax](../02-Syntax/README.md)
