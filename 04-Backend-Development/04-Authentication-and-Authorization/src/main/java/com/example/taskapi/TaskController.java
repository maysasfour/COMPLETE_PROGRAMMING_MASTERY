package com.example.taskapi;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/tasks")
public class TaskController {

    private final TaskRepository repository;

    public TaskController(TaskRepository repository) {
        this.repository = repository;
    }

    // Every endpoint in this controller requires AUTHENTICATION (enforced centrally in
    // SecurityConfig, not per-method) -- but DELETE additionally requires the ADMIN ROLE
    // specifically, via @PreAuthorize, demonstrating AUTHORIZATION as a separate concern
    // layered on top of authentication: being logged in isn't the same as being ALLOWED
    // to do everything.

    @GetMapping
    public List<Task> listTasks() {
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Task> getTask(@PathVariable Long id) {
        return repository.findById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Task> createTask(@RequestBody NewTaskRequest request) {
        if (request.title() == null || request.title().isBlank()) {
            return ResponseEntity.badRequest().build();
        }
        Task saved = repository.save(new Task(request.title(), false));
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')") // AUTHORIZATION: only ADMIN users may delete, verified live
    public ResponseEntity<Void> deleteTask(@PathVariable Long id) {
        if (!repository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        repository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
