# 02 — Building a REST API with Spring Boot

[Back to module overview](../README.md) | [Previous: REST API Fundamentals](../01-REST-API-Fundamentals/README.md)

## Beginner: From Raw HTTP to a Framework

Lesson 01 built a REST API using nothing but the JDK's `com.sun.net.httpserver`, routing requests with a manual `switch` on the HTTP method and parsing the path by hand. Spring Boot automates all of that: annotations declare routing, JSON serialization happens automatically via Jackson (bundled with `spring-boot-starter-web`), and `ResponseEntity` expresses status codes directly in code, without manually calling `sendResponseHeaders`.

```java
@RestController
@RequestMapping("/tasks")
public class TaskController {

    @GetMapping("/{id}")
    public ResponseEntity<Task> getTask(@PathVariable Long id) {
        Task task = tasks.get(id);
        if (task == null) {
            return ResponseEntity.notFound().build(); // 404
        }
        return ResponseEntity.ok(task); // 200, serialized to JSON automatically
    }
}
```

`@RestController` marks the class as handling HTTP requests and returning response bodies directly (rather than view names, as a traditional MVC controller would); `@RequestMapping("/tasks")` sets the base path for every method in the class; `@GetMapping("/{id}")` maps `GET /tasks/{id}` specifically, with `@PathVariable` extracting `{id}` directly into a typed `Long` parameter.

## Beginner: Records as Request/Response Shapes

```java
public record Task(Long id, String title, boolean done) {}
public record NewTaskRequest(String title) {}
```

Java `record`s (16+) are a natural fit for JSON request/response bodies: Spring's Jackson integration serializes/deserializes them automatically, with the record's canonical constructor, accessors, `equals`/`hashCode`/`toString` all generated for free. `NewTaskRequest` is deliberately a separate, smaller shape from `Task` — a client creating a task supplies only a `title`, never an `id` (server-assigned) or `done` (defaults to `false`).

## Intermediate: Full CRUD, Verified Live

```java
@PostMapping
public ResponseEntity<Task> createTask(@RequestBody NewTaskRequest request) {
    if (request.title() == null || request.title().isBlank()) {
        return ResponseEntity.badRequest().build(); // 400
    }
    Task task = new Task(nextId.getAndIncrement(), request.title(), false);
    tasks.put(task.id(), task);
    return ResponseEntity.status(HttpStatus.CREATED).body(task); // 201
}
```

Verified live against a running instance of this lesson's `TaskApiApplication`:

```
POST /tasks {"title":"Write lesson"}           -> 201, {"id":1,"title":"Write lesson","done":false}
POST /tasks {"title":""}                       -> 400 (empty body)
GET  /tasks/1                                   -> 200, {"id":1,"title":"Write lesson","done":false}
GET  /tasks/99                                   -> 404 (empty body)
PUT  /tasks/1 {"title":"Write lesson (updated)"} -> 200, {"id":1,"title":"Write lesson (updated)","done":false}
PATCH /tasks/1/complete                            -> 200, {"id":1,"title":"Write lesson (updated)","done":true}
DELETE /tasks/1                                       -> 204 (empty body)
GET  /tasks/1 (after delete)                            -> 404 (empty body)
```

Every response was produced by a real, running Spring Boot server via `curl` — including automatic `Task` → JSON serialization for every response and JSON → `NewTaskRequest` deserialization for every request body, with zero manual parsing code anywhere in `TaskController`.

## Advanced: `@PatchMapping` for Partial Updates

```java
@PatchMapping("/{id}/complete")
public ResponseEntity<Task> completeTask(@PathVariable Long id) {
    Task existing = tasks.get(id);
    if (existing == null) return ResponseEntity.notFound().build();
    Task completed = new Task(id, existing.title(), true);
    tasks.put(id, completed);
    return ResponseEntity.ok(completed);
}
```

`PATCH` is conventionally used for *partial* updates (changing just one field), contrasted with `PUT`'s convention of replacing the entire resource. This lesson models "mark a task complete" as its own small, specific `PATCH` endpoint rather than requiring a full `PUT` with every field re-supplied — a common, idiomatic REST design choice for state-transition-style operations.

## Detailed Example

