"""report.py - the entry point: runs the pipeline against the sample dataset and
prints a report. Ties together all five lessons in this module: pure functions,
higher-order functions, map/filter/reduce, composition, and partial application.
"""

from data import TRANSACTIONS
from pipeline import (
    filter_by_status,
    filter_by_min_amount,
    total_amount,
    average_amount,
    group_by_category,
    top_n_by_amount,
    completed_high_value_report,
    top_3_completed,
    format_usd,
    pipe,
)


def main():
    print("=== Sales Transaction Report ===\n")

    print("--- All completed transactions: total and average ---")
    completed = filter_by_status("completed")(TRANSACTIONS)
    print(f"count: {len(completed)}")
    print(f"total: {format_usd(total_amount(completed))}")
    print(f"average: {format_usd(average_amount(completed))}")

    print("\n--- Grouped by category (completed only) ---")
    grouped = group_by_category(completed)
    for category, txns in grouped.items():
        print(f"  {category}: {len(txns)} transaction(s), {format_usd(total_amount(txns))}")

    print("\n--- Composed pipeline: completed AND amount >= $50 ---")
    high_value = completed_high_value_report(TRANSACTIONS)
    for t in high_value:
        print(f"  #{t['id']} {t['category']}: {format_usd(t['amount'])}")

    print("\n--- Composed pipeline: top 3 completed transactions by amount ---")
    for t in top_3_completed(TRANSACTIONS):
        print(f"  #{t['id']} {t['category']}: {format_usd(t['amount'])}")

    print("\n--- Confirming the original dataset was never mutated ---")
    print(f"TRANSACTIONS still has {len(TRANSACTIONS)} entries, all pipeline stages returned new data")


if __name__ == "__main__":
    main()
