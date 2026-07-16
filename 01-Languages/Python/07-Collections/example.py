"""
Lesson 07 - Collections
Demonstrates: list methods and slicing, tuple immutability and unpacking,
set operations, dict access patterns (.get()/.setdefault()), and
list/set/dict comprehensions.

Run with:
    python example.py

Expected output:
    --- lists ---
    fruits after edits -> ['apple', 'avocado', 'cherry', 'date']
    fruits[0] -> apple
    fruits[-1] -> date
    fruits[1:3] -> ['avocado', 'cherry']

    --- tuples ---
    point -> (3, 4), x=3, y=4

    --- sets ---
    tags (duplicates dropped) -> 3 unique tags
    union -> {1, 2, 3, 4}
    intersection -> {2, 3}
    difference -> {1}
    symmetric difference -> {1, 4}

    --- dicts ---
    person['age'] -> 36
    person.get('phone', 'N/A') -> N/A
    name: Ada
    age: 36
    email: ada@example.com
    roles after setdefault -> ['admin']

    --- comprehensions ---
    squares -> [0, 1, 4, 9, 16, 25]
    evens -> [0, 2, 4, 6, 8]
    unique_lengths -> {1, 2}
    squares_by_n -> {0: 0, 1: 1, 2: 4, 3: 9, 4: 16}
    pairs -> [(0, 0), (0, 1), (1, 0), (1, 1)]
"""

print("--- lists ---")
fruits = ["apple", "banana", "cherry"]
fruits.append("date")
fruits.insert(1, "avocado")
fruits.remove("banana")  # removes the first (and here, only) match by value
print("fruits after edits ->", fruits)
print("fruits[0] ->", fruits[0])
print("fruits[-1] ->", fruits[-1])       # negative index counts from the end
print("fruits[1:3] ->", fruits[1:3])     # slice stop index is exclusive

print("\n--- tuples ---")
point = (3, 4)
x, y = point  # unpacking relies on the tuple having exactly 2 elements
print(f"point -> {point}, x={x}, y={y}")

print("\n--- sets ---")
# Duplicates collapse automatically - a set never stores the same value twice.
tags = {"python", "code", "python", "tutorial"}
print(f"tags (duplicates dropped) -> {len(tags)} unique tags")

a = {1, 2, 3}
b = {2, 3, 4}
print("union ->", a | b)
print("intersection ->", a & b)
print("difference ->", a - b)
print("symmetric difference ->", a ^ b)

print("\n--- dicts ---")
person = {"name": "Ada", "age": 36}
person["email"] = "ada@example.com"
print("person['age'] ->", person["age"])
# .get() never raises KeyError - it returns the given default instead.
print("person.get('phone', 'N/A') ->", person.get("phone", "N/A"))

for key, value in person.items():
    print(f"{key}: {value}")

# setdefault returns the existing list (or creates+returns a new one) so we
# can append to it in the same expression, without a separate "if key not in d" check.
person.setdefault("roles", []).append("admin")
print("roles after setdefault ->", person["roles"])

print("\n--- comprehensions ---")
squares = [n ** 2 for n in range(6)]
print("squares ->", squares)

evens = [n for n in range(10) if n % 2 == 0]
print("evens ->", evens)

# {"a", "bb", "cc"} have lengths 1, 2, 2 - the set comprehension dedupes the lengths.
unique_lengths = {len(w) for w in ["a", "bb", "cc"]}
print("unique_lengths ->", unique_lengths)

squares_by_n = {n: n ** 2 for n in range(5)}
print("squares_by_n ->", squares_by_n)

# Nested comprehension loops read left-to-right, same order as writing nested `for`s.
pairs = [(px, py) for px in range(2) for py in range(2)]
print("pairs ->", pairs)
