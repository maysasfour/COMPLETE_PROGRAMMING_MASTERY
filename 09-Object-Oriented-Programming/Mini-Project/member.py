"""Member hierarchy: inheritance + polymorphism via overriding `max_loans`.

`Member` is the common base holding shared state (id, name, currently-borrowed ISBNs).
`StudentMember` and `StaffMember` each override `max_loans` with a different policy --
callers never branch on "if this is a student" anywhere; they just call `.max_loans`
or `.can_borrow()` and let the object's own type decide the answer (polymorphism).
"""

from __future__ import annotations

from abc import ABC, abstractmethod


class Member(ABC):
    def __init__(self, member_id: str, name: str):
        self.member_id = member_id
        self.name = name
        # Tracks which books this member currently holds, by ISBN -- a Member doesn't
        # store Book objects directly (that would duplicate Library's bookkeeping);
        # it just remembers which ISBNs it's responsible for returning.
        self._borrowed_isbns: set[str] = set()

    @property
    @abstractmethod
    def max_loans(self) -> int:
        """The loan limit for this member type. Each subtype supplies its own policy."""
        ...

    @property
    def loaned_count(self) -> int:
        return len(self._borrowed_isbns)

    def can_borrow(self) -> bool:
        return self.loaned_count < self.max_loans

    def register_loan(self, isbn: str) -> None:
        # Defense in depth: even if a caller forgot to check can_borrow() first, the
        # member itself refuses to exceed its own limit -- the invariant is enforced
        # at the smallest scope that can enforce it, not just by the caller's discipline.
        if not self.can_borrow():
            raise ValueError(
                f"{self.name} has reached their loan limit of {self.max_loans} books"
            )
        if isbn in self._borrowed_isbns:
            raise ValueError(f"{self.name} has already borrowed ISBN {isbn}")
        self._borrowed_isbns.add(isbn)

    def register_return(self, isbn: str) -> None:
        if isbn not in self._borrowed_isbns:
            raise ValueError(f"{self.name} did not borrow ISBN {isbn}, cannot return it")
        self._borrowed_isbns.discard(isbn)

    def __repr__(self) -> str:
        return (
            f"{type(self).__name__}(id={self.member_id!r}, name={self.name!r}, "
            f"loans={self.loaned_count}/{self.max_loans})"
        )


class StudentMember(Member):
    """Students get a modest loan limit -- tuned for coursework, not research."""

    @property
    def max_loans(self) -> int:
        return 3


class StaffMember(Member):
    """Staff get a higher limit, reflecting broader research/teaching needs."""

    @property
    def max_loans(self) -> int:
        return 10
