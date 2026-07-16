"""test_pipeline.py - standalone tests for each pure function in pipeline.py, run in
isolation with trivial data, demonstrating the payoff from Lesson 01 (pure functions
are trivially testable) and Lesson 04 (small, composed pieces are independently verifiable).

Run with: python test_pipeline.py
"""

from pipeline import (
    filter_by_status,
    filter_by_min_amount,
    total_amount,
    average_amount,
    group_by_category,
    top_n_by_amount,
    format_currency,
)

SAMPLE = (
    {"id": 1, "category": "a", "amount": 10.0, "status": "completed"},
    {"id": 2, "category": "b", "amount": 20.0, "status": "pending"},
    {"id": 3, "category": "a", "amount": 30.0, "status": "completed"},
)


def test_filter_by_status():
    result = filter_by_status("completed")(SAMPLE)
    assert len(result) == 2
    assert all(t["status"] == "completed" for t in result)
    assert SAMPLE == (
        {"id": 1, "category": "a", "amount": 10.0, "status": "completed"},
        {"id": 2, "category": "b", "amount": 20.0, "status": "pending"},
        {"id": 3, "category": "a", "amount": 30.0, "status": "completed"},
    )  # confirms the original SAMPLE tuple is untouched


def test_filter_by_min_amount():
    result = filter_by_min_amount(15)(SAMPLE)
    assert [t["id"] for t in result] == [2, 3]


def test_total_amount():
    assert total_amount(SAMPLE) == 60.0
    assert total_amount(()) == 0  # empty input -- no special-casing needed, reduce handles it


def test_average_amount():
    assert average_amount(SAMPLE) == 20.0
    assert average_amount(()) == 0  # explicitly guarded to avoid division by zero


def test_group_by_category():
    grouped = group_by_category(SAMPLE)
    assert set(grouped.keys()) == {"a", "b"}
    assert len(grouped["a"]) == 2
    assert len(grouped["b"]) == 1


def test_top_n_by_amount():
    top2 = top_n_by_amount(2)(SAMPLE)
    assert [t["id"] for t in top2] == [3, 2]  # 30.0 (id 3), then 20.0 (id 2)


def test_format_currency():
    assert format_currency("$", 1234.5) == "$1,234.50"
    assert format_currency("€", 0) == "€0.00"


def run_all():
    tests = [
        test_filter_by_status,
        test_filter_by_min_amount,
        test_total_amount,
        test_average_amount,
        test_group_by_category,
        test_top_n_by_amount,
        test_format_currency,
    ]
    passed = 0
    for test in tests:
        test()
        passed += 1
        print(f"PASS: {test.__name__}")
    print(f"\n{passed}/{len(tests)} tests passed")


if __name__ == "__main__":
    run_all()
