"""
Solution 02 - Implement First-Unique-Character

Run with:
    python solution-02.py
"""


def first_unique_char(text):
    """Returns the index of the first non-repeating character, or -1.

    O(n) time: one pass to build a frequency count (a dict, same pattern
    as is_anagram in the lesson's implementation.py), one pass to find the
    first character whose count is exactly 1. Two O(n) passes in sequence
    is still O(n) overall (Big O drops the constant "2" - see Lesson 01).
    O(n) space for the frequency table itself.
    """
    counts = {}
    for char in text:
        counts[char] = counts.get(char, 0) + 1

    for index, char in enumerate(text):
        if counts[char] == 1:
            return index

    # This also correctly handles text == "": the loop above simply never
    # runs, and we fall through to -1 with no special-case needed.
    return -1


def first_unique_char_quadratic(text):
    """O(n^2) alternative: for each character, scan the WHOLE string to
    count how many times it appears. Included to show the naive approach
    the lesson explicitly asks to avoid using as the primary solution, and
    to make the complexity difference concrete rather than just claimed.

    Complexity: O(n^2) - the outer loop runs n times, and str.count() is
    itself an O(n) scan, so n outer iterations x O(n) inner scan = O(n^2).
    """
    for index, char in enumerate(text):
        if text.count(char) == 1:
            return index
    return -1


def main():
    test_cases = ["swiss", "aabbcc", "x", ""]
    for case in test_cases:
        fast = first_unique_char(case)
        slow = first_unique_char_quadratic(case)
        print(f"first_unique_char({case!r}) -> {fast}  (quadratic version agrees: {slow == fast})")


if __name__ == "__main__":
    main()
