"""
Lesson 10 - File Handling
Demonstrates: open()/with for text files, writing vs. appending, reading
line-by-line, JSON round-tripping via json.dump/json.load, and pathlib for
path construction and inspection.

All files created by this script live under a local `_scratch/` directory
and are deleted again at the end, so running this script repeatedly leaves
no clutter behind.

Run with:
    python example.py

Expected output:
    --- open() and with (text files) ---
    file contents:
    first line
    second line

    --- reading line by line ---
    line 1: first line
    line 2: second line

    --- append mode ---
    after append: ['first line', 'second line', 'third line (appended)']

    --- JSON round-trip ---
    loaded == original -> True
    loaded: {'name': 'Ada', 'age': 36, 'roles': ['admin', 'user']}

    --- pathlib ---
    full path -> _scratch/reports/q1.json (separator is OS-specific: \ on Windows, / elsewhere)
    name -> q1.json
    stem -> q1
    suffix -> .json
    parent -> _scratch/reports (same OS-specific separator note applies)
    exists after mkdir+write -> True
"""

import json
import shutil
from pathlib import Path

scratch_dir = Path("_scratch")
scratch_dir.mkdir(exist_ok=True)  # exist_ok=True avoids an error if it's already there

print("--- open() and with (text files) ---")
notes_path = scratch_dir / "notes.txt"
# "w" creates the file if missing, and overwrites it completely if it exists.
with open(notes_path, "w") as f:
    f.write("first line\n")
    f.write("second line\n")
# The file is guaranteed closed here, even if an exception had occurred above.

with open(notes_path, "r") as f:
    contents = f.read()
print("file contents:")
print(contents.rstrip("\n"))

print("\n--- reading line by line ---")
with open(notes_path, "r") as f:
    for line_number, line in enumerate(f, start=1):
        # .strip() removes the trailing "\n" that each line keeps when read this way.
        print(f"line {line_number}: {line.strip()}")

print("\n--- append mode ---")
# "a" adds to the end without erasing what's already there - unlike "w".
with open(notes_path, "a") as f:
    f.write("third line (appended)\n")

with open(notes_path, "r") as f:
    all_lines = [line.strip() for line in f.readlines()]
print("after append:", all_lines)

print("\n--- JSON round-trip ---")
original = {"name": "Ada", "age": 36, "roles": ["admin", "user"]}
json_path = scratch_dir / "data.json"

with open(json_path, "w") as f:
    json.dump(original, f, indent=2)  # indent=2 makes the file human-readable

with open(json_path, "r") as f:
    loaded = json.load(f)

print("loaded == original ->", loaded == original)
print("loaded:", loaded)

print("\n--- pathlib ---")
report_path = scratch_dir / "reports" / "q1.json"
print("full path ->", report_path)
print("name ->", report_path.name)
print("stem ->", report_path.stem)
print("suffix ->", report_path.suffix)
print("parent ->", report_path.parent)

# parents=True creates "reports" too, not just the final file's immediate folder.
report_path.parent.mkdir(parents=True, exist_ok=True)
report_path.write_text(json.dumps({"quarter": "Q1"}))
print("exists after mkdir+write ->", report_path.exists())

# Clean up everything this script created so re-running it starts fresh.
shutil.rmtree(scratch_dir)