See [pom.xml](pom.xml), [TaskApiApplication.java](src/main/java/com/example/taskapi/TaskApiApplication.java), [Task.java](src/main/java/com/example/taskapi/Task.java), [NewTaskRequest.java](src/main/java/com/example/taskapi/NewTaskRequest.java), and [TaskController.java](src/main/java/com/example/taskapi/TaskController.java) — a full CRUD REST API, verified live end-to-end.

## Run It

```bash
cd 04-Backend-Development/02-Building-a-REST-API-with-Spring-Boot
mvn spring-boot:run
# in another terminal:
curl -H "Content-Type: application/json" -X POST -d '{"title":"Write lesson"}' http://localhost:8090/tasks
curl http://localhost:8090/tasks/1
```

(Requires Maven; `server.port=8090` is set in `application.properties` to avoid conflicting with other locally-running services.)

## Expected Output

Running the commands above prints a JSON-serialized `Task` for a successful creation/read, and the documented status codes above for every other operation — all confirmed against a real, running server in this lesson's own verification.

## Common Mistakes

- Forgetting `@RequestBody` on a method parameter meant to be parsed from the JSON request body — without it, Spring won't populate that parameter from the incoming payload at all.
- Using `@PathVariable` with a mismatched type (e.g., expecting `String` when the path segment should be a numeric ID) — Spring will attempt automatic conversion, but a genuinely invalid value produces a `400` before your handler method even runs.
- Reaching for `PUT` when a partial update was actually intended — `PUT` conventionally means "replace the whole resource"; `PATCH` (as used for `completeTask` here) is the conventional choice for partial changes.

## Best Practices

- Use `ResponseEntity<T>` to control the exact status code returned, rather than always returning `200` implicitly.
- Keep request/response shapes as dedicated `record`s (or DTOs) rather than exposing internal domain objects directly — `NewTaskRequest` deliberately excludes fields a client shouldn't be able to set directly (`id`, `done`).
- Use `@PatchMapping` for small, specific state-transition operations (like marking a task complete) instead of forcing every partial change through a full `PUT`.

## Real-World Usage

Spring Boot (and its Spring MVC foundation) is one of the most widely used frameworks for building production Java REST APIs — the annotation-driven routing and automatic JSON handling demonstrated in this lesson are exactly what real Spring Boot microservices use, typically layered with a service class and a database-backed repository (Lesson 03) rather than the in-memory `Map` used here for simplicity.

## Summary

- `@RestController`/`@RequestMapping`/`@GetMapping`/etc. declare routing directly via annotations, replacing Lesson 01's manual method/path parsing.
- Java `record`s serve naturally as JSON request/response shapes, with Spring's Jackson integration handling serialization automatically.
- `ResponseEntity<T>` expresses the exact status code and body for each outcome — verified live to produce the same 200/201/400/404/204 conventions established in Lesson 01, now via a real framework.

## Key Terms

- **`@RestController`** — marks a class as handling HTTP requests directly, returning response bodies (not view names).
- **`ResponseEntity<T>`** — a Spring type wrapping a response body together with an explicit HTTP status code and headers.
- **DTO (Data Transfer Object)** — a dedicated class/record shaping data specifically for a request/response boundary, distinct from internal domain models.

## Interview Questions

1. **What does `@RestController` do differently from a traditional Spring `@Controller`?**
   `@RestController` is a convenience annotation combining `@Controller` and `@ResponseBody` — every method's return value is serialized directly into the HTTP response body (as JSON, by default, via Jackson), rather than being interpreted as the name of a view template to render. This is the standard choice for building JSON-based REST APIs, as opposed to traditional server-rendered HTML applications.

2. **Why does this lesson use a separate `NewTaskRequest` record instead of accepting a `Task` directly in `createTask`?**
   `Task` includes an `id` and a `done` flag — fields a client shouldn't be supplying when creating a new task (the `id` is server-assigned, and a new task should always start as not-done). Accepting `Task` directly would let a malicious or careless client supply an arbitrary `id` or set `done: true` immediately upon creation. `NewTaskRequest` deliberately exposes only the field a client should actually control (`title`), with the server constructing the full `Task` (assigning the `id`, defaulting `done` to `false`) — a genuine security/correctness practice, not just a stylistic preference.

## Recommended Next Lesson

[03 — Data Persistence with Spring Data JPA](../03-Data-Persistence-with-Spring-Data-JPA/README.md)
