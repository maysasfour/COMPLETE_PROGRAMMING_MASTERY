"""Book: an encapsulated domain object with validated fields.

Encapsulation pillar: `copies_total` and `copies_available` are exposed only through
properties that reject invalid states (negative copies, available > total), so it's
structurally impossible to construct or mutate a Book into a nonsensical state.
"""

from __future__ import annotations


class Book:
    def __init__(self, isbn: str, title: str, author: str, copies_total: int):
        self.isbn = isbn
        self.title = title
        self.author = author
        # Routed through the property setter (not `self._copies_total = copies_total`)
        # so construction can't bypass the same validation applied to later assignment.
        self.copies_total = copies_total
        # Every copy starts on the shelf; borrowing/returning adjust this independently
        # of copies_total, which only changes when the library acquires/retires stock.
        self._copies_available = copies_total

    @property
    def copies_total(self) -> int:
        return self._copies_total

    @copies_total.setter
    def copies_total(self, value: int) -> None:
        # A library can't own a negative number of copies of a book -- this is the
        # exact kind of physically-impossible state @property exists to prevent.
        if value < 0:
            raise ValueError(f"copies_total cannot be negative, got {value}")
        self._copies_total = value

    @property
    def copies_available(self) -> int:
        return self._copies_available

    def is_available(self) -> bool:
        return self._copies_available > 0

    def check_out(self) -> None:
        # Guards against a caller (or a bug elsewhere) driving availability negative,
        # which would otherwise let the same physical copy be "borrowed" twice over.
        if self._copies_available <= 0:
            raise ValueError(f"No available copies of '{self.title}' to check out")
        self._copies_available -= 1

    def check_in(self) -> None:
        # Guards against a return pushing available copies above total copies owned --
        # e.g. returning a book twice, or returning one that was never checked out.
        if self._copies_available >= self._copies_total:
            raise ValueError(
                f"Cannot check in '{self.title}': all {self._copies_total} copies are already accounted for"
            )
        self._copies_available += 1

    def __repr__(self) -> str:
        return (
            f"Book(isbn={self.isbn!r}, title={self.title!r}, author={self.author!r}, "
            f"available={self._copies_available}/{self._copies_total})"
        )

    def __eq__(self, other: object) -> bool:
        # Two Book records represent the same catalog entry if their ISBN matches --
        # ISBN is the real-world identity key for a book, not object identity.
        if not isinstance(other, Book):
            return NotImplemented
        return self.isbn == other.isbn

    def __hash__(self) -> int:
        return hash(self.isbn)
