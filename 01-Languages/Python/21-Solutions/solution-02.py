"""
Solution 02 - Word Frequency Counter
See: ../20-Exercises/README.md#exercise-02--word-frequency-counter-beginnerintermediate

Run with:
    python solution-02.py

Expected output:
    {'the': 2, 'cat': 2, 'sat': 1, 'ran': 1}
"""

import string


def word_frequencies(text: str) -> dict[str, int]:
    # Stripping punctuation per-word (rather than a regex) keeps this
    # readable without pulling in `re` for a problem this small.
    translator = str.maketrans("", "", string.punctuation)
    cleaned = text.translate(translator).lower()

    frequencies: dict[str, int] = {}
    for word in cleaned.split():
        # dict.get(word, 0) avoids a KeyError on the first sighting of a
        # word without needing a separate "if word in frequencies" branch.
        frequencies[word] = frequencies.get(word, 0) + 1
    return frequencies


if __name__ == "__main__":
    print(word_frequencies("The cat sat. The cat ran!"))
