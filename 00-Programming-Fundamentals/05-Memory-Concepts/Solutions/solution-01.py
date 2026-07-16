"""
Solution 01 - Memory Concepts
Runnable versions of all four functions from exercise-01, including
the += vs .extend() trap on lists.

Run with:
    python solution-01.py

Expected output:
    a() mutates in place -> record: {'status': 'updated'}
    b() rebinds the local name -> record: {'status': 'new'}
    c() surprisingly ALSO mutates in place -> values: [1, 2, 3, 4]
    d() mutates in place -> values: [1, 2, 3, 4]
"""


def a(data):
    # dicts are mutable - this changes the SAME object `record` refers to.
    data["status"] = "updated"


record = {"status": "new"}
a(record)
print("a() mutates in place -> record:", record)


def b(data):
    # `data = {...}` REBINDS the local name `data` to a brand-new dict -
    # it never touches the object `record` still refers to.
    data = {"status": "updated"}


record = {"status": "new"}
b(record)
print("b() rebinds the local name -> record:", record)


def c(data):
    # THE TRAP: for a list, `+=` calls list.__iadd__, which mutates the
    # list IN PLACE (like .extend()) and then rebinds `data` to that
    # same (now-mutated) object. So despite `+=` looking like plain
    # reassignment, for a mutable type with __iadd__ defined, the
    # caller's object gets mutated too. (This would NOT be true for an
    # immutable type like int or str += a value - see modify_number in
    # example.py, which behaves differently because ints have no
    # __iadd__ and always rebind to a new object.)
    data += [4]


values = [1, 2, 3]
c(values)
print("c() surprisingly ALSO mutates in place -> values:", values)


def d(data):
    # .extend() is explicitly an in-place mutation method - no ambiguity.
    data.extend([4])


values = [1, 2, 3]
d(values)
print("d() mutates in place -> values:", values)
