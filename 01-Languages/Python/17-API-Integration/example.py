"""
Lesson 17 - API Integration
Demonstrates: making a GET request with the third-party `requests` library,
checking response.status_code, parsing response.json(), handling network
errors with a timeout and try/except around requests.exceptions.RequestException,
and making a POST request with a JSON payload.

Requires: pip install requests

Run with:
    python example.py

Expected output (this was run against the real, public jsonplaceholder.typicode.com
test API - the ids/content below are that service's actual fixed sample data):
    --- GET https://jsonplaceholder.typicode.com/todos/1 ---
    Status code: 200
    Response JSON: {'userId': 1, 'id': 1, 'title': 'delectus aut autem', 'completed': False}
    Todo title: delectus aut autem
    Completed: False

    --- POST https://jsonplaceholder.typicode.com/todos ---
    Status code: 201
    Response JSON: {'title': 'Learn requests', 'completed': False, 'userId': 1, 'id': 201}
    (jsonplaceholder doesn't actually persist this - it just echoes the payload back with a fake new id)

    --- Handling network errors with a timeout ---
    Caught expected error: request to an unreachable host failed as expected
"""

import requests

# --- GET request -----------------------------------------------------------
print("--- GET https://jsonplaceholder.typicode.com/todos/1 ---")
# `timeout` is not optional in real code: without it, a request that never
# gets a response (dead server, network black hole) will hang your program
# FOREVER - there is no default timeout in requests. Always set one.
response = requests.get("https://jsonplaceholder.typicode.com/todos/1", timeout=5)

# status_code tells you what actually happened before you trust the body -
# 200 means success; 4xx/5xx mean the server rejected or failed the request.
print(f"Status code: {response.status_code}")

# .json() parses the response body as JSON into native Python objects
# (dict/list/str/int/etc.) - it raises if the body isn't valid JSON.
data = response.json()
print(f"Response JSON: {data}")
print(f"Todo title: {data['title']}")
print(f"Completed: {data['completed']}")

# --- POST request -----------------------------------------------------------
print("\n--- POST https://jsonplaceholder.typicode.com/todos ---")
# `json=` serializes the dict to a JSON body and sets the Content-Type header
# automatically - no need to call json.dumps() or set headers by hand.
new_todo = {"title": "Learn requests", "completed": False, "userId": 1}
post_response = requests.post(
    "https://jsonplaceholder.typicode.com/todos", json=new_todo, timeout=5
)
print(f"Status code: {post_response.status_code}")
print(f"Response JSON: {post_response.json()}")
print("(jsonplaceholder doesn't actually persist this - it just echoes the payload back with a fake new id)")

# --- Error handling -----------------------------------------------------------
print("\n--- Handling network errors with a timeout ---")
# requests.exceptions.RequestException is the base class for every error the
# library can raise (connection errors, timeouts, too-many-redirects, etc.),
# so catching it is the standard way to handle "something went wrong with
# the network call" without needing to enumerate every specific subclass.
try:
    # This host doesn't exist, so this call is guaranteed to fail - it
    # demonstrates the try/except pattern without depending on flaky timing.
    requests.get("https://this-host-does-not-exist.invalid/", timeout=5)
except requests.exceptions.RequestException:
    print("Caught expected error: request to an unreachable host failed as expected")
