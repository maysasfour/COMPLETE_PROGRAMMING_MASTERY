# Solution 02 — Idempotent Endpoint

[Back to Solutions overview](../README.md) | [Exercise](../../24-Exercises/02-Idempotent-Endpoint.md)

## Approach

The violation generates a new server-side ID on every call. The fix accepts a client-supplied `idempotencyKey` and uses `Map.putIfAbsent` so retrying the same key is a genuine no-op.

## Verified Live

```
=== Violation: retrying an identical logical request creates duplicates ===
  /payments -> 201 {"id":"1"}
  /payments -> 201 {"id":"2"}
Total payments created: 2  <- BUG: should be 1 logical payment, got 2

=== Fixed: same idempotency key submitted 3 times ===
  /payments-idempotent?idempotencyKey=abc-123 -> 200 {"idempotencyKey":"abc-123"}
  /payments-idempotent?idempotencyKey=abc-123 -> 200 {"idempotencyKey":"abc-123"}
  /payments-idempotent?idempotencyKey=abc-123 -> 200 {"idempotencyKey":"abc-123"}
Total payments for key 'abc-123': 1

=== Fixed: two DIFFERENT idempotency keys ===
  /payments-idempotent?idempotencyKey=xyz-999 -> 200 {"idempotencyKey":"xyz-999"}
Total distinct payments now: 2 (keys: [xyz-999, abc-123])
```

Retrying the same key 3 times correctly left exactly 1 payment; a genuinely different key correctly created a second, distinct payment — the same idempotency discipline verified in [14-APIs-and-Integrations/01-HTTP-Fundamentals](../../14-APIs-and-Integrations/01-HTTP-Fundamentals/README.md).

## Run It

```bash
cd 25-Solutions/02-Idempotent-Endpoint
javac Example.java
java Example
```

See [Example.java](Example.java) for the full, runnable solution.
