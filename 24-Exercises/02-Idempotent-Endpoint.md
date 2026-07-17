# Exercise 02 — Idempotent Endpoint

[Back to Exercises overview](README.md) | [Solution](../25-Solutions/02-Idempotent-Endpoint/README.md)

**Combines:** [14-APIs-and-Integrations](../14-APIs-and-Integrations/README.md) (idempotency) + [13-Software-Architecture](../13-Software-Architecture/README.md) (a real embedded HTTP server)

## Problem

You're given a real, running HTTP server (using the JDK's `com.sun.net.httpserver.HttpServer`) with a `POST /payments` endpoint that creates a new payment record with a server-generated ID every time it's called — meaning retrying an identical request after a (simulated) timeout creates a duplicate payment.

1. Demonstrate, with real HTTP requests, that calling this endpoint twice with the same "logical" request creates two separate payment records.
2. Redesign the endpoint to be idempotent: accept a client-supplied `idempotencyKey`, and ensure that submitting the same key twice only ever results in one payment being created.
3. Verify live: submit the same idempotency key three times in a row and confirm exactly one payment record exists afterward.
4. Verify live: submit two **different** idempotency keys and confirm two separate payment records exist.

## Constraints

- Use a real HTTP server and real `HttpClient` requests — no shortcuts that bypass the actual network layer.
- Store payments in an in-memory `Map` keyed by idempotency key.

## Success Criteria

- The non-idempotent version is shown, with real request/response output, to create duplicates.
- The idempotent version is shown, with real request/response output, to correctly deduplicate identical keys while still accepting genuinely distinct ones.
