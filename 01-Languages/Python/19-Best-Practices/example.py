"""
Lesson 19 - Best Practices
Demonstrates: PEP 8 naming conventions, type hints on function signatures,
the mutable default argument bug vs. its fix, docstring conventions
(Google-style), and an InventoryItem class combining all of the above.

Run with:
    python example.py

Expected output:
    --- PEP 8 naming ---
    MAX_RETRIES -> 3
    user_age -> 25

    --- type hints (documentation only, not enforced at runtime) ---
    greet('Ada') -> Hello, Ada!
    greet('Ada', times=2) -> Hello, Ada! Hello, Ada!

    --- mutable default argument bug vs. fix ---
    buggy first call ->  ['apple']
    buggy second call -> ['apple', 'banana']  <- bug: apple leaked in!
    fixed first call ->  ['apple']
    fixed second call -> ['banana']  <- correct: independent lists

    --- docstrings are introspectable at runtime ---
    calculate_discount.__doc__ starts with -> Calculate the discounted price.
    calculate_discount(100, 25) -> 75.0

    --- InventoryItem: combining every practice above ---
    widget quantity after restock -> 13
    widget is_low_stock() -> False
    gadget is_low_stock() -> True
    restock log -> ['restocked 10 units of widget']
"""

from typing import Optional

print("--- PEP 8 naming ---")
MAX_RETRIES = 3          # UPPER_SNAKE_CASE - a module-level constant
user_age = 25             # snake_case - an ordinary variable
print("MAX_RETRIES ->", MAX_RETRIES)
print("user_age ->", user_age)

print("\n--- type hints (documentation only, not enforced at runtime) ---")


def greet(name: str, times: int = 1) -> str:
    return (f"Hello, {name}! " * times).strip()


print("greet('Ada') ->", greet("Ada"))
print("greet('Ada', times=2) ->", greet("Ada", times=2))

print("\n--- mutable default argument bug vs. fix ---")


def add_item_buggy(item, cart=[]):
    # cart=[] is built ONCE, at def time - every call that omits `cart`
    # shares this exact same list object across calls.
    cart.append(item)
    return cart


def add_item_fixed(item, cart=None):
    # None is an immutable sentinel; a fresh list is created inside the
    # function body on every call that doesn't supply its own.
    if cart is None:
        cart = []
    cart.append(item)
    return cart


print("buggy first call -> ", add_item_buggy("apple"))
print("buggy second call ->", add_item_buggy("banana"), " <- bug: apple leaked in!")

print("fixed first call -> ", add_item_fixed("apple"))
print("fixed second call ->", add_item_fixed("banana"), " <- correct: independent lists")

print("\n--- docstrings are introspectable at runtime ---")


def calculate_discount(price: float, percent: float) -> float:
    """Calculate the discounted price.

    Args:
        price: The original price, must be non-negative.
        percent: The discount percentage (0-100).

    Returns:
        The price after applying the discount.

    Raises:
        ValueError: If percent is not between 0 and 100.
    """
    if not 0 <= percent <= 100:
        raise ValueError("percent must be between 0 and 100")
    return price * (1 - percent / 100)


first_doc_line = calculate_discount.__doc__.strip().splitlines()[0]
print("calculate_discount.__doc__ starts with ->", first_doc_line)
print("calculate_discount(100, 25) ->", calculate_discount(100, 25))

print("\n--- InventoryItem: combining every practice above ---")


class InventoryItem:
    """Represents a single item tracked in inventory."""

    LOW_STOCK_THRESHOLD: int = 5  # class-level constant, UPPER_SNAKE_CASE

    def __init__(self, name: str, quantity: int = 0) -> None:
        """Initialize an InventoryItem.

        Args:
            name: The item's display name.
            quantity: Starting quantity on hand. Defaults to 0.
        """
        self.name = name
        self.quantity = quantity

    def restock(self, amount: int, notes: Optional[list] = None) -> list:
        """Add to this item's quantity.

        Args:
            amount: How many units to add; must be positive.
            notes: Optional list to append a log entry to. A new list
                is created per call if none is provided - avoids the
                mutable default argument bug shown earlier in this file.

        Returns:
            The notes list (new or the one passed in), for the caller's convenience.
        """
        if amount <= 0:
            raise ValueError(f"amount must be positive, got {amount}")
        if notes is None:
            notes = []
        self.quantity += amount
        notes.append(f"restocked {amount} units of {self.name}")
        return notes

    def is_low_stock(self) -> bool:
        """Return True if quantity is at or below the low-stock threshold."""
        return self.quantity <= self.LOW_STOCK_THRESHOLD


widget = InventoryItem("widget", quantity=3)
log = widget.restock(10)
print("widget quantity after restock ->", widget.quantity)
print("widget is_low_stock() ->", widget.is_low_stock())

gadget = InventoryItem("gadget", quantity=2)
print("gadget is_low_stock() ->", gadget.is_low_stock())
print("restock log ->", log)
