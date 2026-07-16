# Python Cheat Sheet

[Back to course overview](README.md)

Dense, scannable reference. Not a tutorial — see the numbered lessons for explanations.

## Running Python

```bash
python file.py            # run a script
python -i file.py         # run then drop into REPL
python -m module_name     # run a module as a script
python -c "print(1+1)"    # run inline code
python -m venv .venv       # create a virtual environment
.venv\Scripts\activate     # activate (Windows)
source .venv/bin/activate  # activate (macOS/Linux)
pip install -r requirements.txt
```

## Variables & Types

```python
x = 5                 # int
x = 5.0                # float
x = "text"             # str
x = True               # bool (subclass of int: True == 1)
x = None                # NoneType — Python's "no value"
x = [1, 2]              # list — mutable
x = (1, 2)              # tuple — immutable
x = {1, 2}              # set — unique, unordered
x = {"a": 1}            # dict — key/value

type(x)                 # class of x
isinstance(x, int)      # type check (prefer over type(x) == int)
```

## Operators

```python
+  -  *  /  // %  **     # arithmetic (// floor div, ** power)
== != < > <= >=           # comparison
and  or  not               # logical
is  is not                 # identity (same object)
in  not in                  # membership
&  |  ^  ~  <<  >>          # bitwise
+=  -=  *=  /=  //=  %=  **= # augmented assignment
```

## Strings

```python
s = "Hello, World"
s[0]                # 'H'
s[-1]                 # 'd'
s[0:5]                # 'Hello' (slice, stop exclusive)
s[::-1]               # reversed string
s.upper(); s.lower()
s.strip()             # remove leading/trailing whitespace
s.split(",")          # -> list
",".join(["a", "b"])  # -> "a,b"
s.replace("H", "J")
s.startswith("He"); s.endswith("ld")
f"{name} is {age} years old"       # f-string
f"{price:.2f}"                      # 2 decimal places
f"{value!r}"                        # repr instead of str
```

## Collections

```python
# List
lst = [1, 2, 3]
lst.append(4); lst.extend([5, 6]); lst.insert(0, 0)
lst.pop(); lst.remove(2); lst.sort(); lst.reverse()
[x * 2 for x in lst]                   # list comprehension
[x for x in lst if x % 2 == 0]         # with filter

# Dict
d = {"a": 1, "b": 2}
d["a"]; d.get("z", "default")
d.keys(); d.values(); d.items()
{k: v * 2 for k, v in d.items()}       # dict comprehension

# Set
s = {1, 2, 3}
s.add(4); s.discard(2)
s1 | s2   # union
s1 & s2   # intersection
s1 - s2   # difference

# Tuple
t = (1, 2, 3)
a, b, c = t              # unpacking
```

## Control Flow

```python
if condition:
    ...
elif other:
    ...
else:
    ...

for item in iterable:
    ...
else:                      # runs if loop completes without break
    ...

while condition:
    ...
    break
    continue

match command:
    case "start":
        ...
    case "stop" | "halt":
        ...
    case _:
        ...
```

## Functions

```python
def greet(name: str, greeting: str = "Hello") -> str:
    """Return a greeting for name."""
    return f"{greeting}, {name}!"

def total(*args, **kwargs):
    print(args)       # tuple of positional args
    print(kwargs)      # dict of keyword args

square = lambda x: x * x   # anonymous function
```

## Error Handling

```python
try:
    risky()
except ValueError as e:
    handle(e)
except (TypeError, KeyError):
    handle_multiple()
else:
    only_if_no_exception()
finally:
    always_runs()

raise ValueError("message")

class MyError(Exception):
    pass
```

## Classes

```python
class Animal:
    species_count = 0            # class attribute (shared)

    def __init__(self, name: str):
        self.name = name          # instance attribute
        Animal.species_count += 1

    def speak(self) -> str:
        return f"{self.name} makes a sound"

    def __str__(self) -> str:
        return f"Animal({self.name})"

    @property
    def display_name(self) -> str:
        return self.name.title()

class Dog(Animal):
    def speak(self) -> str:
        return f"{self.name} barks"
```

## Files

```python
with open("file.txt") as f:
    content = f.read()
    lines = f.readlines()

with open("file.txt", "w") as f:
    f.write("text")

import json
with open("data.json") as f:
    data = json.load(f)
json.dump(data, open("out.json", "w"), indent=2)

from pathlib import Path
p = Path("some/dir/file.txt")
p.exists(); p.parent; p.name; p.suffix
```

## Common Stdlib Idioms

```python
from collections import Counter, defaultdict
Counter("aabbc")                        # {'a': 2, 'b': 2, 'c': 1}
dd = defaultdict(list); dd["x"].append(1)

sorted(items, key=lambda x: x.age, reverse=True)
enumerate(items)                          # (index, value) pairs
zip(list_a, list_b)                       # pair up two iterables

any(x > 5 for x in nums)
all(x > 0 for x in nums)

import itertools
itertools.chain([1, 2], [3, 4])
```

## Type Hints (see Lesson 13)

```python
from typing import Optional, Union

def f(x: int, y: Optional[str] = None) -> bool: ...
def g(x: int | str) -> None: ...          # 3.10+ union syntax

from typing import TypeVar, Generic
T = TypeVar("T")

class Box(Generic[T]):
    def __init__(self, item: T) -> None:
        self.item = item
```

## Async (see Lesson 14)

```python
import asyncio

async def fetch():
    await asyncio.sleep(1)
    return "done"

asyncio.run(fetch())
```
