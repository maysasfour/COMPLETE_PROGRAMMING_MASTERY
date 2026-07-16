"""
Lesson 05 - Control Flow
Demonstrates: if/elif/else and truthiness, for loops with range()/enumerate(),
while loops, break/continue, the little-known else clause on loops, and the
match statement (literal patterns, OR patterns with |, and the _ wildcard).

Run with:
    python example.py

Expected output:
    --- if/elif/else and truthiness ---
    temperature 15 -> cool
    empty list is falsy -> empty

    --- for loops ---
    apple
    banana
    cherry
    range(3) -> 0 1 2
    0 apple
    1 banana

    --- while loop ---
    0
    1
    2

    --- break / continue ---
    continue skips 2 -> 0 1 3 4
    break stops at 3 -> 0 1 2

    --- loop else clause ---
    find_first_negative([1, 2, 3]) -> no negative numbers found
    find_first_negative([1, -2, 3]) -> found a negative: -2

    --- match statement ---
    describe_status(200) -> OK
    describe_status(404) -> Not Found
    describe_status(999) -> Unknown status
    is_weekend('Saturday') -> True
    is_weekend('Tuesday') -> False
"""

print("--- if/elif/else and truthiness ---")
temperature = 15
# elif chains are checked top to bottom; only the FIRST true branch runs,
# so branch order matters when ranges overlap.
if temperature > 30:
    result = "hot"
elif temperature > 15:
    result = "warm"
else:
    result = "cool"
print(f"temperature 15 -> {result}")

# An empty list is falsy - no need to write `if len(items) == 0:` explicitly.
items = []
print(f"empty list is falsy -> {'has items' if items else 'empty'}")

print("\n--- for loops ---")
for fruit in ["apple", "banana", "cherry"]:
    print(fruit)

# range(3) stops BEFORE 3 - it's a half-open interval, matching slice semantics.
print("range(3) ->", *range(3))

for index, fruit in enumerate(["apple", "banana"]):
    print(index, fruit)

print("\n--- while loop ---")
count = 0
# The condition is re-checked before every pass, including the first -
# a while loop with a false condition up front never runs at all.
while count < 3:
    print(count)
    count += 1

print("\n--- break / continue ---")
skipped = []
for n in range(5):
    if n == 2:
        continue  # skip just this iteration; the loop keeps going afterward
    skipped.append(n)
print("continue skips 2 ->", *skipped)

stopped = []
for n in range(5):
    if n == 3:
        break  # exits the loop entirely; 3 and 4 are never appended
    stopped.append(n)
print("break stops at 3 ->", *stopped)

print("\n--- loop else clause ---")


def find_first_negative(numbers):
    for n in numbers:
        if n < 0:
            print(f"found a negative: {n}")
            break
    else:
        # This only executes because the loop above ran to completion
        # without hitting `break` - i.e., nothing negative was found.
        print("no negative numbers found")


print("find_first_negative([1, 2, 3]) ->", end=" ")
find_first_negative([1, 2, 3])
print("find_first_negative([1, -2, 3]) ->", end=" ")
find_first_negative([1, -2, 3])

print("\n--- match statement ---")


def describe_status(code):
    # Literal pattern matching: each case compares the subject by equality,
    # and `_` is the wildcard that catches everything else, like a default.
    match code:
        case 200:
            return "OK"
        case 404:
            return "Not Found"
        case 500:
            return "Server Error"
        case _:
            return "Unknown status"


print(f"describe_status(200) -> {describe_status(200)}")
print(f"describe_status(404) -> {describe_status(404)}")
print(f"describe_status(999) -> {describe_status(999)}")


def is_weekend(day):
    # The | in a case pattern lets one branch match multiple literal
    # values, avoiding a long chain of separate `case` lines.
    match day:
        case "Saturday" | "Sunday":
            return True
        case "Monday" | "Tuesday" | "Wednesday" | "Thursday" | "Friday":
            return False
        case _:
            raise ValueError(f"not a valid day: {day}")


print(f"is_weekend('Saturday') -> {is_weekend('Saturday')}")
print(f"is_weekend('Tuesday') -> {is_weekend('Tuesday')}")
