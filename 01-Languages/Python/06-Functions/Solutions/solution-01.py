"""
Solution 01 - Functions
Runnable version of all four parts from exercise-01, demonstrating the
mutable default argument bug (Part 1), its fix (Part 2), *args/**kwargs
collection (Part 3), and implicit None return (Part 4).

Run with:
    python solution-01.py

Expected output:
    Part 1: ['alice']
    Part 1: ['alice', 'bob']
    Part 2: ['alice']
    Part 2: ['bob']
    Part 3: {'title': 'Q1 Report', 'sections': ('intro', 'summary'), 'metadata': {'author': 'Ada', 'pages': 5}}
    Part 4: saving config.json
    Part 4: outcome is None
"""


def register(name, roles=[]):
    # roles=[] is built ONCE at def time - both calls below mutate and
    # share that exact same list object, since neither call overrides it.
    roles.append(name)
    return roles


print("Part 1:", register("alice"))
print("Part 1:", register("bob"))


def register_fixed(name, roles=None):
    # None is an immutable, safely-reusable sentinel; a fresh list is
    # created inside the function body on every call that needs one.
    if roles is None:
        roles = []
    roles.append(name)
    return roles


print("Part 2:", register_fixed("alice"))
print("Part 2:", register_fixed("bob"))


def build_report(title, *sections, **metadata):
    # Positional args after `title` land in the *sections tuple; keyword
    # args land in the **metadata dict - each collector only gathers its
    # own kind of leftover argument.
    return {"title": title, "sections": sections, "metadata": metadata}


print("Part 3:", build_report("Q1 Report", "intro", "summary", author="Ada", pages=5))


def noisy_save(data):
    print(f"saving {data}")
    # No return statement - printing is a side effect, not a return value.


outcome = noisy_save("config.json")
print("Part 4:", f"outcome is {outcome!r}")
