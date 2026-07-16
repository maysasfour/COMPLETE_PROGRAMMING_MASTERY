"""
Solution 02 - Group Anagrams

Run with:
    python solution-02.py
"""


def group_anagrams(words):
    """Groups words by their sorted-letters signature.

    Two words are anagrams exactly when sorting their letters produces
    the same string - that sorted string is used as a dict key so every
    word is placed into its group in one O(n) pass, with no word ever
    directly compared against another word.
    """
    groups = {}
    for word in words:
        signature = "".join(sorted(word))
        groups.setdefault(signature, []).append(word)
    return groups


def main():
    words = ["eat", "tea", "tan", "ate", "nat", "bat"]
    result = group_anagrams(words)
    print(f"group_anagrams({words})")
    for signature, group in result.items():
        print(f"  '{signature}' -> {group}")


if __name__ == "__main__":
    main()
