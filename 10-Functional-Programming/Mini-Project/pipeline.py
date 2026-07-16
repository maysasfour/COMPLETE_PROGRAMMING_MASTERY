"""pipeline.py - the core functional pipeline: pure functions, composed together,
for analyzing a list of sales transactions. No classes, no mutation of inputs anywhere.
"""

from functools import reduce, partial


# ----------------------------------------------------------------------------
# Pure building-block functions (Lesson 01) -- each takes data in, returns
# NEW data out, never mutates its arguments, never touches anything global.
# ----------------------------------------------------------------------------

def filter_by_status(status):
    """Higher-order function (Lesson 02): returns a function pre-configured
    with a specific status to filter on."""
    def _filter(transactions):
        return [t for t in transactions if t["status"] == status]
    return _filter


def filter_by_min_amount(minimum):
    def _filter(transactions):
        return [t for t in transactions if t["amount"] >= minimum]
    return _filter


def total_amount(transactions):
    """Reduce (Lesson 03): fold a list of transactions down to a single total."""
    return reduce(lambda acc, t: acc + t["amount"], transactions, 0)


def average_amount(transactions):
    if not transactions:
        return 0
    return total_amount(transactions) / len(transactions)


def group_by_category(transactions):
    """A custom reduction: fold a list into a dict of category -> list of transactions."""
    def add_to_group(groups, t):
        category = t["category"]
        return {**groups, category: groups.get(category, []) + [t]}
    return reduce(add_to_group, transactions, {})


def top_n_by_amount(n):
    def _top_n(transactions):
        return sorted(transactions, key=lambda t: t["amount"], reverse=True)[:n]
    return _top_n


# ----------------------------------------------------------------------------
# Function composition (Lesson 04): build a pipeline out of the small
# functions above, applied left-to-right in the order listed.
# ----------------------------------------------------------------------------

def compose_two(f, g):
    return lambda x: f(g(x))


def pipe(*functions):
    return reduce(compose_two, reversed(functions))


# ----------------------------------------------------------------------------
# Partial application (Lesson 05): specialize the general pipeline builders
# above into report-specific, ready-to-use functions.
# ----------------------------------------------------------------------------

completed_high_value_report = pipe(
    filter_by_status("completed"),
    filter_by_min_amount(50),
)

top_3_completed = pipe(
    filter_by_status("completed"),
    top_n_by_amount(3),
)

def format_currency(symbol, amount):
    return f"{symbol}{amount:,.2f}"


# partial() fixes the currency SYMBOL, deriving a ready-to-use formatter that
# only needs an amount -- reused throughout report.py without repeating "$" everywhere.
format_usd = partial(format_currency, "$")
