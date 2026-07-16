"""Solution 03 - Order Data Pipeline."""

from functools import reduce

orders = [
    {"id": 1, "customer": "Ada", "total": 42.50, "status": "shipped"},
    {"id": 2, "customer": "Grace", "total": 15.00, "status": "pending"},
    {"id": 3, "customer": "Ada", "total": 99.99, "status": "shipped"},
    {"id": 4, "customer": "Linus", "total": 5.25, "status": "cancelled"},
    {"id": 5, "customer": "Grace", "total": 30.00, "status": "shipped"},
]


def main():
    print("--- Step 1: filter shipped orders ---")
    shipped = [o for o in orders if o["status"] == "shipped"]
    print(shipped)

    print("\n--- Step 2: map to totals ---")
    totals = [o["total"] for o in shipped]
    print(totals)

    print("\n--- Step 3: reduce to total revenue ---")
    revenue = reduce(lambda acc, t: acc + t, totals, 0)
    print(revenue)

    print("\n--- Step 4: single generator expression, no intermediate lists ---")
    revenue_single_pass = sum(o["total"] for o in orders if o["status"] == "shipped")
    print(revenue_single_pass)

    print("\n--- Step 5: total spent per customer, shipped orders only ---")
    spend_by_customer = {}
    for o in orders:
        if o["status"] == "shipped":
            spend_by_customer[o["customer"]] = spend_by_customer.get(o["customer"], 0) + o["total"]
    print(spend_by_customer)


if __name__ == "__main__":
    main()
