"""
Lesson 05 - Hash Tables
Implements a simple hash table from scratch (with collision handling via
chaining), then demonstrates the same ideas using Python's built-in dict.

Run with:
    python implementation.py
"""


class HashTable:
    """A minimal hash table using separate chaining for collisions.

    The core idea: convert a key into an array index using a hash
    function, then store the value at that index. Two DIFFERENT keys can
    hash to the SAME index (a collision) - this implementation resolves
    that by storing a list ("chain") of (key, value) pairs at each index
    instead of a single value, and scanning that short list on lookup.
    """

    def __init__(self, bucket_count=8):
        # Start with a fixed number of buckets (slots). Each bucket holds
        # a list of (key, value) pairs that happened to hash to it.
        self._bucket_count = bucket_count
        self._buckets = [[] for _ in range(bucket_count)]
        self._size = 0

    def _hash(self, key):
        """Converts a key into a bucket index.

        Python's built-in hash() gives a (potentially huge, possibly
        negative) integer that's consistent for the same key within one
        run. We reduce it into range with modulo - the modulo is what
        actually determines which bucket a key lands in, and it's also
        exactly why two unrelated keys can collide: many different hash()
        values can share the same remainder when divided by bucket_count.
        """
        return hash(key) % self._bucket_count

    def put(self, key, value):
        """Inserts or updates a key-value pair. O(1) average case."""
        index = self._hash(key)
        bucket = self._buckets[index]

        for i, (existing_key, _) in enumerate(bucket):
            if existing_key == key:
                # Key already exists in this bucket - update in place
                # rather than appending a duplicate entry.
                bucket[i] = (key, value)
                return

        # New key - append it to this bucket's chain.
        bucket.append((key, value))
        self._size += 1

    def get(self, key):
        """Retrieves the value for `key`, or raises KeyError if absent.

        O(1) average case: we jump straight to the right bucket via
        hashing, then scan that bucket's (usually very short) chain.
        O(n) WORST case if every key collided into the same bucket - this
        is exactly why a good hash function that spreads keys evenly
        across buckets matters so much (see the README's Advanced section).
        """
        index = self._hash(key)
        bucket = self._buckets[index]
        for existing_key, value in bucket:
            if existing_key == key:
                return value
        raise KeyError(key)

    def delete(self, key):
        """Removes `key` from the table. Raises KeyError if absent."""
        index = self._hash(key)
        bucket = self._buckets[index]
        for i, (existing_key, _) in enumerate(bucket):
            if existing_key == key:
                del bucket[i]
                self._size -= 1
                return
        raise KeyError(key)

    def contains(self, key):
        index = self._hash(key)
        bucket = self._buckets[index]
        return any(existing_key == key for existing_key, _ in bucket)

    def __len__(self):
        return self._size

    def bucket_contents(self):
        """Exposes internal bucket layout for teaching purposes - shows
        collisions happening, which a real HashTable API would never
        expose (it's an implementation detail), but is the whole point
        of this lesson.
        """
        return list(self._buckets)


def demonstrate_collisions():
    """Deliberately uses a TINY bucket_count (3) so collisions happen on
    ordinary small input, making the "different keys share a bucket"
    concept visible rather than theoretical.
    """
    table = HashTable(bucket_count=3)
    keys = ["apple", "banana", "cherry", "date", "elderberry"]
    for i, key in enumerate(keys):
        table.put(key, i)

    print(f"Inserted keys: {keys}")
    print(f"bucket_count = 3, so collisions are likely with {len(keys)} keys.")
    for index, bucket in enumerate(table.bucket_contents()):
        keys_in_bucket = [k for k, _ in bucket]
        print(f"  bucket[{index}] -> {keys_in_bucket}")
    return table


def demonstrate_dict_equivalent():
    """Python's built-in dict does exactly what HashTable does above, but
    implemented in C, with a far more sophisticated hash function, dynamic
    resizing, and open addressing instead of chaining - it's the same
    CONCEPT, production-hardened. This is why you should always reach for
    dict in real code, and only hand-roll a hash table to learn how it works.
    """
    word_counts = {}
    words = ["the", "quick", "fox", "the", "lazy", "fox", "the"]
    for word in words:
        # dict.get(key, default) avoids a KeyError for first-time words -
        # same pattern used by is_anagram in Lesson 02.
        word_counts[word] = word_counts.get(word, 0) + 1
    return word_counts


def main():
    print("=== Hash table from scratch: put, get, delete, contains ===")
    table = HashTable()
    table.put("name", "Ada")
    table.put("language", "Python")
    table.put("year", 2026)
    print(f"get('name') -> {table.get('name')}")
    print(f"get('language') -> {table.get('language')}")
    print(f"contains('year') -> {table.contains('year')}")
    print(f"contains('missing') -> {table.contains('missing')}")
    print(f"size -> {len(table)}")

    table.put("name", "Grace")  # update existing key
    print(f"After put('name', 'Grace') [update]: get('name') -> {table.get('name')}, size -> {len(table)}")

    table.delete("year")
    print(f"After delete('year'): contains('year') -> {table.contains('year')}, size -> {len(table)}")

    try:
        table.get("year")
    except KeyError as error:
        print(f"get('year') after delete raises KeyError: {error}")

    print("\n=== Demonstrating collisions with a deliberately small bucket count ===")
    demonstrate_collisions()

    print("\n=== Equivalent task using Python's built-in dict ===")
    counts = demonstrate_dict_equivalent()
    print(f"Word frequency count: {counts}")


if __name__ == "__main__":
    main()
