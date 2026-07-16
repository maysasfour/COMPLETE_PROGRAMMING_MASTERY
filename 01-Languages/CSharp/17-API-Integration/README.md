# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Make GET/POST requests with `HttpClient`.
- Deserialize a JSON response into a strongly-typed `record` with `System.Text.Json`.
- Know that `HttpClient` does not throw for a non-2xx response by default, and use `EnsureSuccessStatusCode()` when you want it to.

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Concept

`HttpClient` is the BCL's built-in HTTP client — no NuGet package needed, unlike database access (Lesson 16). Just like `fetch()` in the JavaScript/TypeScript courses, `HttpClient`'s async methods (`GetAsync`, `PostAsync`) **do not throw** for HTTP error statuses (404, 500) by default — only for genuine network-level failures. `EnsureSuccessStatusCode()` is the explicit opt-in for "throw if this wasn't a success," when that behavior is actually wanted.

## GET and JSON Deserialization

```csharp
using var client = new HttpClient();

var response = await client.GetAsync("https://api.example.com/todos/1");
Console.WriteLine(response.IsSuccessStatusCode); // true only for 2xx -- checked manually

string body = await response.Content.ReadAsStringAsync();
record Todo(int UserId, int Id, string Title, bool Completed);
Todo? todo = JsonSerializer.Deserialize<Todo>(body, new JsonSerializerOptions {
    PropertyNameCaseInsensitive = true // API JSON is camelCase; C# convention is PascalCase
});
```

`PropertyNameCaseInsensitive = true` bridges the naming convention mismatch between typical JSON (`camelCase`, matching JavaScript conventions) and C#'s `PascalCase` property names, without needing `[JsonPropertyName]` attributes on every property.

## POST with a JSON Body

```csharp
var newTodo = new { title = "Learn HttpClient", completed = false, userId = 1 };
var content = new StringContent(JsonSerializer.Serialize(newTodo), Encoding.UTF8, "application/json");
var response = await client.PostAsync("https://api.example.com/todos", content);
```

## `EnsureSuccessStatusCode()`

```csharp
var response = await client.GetAsync("https://api.example.com/todos/99999999"); // 404
// response.IsSuccessStatusCode is false, but the call above did NOT throw

try {
    response.EnsureSuccessStatusCode(); // explicitly opts into throwing for non-2xx
} catch (HttpRequestException e) {
    Console.WriteLine($"Request failed: {e.Message}");
}
```

## Detailed Example

See [example.cs](example.cs) — makes real network calls to the public `jsonplaceholder.typicode.com` test API (the same service used throughout the Python/JavaScript/TypeScript courses' equivalent lessons), demonstrating a validated GET, the 404-doesn't-throw trap, a POST, and `EnsureSuccessStatusCode()` throwing when explicitly invoked.

## Expected Output

Running `dotnet run example.cs` (requires internet access) prints a real, deserialized `Todo` record, confirms a 404 response doesn't throw by default (`IsSuccessStatusCode: False`, no exception), shows a POST's echoed-back response body, and confirms `EnsureSuccessStatusCode()` does throw `HttpRequestException` when explicitly called on that same 404 response.

## Common Mistakes

- Assuming `GetAsync`/`PostAsync` throw for a 404/500 the way some other HTTP client libraries do — they don't, by design; `IsSuccessStatusCode` must be checked, or `EnsureSuccessStatusCode()` called explicitly.
- Forgetting `PropertyNameCaseInsensitive` (or `[JsonPropertyName]` attributes) when the API's JSON uses `camelCase` and the C# record uses `PascalCase` — silently leaves every property at its default value (`0`, `null`, `false`) instead of the actual response data.
- Creating a new `HttpClient` per request instead of reusing one instance — each `HttpClient` holds its own connection pool, and creating many short-lived instances can exhaust available sockets under load (a well-known .NET gotcha, mitigated in ASP.NET Core apps via `IHttpClientFactory`).

## Best Practices

- Reuse a single `HttpClient` instance (or use `IHttpClientFactory` in ASP.NET Core) rather than creating a new one per request.
- Check `IsSuccessStatusCode` or call `EnsureSuccessStatusCode()` explicitly — never assume a non-throwing call means success.
- Use `PropertyNameCaseInsensitive = true` (or explicit `[JsonPropertyName]` attributes) whenever consuming JSON from an API using a different casing convention than C#.

## Real-World Usage

`HttpClient` combined with `System.Text.Json` is the standard way ASP.NET Core services call other HTTP APIs (internal microservices, third-party integrations); `IHttpClientFactory` (a level beyond this lesson's scope) is the production-recommended way to manage `HttpClient` instances' lifetimes correctly at scale.

## Summary

- `HttpClient` is built into the BCL; its async methods don't throw for non-2xx responses by default.
- `EnsureSuccessStatusCode()` is the explicit opt-in for throwing on failure.
- `JsonSerializer.Deserialize<T>()` with `PropertyNameCaseInsensitive` bridges `camelCase` JSON and `PascalCase` C# records.

## Key Terms

- **`HttpClient`** — the BCL's built-in HTTP client for making requests.
- **`EnsureSuccessStatusCode()`** — throws `HttpRequestException` if the response status isn't 2xx; opt-in, not automatic.

## Interview Questions

1. **Does `HttpClient.GetAsync()` throw an exception for a 404 response?**
   No — like `fetch()` in JavaScript, `HttpClient`'s methods only throw for genuine network-level failures (DNS failure, connection refused). A 404/500 response is returned normally with `IsSuccessStatusCode` set to `false`; calling `EnsureSuccessStatusCode()` is the explicit way to convert that into a thrown `HttpRequestException`.

2. **Why is it a problem to create a new `HttpClient` for every request in a high-traffic application?**
   Each `HttpClient` instance manages its own underlying connection pool; creating and disposing many short-lived instances can exhaust the OS's available sockets under load (sockets can remain in a `TIME_WAIT` state after disposal), a well-documented .NET pitfall. The recommended fix is reusing a single long-lived `HttpClient` (or using `IHttpClientFactory` in ASP.NET Core, which manages pooling correctly).

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
