"""
Lesson 02 - Arrays and Strings
Demonstrates: Python list (array) operation complexity, and three classic
string algorithms (reverse, palindrome check, anagram check) implemented
from first principles rather than relying on a one-liner built-in.

Run with:
    python implementation.py
"""


def demonstrate_list_operations():
    """Shows the complexity-relevant behavior of common list operations.

    Python's list is a dynamic array: contiguous memory, O(1) indexed
    access, but insert/delete at the FRONT requires shifting every
    remaining element - that shift is the part beginners usually don't
    expect to cost anything.
    """
    data = [10, 20, 30, 40, 50]
    print(f"Initial list: {data}")

    # O(1): direct memory offset calculation, no scanning required.
    print(f"data[2] -> {data[2]}  (O(1): index math, not a search)")

    # O(1) amortized: appending to the END rarely triggers a resize, and
    # when it does, Python over-allocates so most appends are O(1).
    data.append(60)
    print(f"After append(60): {data}  (O(1) amortized)")

    # O(n): every element from index 0 onward must shift right by one to
    # make room - this is the operation beginners assume is "instant".
    data.insert(0, 5)
    print(f"After insert(0, 5): {data}  (O(n): every existing element shifts)")

    # O(n): same shifting cost in reverse - removing from the front means
    # every remaining element shifts left by one to close the gap.
    data.pop(0)
    print(f"After pop(0): {data}  (O(n): every remaining element shifts)")

    # O(n): removing from the END needs no shifting - only the last
    # element goes away, so nothing else moves.
    data.pop()
    print(f"After pop(): {data}  (O(1): no shifting needed, it's the last slot)")

    # O(n): search must potentially check every element - there is no
    # shortcut for an unsorted array.
    found = 30 in data
    print(f"30 in data -> {found}  (O(n): unsorted, so a full scan may be needed)")


def reverse_string(text):
    """Reverses a string in O(n) time using two pointers, without slicing.

    We build this manually (rather than just using text[::-1]) because the
    point of the lesson is understanding HOW reversal works, not that
    Python has a shortcut for it. The two-pointer technique here is the
    same pattern used constantly in array problems.
    """
    chars = list(text)  # strings are immutable in Python, so we need a mutable buffer
    left, right = 0, len(chars) - 1
    while left < right:
        chars[left], chars[right] = chars[right], chars[left]
        left += 1
        right -= 1
    return "".join(chars)


def is_palindrome(text):
    """Checks whether text reads the same forwards and backwards.

    Ignores case and non-alphanumeric characters, because a real-world
    palindrome check ("A man, a plan, a canal: Panama") needs to ignore
    punctuation and spacing - only comparing raw characters would reject
    valid palindromes for the wrong reason.
    """
    cleaned = [c.lower() for c in text if c.isalnum()]
    left, right = 0, len(cleaned) - 1
    while left < right:
        if cleaned[left] != cleaned[right]:
            return False
        left += 1
        right -= 1
    return True


def is_anagram(first, second):
    """Checks whether two strings are anagrams of each other in O(n) time.

    Uses a character-frequency count instead of sorting both strings
    (which would be O(n log n)) - counting is strictly faster and makes
    the O(n) vs O(n log n) trade-off from Lesson 01 concrete.
    """
    first_clean = first.lower().replace(" ", "")
    second_clean = second.lower().replace(" ", "")

    if len(first_clean) != len(second_clean):
        # Different lengths can never be anagrams - checking this first
        # avoids doing any counting work in the common "obviously not" case.
        return False

    counts = {}
    for char in first_clean:
        # Building a frequency table: +1 for every character seen in `first`.
        counts[char] = counts.get(char, 0) + 1
    for char in second_clean:
        # Then -1 for every character seen in `second` - if the strings are
        # true anagrams, every count returns to exactly zero.
        counts[char] = counts.get(char, 0) - 1

    return all(count == 0 for count in counts.values())


def main():
    print("=== Array (list) operations and their complexity ===")
    demonstrate_list_operations()

    print("\n=== String reversal ===")
    for word in ["hello", "Python", "a"]:
        print(f"reverse_string({word!r}) -> {reverse_string(word)!r}")

    print("\n=== Palindrome check ===")
    test_cases = [
        "racecar",
        "hello",
        "A man, a plan, a canal: Panama",
        "",
    ]
    for case in test_cases:
        print(f"is_palindrome({case!r}) -> {is_palindrome(case)}")

    print("\n=== Anagram check ===")
    pairs = [
        ("listen", "silent"),
        ("hello", "world"),
        ("Dormitory", "Dirty Room"),
        ("aabbcc", "abcabc"),
    ]
    for a, b in pairs:
        print(f"is_anagram({a!r}, {b!r}) -> {is_anagram(a, b)}")


if __name__ == "__main__":
    main()
