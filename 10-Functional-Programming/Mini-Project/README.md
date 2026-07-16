# Mini-Project — Sales Transaction Analytics Pipeline

[Back to module overview](../README.md)

A small, self-contained functional pipeline that analyzes a list of sales transactions, tying together every lesson in this module in one realistic (if simplified) program: no classes, no mutation of the underlying dataset anywhere, and every building block independently testable.

## What It Does

Given a fixed dataset of sales transactions ([data.py](data.py)), the pipeline ([pipeline.py](pipeline.py)) computes:

- Total and average of all completed transactions.
- Transactions grouped by category.
- A composed "high-value completed transactions" report (completed **and** amount ≥ $50).
- A composed "top 3 completed transactions by amount" report.

[report.py](report.py) is the entry point, printing a formatted report using all of the above.

## How Each Lesson Shows Up

- **Lesson 01 (Pure Functions and Immutability)**: every function in `pipeline.py` returns new data and never mutates its input. `TRANSACTIONS` is a `tuple` of dicts (Lesson 01's immutability point), and `test_pipeline.py` explicitly verifies the sample dataset is untouched after being passed through `filter_by_status`.
- **Lesson 02 (Higher-Order Functions)**: `filter_by_status(status)`, `filter_by_min_amount(minimum)`, and `top_n_by_amount(n)` are all function factories — calling them returns a *new*, specifically-configured function, rather than performing the filter/sort immediately.
- **Lesson 03 (Map, Filter, Reduce)**: `total_amount` and `group_by_category` are both built with `functools.reduce`; list comprehensions handle the filtering steps.
- **Lesson 04 (Function Composition)**: `completed_high_value_report` and `top_3_completed` are both built with `pipe()`, combining two independently-defined stages into one ready-to-use pipeline function.
- **Lesson 05 (Currying and Partial Application)**: `format_usd = partial(format_currency, "$")` specializes a generic, symbol-parameterized formatter into a ready-to-use USD formatter, used throughout the report.

## Run It

```bash
cd 10-Functional-Programming/Mini-Project
python report.py          # runs the full analytics report
python test_pipeline.py     # runs the standalone tests for each pure function
```

## Expected Output

`report.py` prints: `count: 8` completed transactions totaling `$1,263.98` (average `$158.00`), a category breakdown (electronics `$977.99`, books `$46.49`, clothing `$239.50`), 5 transactions in the high-value report, the top 3 transactions by amount (`#3` at `$599.00`, `#8` at `$249.00`, `#10` at `$150.00`), and a confirmation that the original 10-entry dataset was never mutated. `test_pipeline.py` prints `7/7 tests passed` — every pure function was verified independently, in isolation, before being combined into the full pipeline.

## Design Notes

- The dataset is a `tuple` of dicts, not a `list` — a small, deliberate nod to Lesson 01: the outermost collection itself can't be reassigned-into accidentally (though the dicts inside are still technically mutable; a stricter version could use `types.MappingProxyType` or `frozen=True` dataclasses for full immutability, left as a possible extension).
- `group_by_category`'s reducer builds a *new* dict on every step (`{**groups, category: ...}`) rather than mutating an accumulator dict in place — slightly less efficient than `dict.setdefault`, but keeps the reduction itself pure and consistent with the rest of the module's emphasis on non-mutation.
- Every function in `pipeline.py` is tested in isolation in `test_pipeline.py` with a small, hand-picked sample dataset — independent of the larger, more realistic dataset in `data.py` used by `report.py` — demonstrating the Lesson 04 payoff that small, pure, composed pieces are each trivially testable on their own.
