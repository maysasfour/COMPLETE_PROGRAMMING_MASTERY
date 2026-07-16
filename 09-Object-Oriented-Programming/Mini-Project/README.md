# Mini-Project — Library Management System

[Back to module overview](../README.md) | [Diagrams](../Diagrams/README.md)

A console app that ties together every pillar covered in this module: encapsulation, inheritance, polymorphism, and composition, in one small but realistic domain — a library that lends books to members.

## Requirements

- **Book** (`book.py`): a catalog entry with `isbn`, `title`, `author`, `copies_total`, and `copies_available`. **Encapsulation**: `copies_total` is exposed through a validated `@property` — constructing or assigning a negative value raises `ValueError`, so a `Book` can never exist in a physically impossible state. `check_out()`/`check_in()` guard against driving `copies_available` outside `[0, copies_total]`.
- **Member** (`member.py`): an abstract base (`abc.ABC`) tracking a member's id, name, and currently-borrowed ISBNs, with an abstract `max_loans` property. **Inheritance + polymorphism**: `StudentMember` (limit 3) and `StaffMember` (limit 10) each override `max_loans` with their own policy — calling code never branches on which subtype it has; it just asks `member.can_borrow()` and the right answer comes back based on the object's actual type.
- **Library** (`library.py`): the coordinator. **Composition**: a `Library` *has a* catalog of `Book`s and a roster of `Member`s — it doesn't inherit from either, because "a library" isn't a kind of book or a kind of member, it's something that manages both. `borrow_book()`/`return_book()` enforce the cross-cutting rules (availability, loan limits, correct borrower on return) that no single `Book` or `Member` can enforce alone.

## Files

| File | Responsibility |
|---|---|
| `book.py` | `Book` class — validated fields, checkout/check-in state machine |
| `member.py` | `Member` ABC + `StudentMember`/`StaffMember` — loan-limit polymorphism |
| `library.py` | `Library` class — composes Books and Members, owns the borrowing workflow |
| `main.py` | Runnable demo — stocks a catalog, registers members, borrows past a limit, returns a book |
| `test_library.py` | Exercises the core logic: add/borrow/return, exceeding a loan limit, invalid `Book` construction, equality |

## How to Run

```bash
python main.py
```

Runs an end-to-end scripted walkthrough and prints each step's state, including a rejected over-limit borrow and a rejected negative-copies `Book`.

## How to Run the Tests

```bash
python test_library.py
```

Uses a tiny built-in runner (no third-party dependency, consistent with the rest of this module), so it works with nothing installed beyond the Python standard library. It's also plain `assert`-based, so `pytest test_library.py` works identically if you have pytest installed.

Requires Python 3.10+ (same requirement as the rest of the module).

## Design Notes

- **Why `Member` is an ABC and not just a plain base class**: `max_loans` genuinely has no sensible default — every real member must be *some* subtype with an actual policy. Making it `@abstractmethod` means forgetting to define a new member subtype's loan limit is a `TypeError` at instantiation time, not a silent `None` bug discovered later.
- **Why `Library` stores Books/Members in dicts keyed by `isbn`/`member_id`**: O(1) lookup for the operations that matter (`borrow_book`, `return_book`) rather than scanning a list on every call.
- **Why loan state is tracked in three places** (`Book.copies_available`, `Member._borrowed_isbns`, `Library._loans`): each answers a different question — "how many copies are free" (Book), "what does this member currently owe" (Member), and "who currently holds this specific copy" (Library, needed to reject a wrong-member return). Collapsing these into one place would require one object to reach into another's internals.
- **Why `Book` equality is by ISBN, not by object identity or all fields**: ISBN is the real-world identity key for a catalog entry — two `Book` objects built independently (e.g. one loaded from a database, one from a form) with the same ISBN represent the same book, even if incidental metadata differs.

See [../Diagrams/README.md](../Diagrams/README.md) for the class diagrams describing these relationships visually.
