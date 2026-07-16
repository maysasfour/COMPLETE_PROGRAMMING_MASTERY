"""Library: composed of Books and Members (composition, not inheritance).

A Library HAS a catalog of Books and a roster of Members -- it doesn't inherit from
either, because a library isn't a kind of book or a kind of member; it coordinates
between them. This is the composition relationship the Diagrams/README.md documents.
"""

from __future__ import annotations

from book import Book
from member import Member


class Library:
    def __init__(self, name: str):
        self.name = name
        self._catalog: dict[str, Book] = {}
        self._members: dict[str, Member] = {}
        # Tracks who currently holds which ISBN, so returns can be validated against
        # the actual borrower rather than trusting whatever member_id is passed in.
        self._loans: dict[str, str] = {}  # isbn -> member_id

    # -- Catalog management -------------------------------------------------
    def add_book(self, book: Book) -> None:
        if book.isbn in self._catalog:
            raise ValueError(f"A book with ISBN {book.isbn} is already in the catalog")
        self._catalog[book.isbn] = book

    def find_book(self, isbn: str) -> Book | None:
        return self._catalog.get(isbn)

    def all_books(self) -> list[Book]:
        return list(self._catalog.values())

    # -- Member management ----------------------------------------------------
    def register_member(self, member: Member) -> None:
        if member.member_id in self._members:
            raise ValueError(f"A member with id {member.member_id} is already registered")
        self._members[member.member_id] = member

    def find_member(self, member_id: str) -> Member | None:
        return self._members.get(member_id)

    def all_members(self) -> list[Member]:
        return list(self._members.values())

    # -- Borrowing workflow ---------------------------------------------------
    def borrow_book(self, member_id: str, isbn: str) -> None:
        member = self._require_member(member_id)
        book = self._require_book(isbn)

        if not book.is_available():
            raise ValueError(f"'{book.title}' has no available copies")
        if not member.can_borrow():
            raise ValueError(
                f"{member.name} has reached their loan limit of {member.max_loans} books"
            )

        # Order matters: mutate the member's state first so if it raises (e.g. duplicate
        # loan), the book's copy count is never decremented for a loan that didn't happen.
        member.register_loan(isbn)
        book.check_out()
        self._loans[isbn] = member_id

    def return_book(self, member_id: str, isbn: str) -> None:
        member = self._require_member(member_id)
        book = self._require_book(isbn)

        current_holder = self._loans.get(isbn)
        if current_holder != member_id:
            raise ValueError(
                f"ISBN {isbn} was not borrowed by member {member_id}; cannot process return"
            )

        member.register_return(isbn)
        book.check_in()
        del self._loans[isbn]

    def _require_book(self, isbn: str) -> Book:
        book = self.find_book(isbn)
        if book is None:
            raise KeyError(f"No book with ISBN {isbn} in the catalog")
        return book

    def _require_member(self, member_id: str) -> Member:
        member = self.find_member(member_id)
        if member is None:
            raise KeyError(f"No member with id {member_id} registered")
        return member

    def __repr__(self) -> str:
        return (
            f"Library(name={self.name!r}, books={len(self._catalog)}, "
            f"members={len(self._members)}, active_loans={len(self._loans)})"
        )
