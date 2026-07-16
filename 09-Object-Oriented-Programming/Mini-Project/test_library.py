"""Tests exercising the Library Management System's core logic.

No test framework dependency (plain assert + a tiny runner) to keep the module's
"no third-party packages required" guarantee intact -- pytest would work identically
if installed, but isn't needed to run these.
"""

from book import Book
from library import Library
from member import StaffMember, StudentMember


def make_library() -> Library:
    library = Library("Test Library")
    library.add_book(Book("ISBN-1", "Book One", "Author A", copies_total=2))
    library.add_book(Book("ISBN-2", "Book Two", "Author B", copies_total=1))
    library.register_member(StudentMember("S1", "Alice"))
    library.register_member(StaffMember("T1", "Bob"))
    return library


def test_add_book_and_find() -> None:
    library = make_library()
    book = library.find_book("ISBN-1")
    assert book is not None
    assert book.title == "Book One"
    assert book.copies_available == 2


def test_add_duplicate_isbn_rejected() -> None:
    library = make_library()
    try:
        library.add_book(Book("ISBN-1", "Duplicate", "Someone", copies_total=1))
        assert False, "expected ValueError for duplicate ISBN"
    except ValueError:
        pass


def test_book_rejects_negative_copies() -> None:
    # Encapsulation guarantee: invalid state can't be constructed at all.
    try:
        Book("ISBN-X", "Bad Book", "Nobody", copies_total=-1)
        assert False, "expected ValueError for negative copies_total"
    except ValueError:
        pass


def test_borrow_decrements_availability() -> None:
    library = make_library()
    library.borrow_book("S1", "ISBN-1")
    book = library.find_book("ISBN-1")
    assert book.copies_available == 1

    member = library.find_member("S1")
    assert member.loaned_count == 1


def test_borrow_last_copy_then_unavailable() -> None:
    library = make_library()
    library.borrow_book("S1", "ISBN-2")  # only 1 copy total
    book = library.find_book("ISBN-2")
    assert book.copies_available == 0
    assert not book.is_available()

    try:
        library.borrow_book("T1", "ISBN-2")
        assert False, "expected ValueError: no available copies"
    except ValueError:
        pass


def test_return_book_restores_availability() -> None:
    library = make_library()
    library.borrow_book("S1", "ISBN-1")
    library.return_book("S1", "ISBN-1")
    book = library.find_book("ISBN-1")
    assert book.copies_available == 2

    member = library.find_member("S1")
    assert member.loaned_count == 0


def test_return_by_wrong_member_rejected() -> None:
    library = make_library()
    library.borrow_book("S1", "ISBN-1")
    try:
        library.return_book("T1", "ISBN-1")  # Bob never borrowed this copy
        assert False, "expected ValueError: wrong member returning"
    except ValueError:
        pass


def test_student_loan_limit_enforced() -> None:
    # StudentMember.max_loans == 3 -- polymorphic override, tested directly here.
    library = Library("Limit Test Library")
    for i in range(4):
        library.add_book(Book(f"ISBN-{i}", f"Book {i}", "Author", copies_total=1))
    library.register_member(StudentMember("S1", "Alice"))

    library.borrow_book("S1", "ISBN-0")
    library.borrow_book("S1", "ISBN-1")
    library.borrow_book("S1", "ISBN-2")
    # At the limit (3) now -- the 4th borrow must raise, not silently succeed.
    try:
        library.borrow_book("S1", "ISBN-3")
        assert False, "expected ValueError: student loan limit exceeded"
    except ValueError:
        pass


def test_staff_loan_limit_higher_than_student() -> None:
    # Polymorphism: StaffMember overrides max_loans differently than StudentMember,
    # and Library.borrow_book never branches on the concrete type to get this right.
    library = Library("Limit Test Library 2")
    for i in range(4):
        library.add_book(Book(f"ISBN-{i}", f"Book {i}", "Author", copies_total=1))
    library.register_member(StaffMember("T1", "Bob"))

    # Staff limit is 10, so all 4 available books can be borrowed with no rejection.
    for i in range(4):
        library.borrow_book("T1", f"ISBN-{i}")
    member = library.find_member("T1")
    assert member.loaned_count == 4
    assert member.can_borrow()  # still well under the staff limit of 10


def test_borrow_unknown_member_or_book_raises_keyerror() -> None:
    library = make_library()
    try:
        library.borrow_book("NOPE", "ISBN-1")
        assert False, "expected KeyError for unknown member"
    except KeyError:
        pass

    try:
        library.borrow_book("S1", "NOPE")
        assert False, "expected KeyError for unknown book"
    except KeyError:
        pass


def test_book_equality_by_isbn() -> None:
    a = Book("ISBN-SAME", "Title A", "Author A", copies_total=1)
    b = Book("ISBN-SAME", "Title B (different metadata)", "Author B", copies_total=5)
    assert a == b  # identity key is ISBN, not object identity or other fields
    assert len({a, b}) == 1


def run_all() -> None:
    tests = [
        test_add_book_and_find,
        test_add_duplicate_isbn_rejected,
        test_book_rejects_negative_copies,
        test_borrow_decrements_availability,
        test_borrow_last_copy_then_unavailable,
        test_return_book_restores_availability,
        test_return_by_wrong_member_rejected,
        test_student_loan_limit_enforced,
        test_staff_loan_limit_higher_than_student,
        test_borrow_unknown_member_or_book_raises_keyerror,
        test_book_equality_by_isbn,
    ]
    failures = 0
    for test in tests:
        try:
            test()
            print(f"PASS: {test.__name__}")
        except AssertionError as e:
            failures += 1
            print(f"FAIL: {test.__name__}: {e}")

    print(f"\n{len(tests) - failures}/{len(tests)} tests passed")
    if failures:
        raise SystemExit(1)


if __name__ == "__main__":
    run_all()
