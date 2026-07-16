"""Solution to Exercise 01 -- Classes and Object Identity."""


class Point:
    origin_label = "Point"  # class attribute: one shared string, not per-instance data

    def __init__(self, x, y):
        self.x = x
        self.y = y

    def distance_from_origin(self):
        return (self.x ** 2 + self.y ** 2) ** 0.5


p1 = Point(3, 4)
p2 = Point(3, 4)

# False: p1 and p2 are two separate objects built from separate Point(...) calls.
# Equal-looking coordinates don't make them the same object in memory.
print(p1 is p2)

p3 = p1
# True: p3 is not a new object, it's another name bound to the exact object p1 refers to.
print(p1 is p3)

# False: Point never defines __eq__, so == falls back to the default (identity) comparison,
# same as `is`. Matching x/y values are irrelevant unless __eq__ says they matter.
print(p1 == p2)

print(p1.distance_from_origin())  # 5.0


# Reflection 1: To make p1 == p2 True when coordinates match, define __eq__ on Point,
# e.g. `def __eq__(self, other): return isinstance(other, Point) and (self.x, self.y) == (other.x, other.y)`.
#
# Reflection 2: `history = []` as a class attribute would create ONE list shared by every
# Point instance -- appending to it from any instance mutates the same shared list for all
# instances (the same mutable-default trap as Lesson 01's `Broken.items` example). The fix is
# to create `self.history = []` inside `__init__` so each instance gets its own list.
