"""Console demo entry point for the Library Management System.

Run with: python main.py

Walks through a realistic sequence -- stocking the catalog, registering members of
both subtypes, borrowing up to and past a limit, and returning a book -- printing
each step so the polymorphism (different max_loans per member type), composition
(Library coordinating Books and Members), and encapsulation (validated Book copies)
are all visible in the output rather than just asserted in a test file.
"""

from book import Book
from library import Library
from member import StaffMember, StudentMember


def main() -> None:
    library = Library("Riverside Public Library")

    # -- Stock the catalog ----------------------------------------------------
    library.add_book(Book("978-0-13-468599-1", "The C Programming Language", "K&R", copies_total=2))
    library.add_book(Book("978-0-596-00712-6", "Head First Design Patterns", "Freeman & Freeman", copies_total=1))
    library.add_book(Book("978-1-59327-584-6", "Python Crash Course", "Eric Matthes", copies_total=3))

    print("=== Catalog ===")
    for book in library.all_books():
        print(f"  {book}")

    # -- Register members of both subtypes (polymorphism: different max_loans) ---
    alice = StudentMember("S001", "Alice")
    bob = StaffMember("T001", "Dr. Bob")
    library.register_member(alice)
    library.register_member(bob)

    print("\n=== Members ===")
    for member in library.all_members():
        print(f"  {member} (max_loans={member.max_loans})")

    # -- Borrowing workflow ----------------------------------------------------
    print("\n=== Borrowing ===")
    library.borrow_book("S001", "978-0-13-468599-1")
    library.borrow_book("S001", "978-0-596-00712-6")
    print(f"  Alice borrowed 2 books. State: {alice}")

    # A staff member can hold more books than a student -- demonstrates the
    # overridden max_loans actually changing behavior, not just cosmetics.
    library.borrow_book("T001", "978-1-59327-584-6")
    print(f"  Bob borrowed 1 book. State: {bob}")

    # -- Push Alice (a student, limit 3) past her limit to show the guard firing --
    library.borrow_book("S001", "978-1-59327-584-6")
    print(f"  Alice borrowed a 3rd book (at her limit now). State: {alice}")
    try:
        # There's no 4th distinct book left to try in this demo catalog, so instead
        # demonstrate the limit directly against a book Alice hasn't borrowed --
        # if there were a 4th title, this call would raise the same way.
        library.add_book(Book("000-0-00-000000-0", "Extra Book", "Demo Author", copies_total=1))
        library.borrow_book("S001", "000-0-00-000000-0")
    except ValueError as e:
        print(f"  Rejected (loan limit): {e}")

    # -- Encapsulation: a Book can't be constructed with negative copies ---------
    print("\n=== Encapsulation check ===")
    try:
        Book("999-9-99-999999-9", "Impossible Book", "Nobody", copies_total=-1)
    except ValueError as e:
        print(f"  Rejected (invalid Book): {e}")

    # -- Returning a book -------------------------------------------------------
    print("\n=== Returning ===")
    library.return_book("S001", "978-0-13-468599-1")
    print(f"  Alice returned a book. State: {alice}")
    book = library.find_book("978-0-13-468599-1")
    print(f"  Book state after return: {book}")

    print(f"\n{library}")


if __name__ == "__main__":
    main()
