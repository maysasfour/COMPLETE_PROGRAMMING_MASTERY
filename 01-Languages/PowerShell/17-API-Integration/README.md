# 17 - API Integration

[Back to course overview](../README.md) | Previous: [16 - Database Access](../16-Database-Access/README.md) | Next: [18 - Testing](../18-Testing/README.md)

## What / Why / Where

`Invoke-RestMethod` is PowerShell's genuinely convenient built-in HTTP+JSON client - it
automatically parses a JSON response into a real PowerShell object. `Invoke-WebRequest`
gives you the raw HTTP response (status code, headers, raw string content) instead. Both
were run live against `https://jsonplaceholder.typicode.com`, which this environment had
real outbound internet access to reach.

## Verified Live

```
Invoke-RestMethod .../posts/1        -> real PSCustomObject, .title directly accessible
Invoke-WebRequest  .../posts/1       -> StatusCode 200, raw Content string needing manual ConvertFrom-Json
Invoke-RestMethod -Method Post ...   -> created post echoed back with id 101
Invoke-RestMethod .../posts/999999 -ErrorAction Stop  -> caught: "(404) Not Found"
```

## Advantages / Disadvantages

- Advantage: `Invoke-RestMethod` eliminates a manual `ConvertFrom-Json` step for typical JSON APIs.
- Advantage: both cmdlets support `-Method`, `-Body`, `-Headers`, `-ContentType` for full REST verb coverage.
- Disadvantage: `Invoke-RestMethod` throws (rather than returning a response object) on non-2xx status codes by default - callers must use `try/catch` (with `-ErrorAction Stop`, verified live) for error responses.

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md) and outbound internet access (confirmed available in this environment).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Using `Invoke-WebRequest` and manually parsing JSON when `Invoke-RestMethod` would do it automatically.
- Not wrapping `Invoke-RestMethod` calls in `try/catch` and being surprised by an unhandled exception on a 404/500 response.
- Forgetting `-ContentType "application/json"` on POST/PUT requests with a JSON body, causing the server to misinterpret the payload.

## Best Practices

- Use `Invoke-RestMethod` for typical JSON REST APIs; reach for `Invoke-WebRequest` only when you need raw headers/status/content.
- Always wrap external API calls in `try/catch` with `-ErrorAction Stop`.
- Set `-ContentType "application/json"` explicitly when sending a JSON body.

## Detailed Example

See [demo.ps1](demo.ps1) - every request/response above was captured from a real, live run against `jsonplaceholder.typicode.com`.

## Interview Questions

1. **What's the difference between `Invoke-RestMethod` and `Invoke-WebRequest`?** `Invoke-RestMethod` automatically parses a JSON (or XML) response body into a real PowerShell object; `Invoke-WebRequest` returns the raw HTTP response, requiring manual parsing of `.Content` - verified live: the same URL returned a directly-navigable `.title` property via `Invoke-RestMethod`, versus a raw JSON string via `Invoke-WebRequest` that needed an explicit `ConvertFrom-Json`.
2. **How do you handle an HTTP error response from `Invoke-RestMethod`?** Wrap the call in `try/catch` with `-ErrorAction Stop` - verified live: a request to a nonexistent resource (`/posts/999999`) correctly threw a catchable error containing `"(404) Not Found"`.

## Recommended Next Lesson

[18 - Testing](../18-Testing/README.md)
