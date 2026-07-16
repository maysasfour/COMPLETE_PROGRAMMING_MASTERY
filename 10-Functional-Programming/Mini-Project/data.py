"""data.py - a small, embedded sample dataset of sales transactions.
A tuple of dicts -- treated as read-only data throughout the pipeline (Lesson 01)."""

TRANSACTIONS = (
    {"id": 1, "category": "electronics", "amount": 129.99, "status": "completed"},
    {"id": 2, "category": "books", "amount": 14.50, "status": "completed"},
    {"id": 3, "category": "electronics", "amount": 599.00, "status": "completed"},
    {"id": 4, "category": "clothing", "amount": 45.00, "status": "refunded"},
    {"id": 5, "category": "books", "amount": 22.00, "status": "completed"},
    {"id": 6, "category": "electronics", "amount": 79.99, "status": "pending"},
    {"id": 7, "category": "clothing", "amount": 89.50, "status": "completed"},
    {"id": 8, "category": "electronics", "amount": 249.00, "status": "completed"},
    {"id": 9, "category": "books", "amount": 9.99, "status": "completed"},
    {"id": 10, "category": "clothing", "amount": 150.00, "status": "completed"},
)
