# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Beginner: Making a GET Request

`requests` is the de facto standard third-party HTTP library for Python. It isn't part of the standard library, so it needs installing:

```bash
pip install requests
```

The standard library does have a built-in alternative, `urllib.request`, but it's considerably lower-level and more verbose (manual header handling, no automatic JSON decoding). Almost all real-world Python code uses `requests` unless there's a specific reason to avoid the extra dependency.

```python
import requests

response = requests.get("https://jsonplaceholder.typicode.com/todos/1", timeout=5)
print(response.status_code)  # 200
print(response.json())        # {'userId': 1, 'id': 1, 'title': 'delectus aut autem', 'completed': False}
```

`jsonplaceholder.typicode.com` is a free, public fake REST API designed specifically for testing and learning — safe to hit with no authentication and no risk of side effects.

## Beginner: Checking Status and Parsing JSON

`response.status_code` tells you what actually happened *before* you trust the response body:

```python
if response.status_code == 200:
    data = response.json()
else:
    print(f"Request failed with status {response.status_code}")
```

`response.json()` parses the response body into native Python objects (`dict`, `list`, `str`, `int`, ...). It raises an exception if the body isn't valid JSON, so only call it once you've confirmed the request actually succeeded (or you're prepared to catch that error too).

## Intermediate: Timeouts and Error Handling

`requests` has **no default timeout** — if you omit `timeout=`, a request to a server that never responds (a dead host, a firewall silently dropping packets, a hung backend) will block your program **forever**. This is one of the most common production bugs with `requests`: always pass a `timeout` in seconds.

```python
try:
    response = requests.get("https://jsonplaceholder.typicode.com/todos/1", timeout=5)
except requests.exceptions.RequestException as error:
    # RequestException is the base class for every error requests can raise:
    # connection errors, timeouts, too-many-redirects, and more.
    print(f"Network request failed: {error}")
```

Catching `requests.exceptions.RequestException` (rather than enumerating each specific subclass) is the standard way to say "something went wrong at the network layer" in a single `except` clause.

## Advanced: POST Requests with a JSON Payload

```python
new_todo = {"title": "Learn requests", "completed": False, "userId": 1}
response = requests.post(
    "https://jsonplaceholder.typicode.com/todos",
    json=new_todo,
    timeout=5,
)
print(response.status_code)  # 201 - Created
print(response.json())        # the payload echoed back, with a fake new "id" added
```

Passing `json=` (rather than `data=`) does two things automatically: serializes the dict to a JSON string, and sets the `Content-Type: application/json` header — no manual `json.dumps()` or header wrangling needed. `jsonplaceholder` fakes persistence: it returns your payload with a plausible new `id`, but nothing is actually saved server-side, which makes it safe to POST to repeatedly while learning.

## Real-World Usage

- Almost every integration with a third-party service (payment providers, weather data, internal microservices) goes through `requests` (or an async equivalent like `httpx`/`aiohttp`) making HTTP calls exactly like this.
- Production code always sets a timeout and wraps calls in error handling — an API integration with no timeout is a live incident waiting to happen the first time the remote service hangs.
- Status-code checking plus `raise_for_status()` (a `requests` convenience method that raises an exception for 4xx/5xx responses) is a common pattern for turning "the server said no" into a Python exception you can handle uniformly.

## Summary

- `requests` is the standard third-party HTTP library (`pip install requests`); `urllib.request` is a lower-level stdlib alternative.
- Always check `response.status_code` before trusting `response.json()`.
- Always pass `timeout=` — without it, a hung server blocks your program indefinitely.
- Catch `requests.exceptions.RequestException` to handle any network-layer failure in one place.
- `requests.post(url, json=payload, timeout=...)` sends a JSON body and sets the right headers automatically.

## Key Terms

- **`requests`** — the standard third-party Python library for making HTTP requests.
- **Timeout** — a maximum time to wait for a response before giving up and raising an exception, instead of waiting indefinitely.
- **`status_code`** — the HTTP response code (e.g., 200 OK, 201 Created, 404 Not Found, 500 Internal Server Error) indicating the outcome of a request.
- **`RequestException`** — the base exception class in `requests` covering connection errors, timeouts, and other request failures.
- **JSON** (JavaScript Object Notation) — a lightweight text data format; `response.json()` parses it into native Python objects.

## Common Mistakes

- Omitting `timeout=` and having a request hang indefinitely when a server doesn't respond.
- Calling `response.json()` without first checking `status_code`, then getting a confusing error when an error page (HTML, not JSON) comes back instead.
- Catching only `requests.exceptions.ConnectionError` and missing other failure modes like timeouts or too-many-redirects — catch `RequestException` for the general case.
- Manually building JSON strings and setting headers by hand instead of using `json=`, which handles both automatically.
- Assuming a POST to a test API like jsonplaceholder actually persists data — it doesn't; it just echoes the payload back.

## Best Practices

- Always set an explicit `timeout` on every request.
- Wrap network calls in `try/except requests.exceptions.RequestException` and handle (or log, or retry) failures explicitly rather than letting them crash the program.
- Check `response.status_code` (or call `response.raise_for_status()`) before parsing the body as JSON.
- Use `json=` for JSON payloads rather than manually serializing and setting headers.
- Keep credentials/API keys out of source code — load them from environment variables or a secrets manager, never hard-code them.

## Interview Questions

1. **Why is setting a `timeout` mandatory in real-world `requests` code?**
   `requests` has no default timeout — if the target server never responds, the call blocks forever, which can hang an entire application thread or request handler. An explicit `timeout` guarantees the call eventually raises an exception instead of hanging indefinitely.

2. **What's the difference between `response.status_code` and `response.json()`, and why check the former before calling the latter?**
   `status_code` reports the HTTP outcome (success, client error, server error) without parsing anything; `response.json()` attempts to parse the response body as JSON and raises if it isn't valid JSON. An error response might return an HTML error page instead of JSON, so checking `status_code` first avoids a confusing parse failure masking the real problem.

3. **What does catching `requests.exceptions.RequestException` cover that catching just `ConnectionError` would miss?**
   `RequestException` is the base class for every error `requests` can raise — connection errors, timeouts, too-many-redirects, invalid URLs, and more. Catching only `ConnectionError` would leave timeouts and other failure modes unhandled.

4. **What does passing `json=payload` to `requests.post()` do that `data=payload` doesn't?**
   `json=` serializes the Python object to a JSON string automatically and sets the `Content-Type: application/json` header. `data=` sends the value more or less as-is (form-encoded for a dict) and won't set the JSON content type, so the receiving server may not parse it as JSON.

5. **Why would you use the stdlib `urllib.request` instead of `requests`, and why is that rare in practice?**
   `urllib.request` avoids adding a third-party dependency, which matters in extremely constrained environments or minimal scripts. In practice it's rare because it's much more verbose — manual header management, no automatic JSON encoding/decoding — so almost all real projects accept the small dependency cost of `requests` for the ergonomics.

## Suggested Next Lesson

[18 — Testing](../18-Testing/README.md)
