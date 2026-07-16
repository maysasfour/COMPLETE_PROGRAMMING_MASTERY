"""
Solution 01 - Collections: Inventory Aggregator
Runnable version covering total_quantities() (.setdefault()), categories()
(set comprehension), top_item() (max with key=), and summary_by_category()
(order-preserving dedup via membership check).

Run with:
    python solution-01.py

Expected output:
    total_quantities -> {'widget': 5, 'gadget': 1, 'banana': 6, 'apple': 4}
    categories -> {'hardware', 'produce'}
    top_item -> ('banana', 6)
    summary_by_category -> {'hardware': ['widget', 'gadget'], 'produce': ['banana', 'apple']}
"""

purchases = [
    ("widget", 3, "hardware"),
    ("gadget", 1, "hardware"),
    ("widget", 2, "hardware"),
    ("banana", 5, "produce"),
    ("apple", 4, "produce"),
    ("banana", 1, "produce"),
]


def total_quantities(records):
    totals = {}
    for item_name, quantity, _category in records:
        # setdefault(item_name, 0) returns 0 on first sight of a name, so the
        # += pattern works uniformly whether this is the 1st or 5th record for it.
        totals[item_name] = totals.setdefault(item_name, 0) + quantity
    return totals


def categories(records):
    # A set comprehension - the data structure itself removes duplicates,
    # no manual "seen before" tracking required.
    return {category for _name, _qty, category in records}


def top_item(totals):
    # key=lambda pair: pair[1] tells max() to compare by quantity (the
    # second tuple element) rather than by the (name, quantity) pair itself.
    return max(totals.items(), key=lambda pair: pair[1])


def summary_by_category(records):
    by_category = {}
    for item_name, _quantity, category in records:
        items_list = by_category.setdefault(category, [])
        # A plain set would drop order; this membership check keeps
        # first-seen order while still preventing duplicate names.
        if item_name not in items_list:
            items_list.append(item_name)
    return by_category


totals = total_quantities(purchases)
print("total_quantities ->", totals)
print("categories ->", categories(purchases))
print("top_item ->", top_item(totals))
print("summary_by_category ->", summary_by_category(purchases))
