# 17 — API Integration

[Back to Bash course](../README.md)

## `curl` Against a Real API — Verified Live

Bash's near-universal HTTP tool is `curl` (present in this environment). We call `https://jsonplaceholder.typicode.com/todos/1`, a real, publicly available test API:

```bash
$ curl -s "https://jsonplaceholder.typicode.com/todos/1"
{
  "userId": 1,
  "id": 1,
  "title": "delectus aut autem",
  "completed": false
}

$ curl -s -o /dev/null -w "HTTP status: %{http_code}\n" "https://jsonplaceholder.typicode.com/todos/1"
HTTP status: 200
```

`-s` silences curl's own progress output; `-o /dev/null -w "..."` discards the body and prints only the formatted status code — a common idiom for health checks/status validation in scripts. Both requests were made live against the real API at the time this lesson was written.

## Parsing the Response: Which Tool Is Available — Verified Live

Checked live in this environment:

```bash
$ where jq
INFO: Could not find files for the given pattern(s).
```

`jq` is **not installed** here, so this lesson demonstrates the honest, dependency-free fallback that was actually run: extracting a field with `grep`/`sed` directly on the JSON text.

```bash
$ json='{"userId": 1, "id": 1, "title": "delectus aut autem", "completed": false}'
$ title=$(echo "$json" | grep -o '"title": *"[^"]*"' | sed -E 's/"title": *"([^"]*)"/\1/')
$ echo "title extracted: $title"
title extracted: delectus aut autem
```

This works for flat, single-line, simple JSON like the example above, but it is genuinely fragile: it breaks on nested objects, arrays, escaped quotes inside string values, or any structural JSON feature beyond a flat key-value pair. It is documented here as the honest fallback, not a recommendation for anything beyond throwaway scripts.

## The `jq` Approach, Documented (not runnable in this environment)

If `jq` were installed, the equivalent and far more robust extraction would be:

```bash
curl -s "https://jsonplaceholder.typicode.com/todos/1" | jq -r '.title'
# would print: delectus aut autem
```

`jq -r` extracts a field and prints it as raw text (no surrounding quotes); `jq` correctly handles arbitrarily nested JSON, arrays, escaping, and type coercion — none of which the `grep`/`sed` fallback above can be trusted with.

## Real Workflow: `curl` + Status Check + Extraction

```bash
#!/usr/bin/env bash
set -euo pipefail
URL="https://jsonplaceholder.typicode.com/todos/1"
status=$(curl -s -o /tmp/resp.json -w "%{http_code}" "$URL")
if [ "$status" != "200" ]; then
  echo "Request failed with status $status" >&2
  exit 1
fi
if command -v jq >/dev/null 2>&1; then
  jq -r '.title' /tmp/resp.json
else
  grep -o '"title": *"[^"]*"' /tmp/resp.json | sed -E 's/"title": *"([^"]*)"/\1/'
fi
rm -f /tmp/resp.json
```

This combines a real status-code check with a `command -v jq` availability check (the same idiom introduced in Lesson 16), falling back gracefully rather than assuming `jq` is present.

## Common Beginner Mistakes

- Assuming `curl` output is JSON-safe to `grep` for arbitrary field extraction in general — the fallback shown only works for simple, flat, single-line JSON.
- Not checking the HTTP status code before trying to parse a response body that may be an error page/message instead of the expected JSON.
- Forgetting `-s` on `curl` in a script, letting its progress meter pollute captured output.

## Best Practices

- Check for `jq` with `command -v jq` and use it when available; treat `grep`/`sed` JSON parsing as a last resort for genuinely simple, flat structures only.
- Always check the HTTP status code (`-w "%{http_code}"`) before assuming the response body is valid.
- Quote URLs and use `--fail` (curl's own flag to return a nonzero exit code on 4xx/5xx) for stricter scripts.

## Interview Questions

1. Why is Bash's `grep`/`sed`-based JSON parsing fundamentally unreliable for anything beyond flat, simple JSON?
2. How do you check the HTTP status code of a `curl` request without printing the full response headers?
3. What idiom would you use to make a script gracefully fall back when `jq` isn't installed?
