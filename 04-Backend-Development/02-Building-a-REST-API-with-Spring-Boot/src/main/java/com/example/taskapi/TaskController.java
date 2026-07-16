package com.example.taskapi;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

/**
 * The Spring Boot equivalent of Lesson 01's raw HttpServer -- but here, annotations
 * (@RestController, @GetMapping, etc.) declare the routing, and Spring handles JSON
 * serialization, request parsing, and response construction automatically.
 */
@RestController
@RequestMapping("/tasks")
public class TaskController {

    private final Map<Long, Task> tasks = new ConcurrentHashMap<>();
    private final AtomicLong nextId = new AtomicLong(1);

    @GetMapping
    public List<Task> listTasks() {
        return tasks.values().stream().toList(); // Spring serializes this List<Task> to a JSON array
    }

    @GetMapping("/{id}")
    public ResponseEntity<Task> getTask(@PathVariable Long id) {
        Task task = tasks.get(id);
        if (task == null) {
            return ResponseEntity.notFound().build(); // 404, matching Lesson 01's convention
        }
        return ResponseEntity.ok(task); // 200 with the task serialized as JSON
    }

    @PostMapping
    public ResponseEntity<Task> createTask(@RequestBody NewTaskRequest request) {
        if (request.title() == null || request.title().isBlank()) {
            return ResponseEntity.badRequest().build(); // 400 -- same validation as Lesson 01
        }
        long id = nextId.getAndIncrement();
        Task task = new Task(id, request.title(), false);
        tasks.put(id, task);
        return ResponseEntity.status(HttpStatus.CREATED).body(task); // 201 Created
    }

    @PutMapping("/{id}")
    public ResponseEntity<Task> updateTask(@PathVariable Long id, @RequestBody NewTaskRequest request) {
        if (!tasks.containsKey(id)) {
            return ResponseEntity.notFound().build();
        }
        Task updated = new Task(id, request.title(), tasks.get(id).done());
        tasks.put(id, updated);
        return ResponseEntity.ok(updated);
    }

    @PatchMapping("/{id}/complete")
    public ResponseEntity<Task> completeTask(@PathVariable Long id) {
        Task existing = tasks.get(id);
        if (existing == null) {
            return ResponseEntity.notFound().build();
        }
        Task completed = new Task(id, existing.title(), true);
        tasks.put(id, completed);
        return ResponseEntity.ok(completed);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTask(@PathVariable Long id) {
        if (tasks.remove(id) == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.noContent().build(); // 204, matching Lesson 01's convention
    }
}
