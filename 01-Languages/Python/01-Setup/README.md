# 01 — Setup

[Back to course overview](../README.md)

## Beginner: Installing Python

Python is not pre-installed on Windows (macOS/Linux usually ship an old system Python you should *not* rely on for projects). Install a current version yourself:

- **Windows:** [python.org/downloads](https://www.python.org/downloads/) (check "Add python.exe to PATH") or `winget install Python.Python.3.12`.
- **macOS:** `brew install python@3.12`.
- **Linux:** `sudo apt install python3 python3-pip python3-venv` (Debian/Ubuntu) or your distro's package manager.

Verify:

```bash
python --version
pip --version
```

If `python` isn't found on macOS/Linux, try `python3` / `pip3` — some systems keep `python` reserved for a legacy Python 2 or don't alias it at all.

## Beginner: Running a Script

Save code in a `.py` file and run it with the interpreter:

```bash
python hello.py
```

You can also start an interactive **REPL** (Read-Eval-Print Loop) by running `python` with no arguments — useful for quick experiments, not for real programs.

## Intermediate: Virtual Environments

A **virtual environment** is an isolated Python installation for one project, so its dependencies don't collide with another project's (or the system's) dependencies. This is essential the moment you have more than one Python project on a machine — Project A needing `requests==2.28` and Project B needing `requests==2.31` is a routine conflict without isolation.

```bash
python -m venv .venv                  # create the environment in a .venv folder
.venv\Scripts\activate                # activate on Windows (PowerShell/cmd)
source .venv/bin/activate             # activate on macOS/Linux
python -m pip install requests        # installs into .venv, not globally
deactivate                            # leave the environment
```

While a venv is active, `python` and `pip` point at the isolated copies inside `.venv`, not your system Python. You'll see `(.venv)` prefixed in your shell prompt as a reminder.

## Intermediate: pip and requirements.txt

`pip` is Python's package installer, pulling from [PyPI](https://pypi.org/). Record dependencies in a `requirements.txt` file so a project is reproducible on another machine:

```bash
pip install requests pytest
pip freeze > requirements.txt          # snapshot exact installed versions
pip install -r requirements.txt        # recreate the environment elsewhere
```

(Lesson 15 covers `pyproject.toml`, the more modern packaging/dependency format, in more depth.)

## Advanced: Project Structure

A conventional small Python project looks like this:

```
my_project/
├── .venv/                  # virtual environment (never commit this)
├── src/                    # or a package folder named after the project
│   ├── __init__.py
│   └── main.py
├── tests/
│   └── test_main.py
├── requirements.txt
├── .gitignore               # must exclude .venv/, __pycache__/, *.pyc
└── README.md
```

Keeping source code separate from tests, and never committing the virtual environment (it's regenerable from `requirements.txt` and can be large), keeps the repository clean and portable.

## Real-World Usage

- Every professional Python project uses a virtual environment — running `pip install` globally on a shared machine is a fast route to broken, unreproducible environments.
- CI pipelines create a fresh venv (or container) per run and install from `requirements.txt`/`pyproject.toml`, so "works on my machine" bugs from mismatched dependency versions are caught early.
- Tools like `pyenv` (multiple Python *versions* on one machine) are often paired with `venv` (multiple isolated *dependency sets* on one machine) — different problems, both common in real teams.

## Summary

- Install Python from python.org or your OS package manager; verify with `python --version`.
- Run scripts with `python file.py`; use the REPL for quick experiments.
- Always use a virtual environment (`python -m venv .venv`) per project to isolate dependencies.
- Track dependencies in `requirements.txt` (`pip freeze > requirements.txt`) so the project is reproducible.
- Keep a conventional folder layout: source, tests, dependency file, `.gitignore`.

## Key Terms

- **Interpreter** — the program (`python`/`python3`) that reads and executes your `.py` source.
- **REPL** — Read-Eval-Print Loop; an interactive Python prompt.
- **Virtual environment (venv)** — an isolated Python + package installation scoped to one project.
- **pip** — Python's standard package installer.
- **PyPI** — the Python Package Index, the default public package repository `pip` pulls from.
- **requirements.txt** — a plain-text list of a project's pinned dependencies.

## Common Mistakes

- Installing packages globally instead of into an activated virtual environment.
- Committing `.venv/` or `__pycache__/` to version control — always `.gitignore` them.
- Forgetting to activate the venv before installing/running, silently working against the system Python instead.
- Assuming `python` always means Python 3 — on some systems it may not exist or may point elsewhere; `python3` is the safer bet on macOS/Linux.
- Never pinning dependency versions, so `pip install -r requirements.txt` installs different versions on a teammate's machine months later.

## Best Practices

- One virtual environment per project, created inside the project folder as `.venv`.
- Always add `.venv/`, `__pycache__/`, and `*.pyc` to `.gitignore` immediately when starting a project.
- Regenerate `requirements.txt` with `pip freeze` whenever you add a dependency.
- Prefer `python -m pip install ...` over bare `pip install ...` — it guarantees you're using the `pip` tied to the `python` you expect, avoiding PATH ambiguity.

## Interview Questions

1. **Why use a virtual environment instead of installing packages globally?**
   To isolate each project's dependencies so version conflicts between projects can't happen, and so the project's exact dependency set is reproducible elsewhere via `requirements.txt`.

2. **What's the difference between `python` and `pip`?**
   `python` is the interpreter that runs your code; `pip` is the package manager that installs third-party libraries your code depends on.

3. **What happens if you run `pip install` without activating a virtual environment?**
   It installs into the currently active Python environment — which, if no venv is activated, is usually the system-wide Python, polluting it and risking conflicts across unrelated projects.

4. **What's the purpose of `requirements.txt`?**
   It records the exact set of dependencies (and typically their versions) a project needs, so anyone (or any CI system) can recreate the same environment with `pip install -r requirements.txt`.

## Suggested Next Lesson

[02 — Syntax](../02-Syntax/README.md)
