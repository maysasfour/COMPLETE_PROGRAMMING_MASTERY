# Backend Development Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../04-Backend-Development/README.md)

## HTTP Status Codes
| Code | Meaning | Verified finding |
|---|---|---|
| 200 | OK | Standard success |
| 201 | Created | A new resource was created |
| 204 | No Content | Success, no body |
| 400 | Bad Request | Malformed request |
| 401 | Unauthorized | Not authenticated |
| 403 | Forbidden | Spring Security's actual default for unauthenticated requests, not 401 |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | An oversell attempt correctly rejected in [13-Software-Architecture/03](../../13-Software-Architecture/03-Microservices-Fundamentals/README.md) |

## Spring Boot Quick Reference (Java)
```java
@RestController
@RequestMapping("/tasks")
class TaskController {
    @GetMapping public List<Task> all() { return repo.findAll(); }
    @PostMapping public ResponseEntity<Task> create(@RequestBody NewTaskRequest req) {
        Task saved = repo.save(new Task(req.name()));
        return ResponseEntity.status(201).body(saved);
    }
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        repo.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}

@Entity class Task {
    @Id @GeneratedValue Long id;
    String name;
    boolean done;
}
interface TaskRepository extends JpaRepository<Task, Long> {
    List<Task> findByDoneFalse(); // derived query -- Spring generates the SQL
}
```

## JWT Authentication
```java
String token = Jwts.builder().subject(username).claim("role", "USER")
        .signWith(key).compact();
Claims claims = Jwts.parser().verifyWith(key).build()
        .parseSignedClaims(token).getPayload();
```
Authentication (is this token genuine?) and authorization (is this token allowed to do this?) are separate checks — verified live in [14-APIs-and-Integrations/03](../../14-APIs-and-Integrations/03-Authentication/README.md): a genuinely valid, correctly-signed read-only token was still correctly denied a write operation.

## Testing (JUnit 5 + Spring)
```java
@WebMvcTest(TaskController.class)
class TaskControllerUnitTest {
    @MockitoBean TaskRepository repo; // Spring Boot 4.x: MockBean was removed, use MockitoBean
    @Autowired MockMvc mvc;
}

@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@AutoConfigureTestRestTemplate
class TaskApiIntegrationTest {
    @Autowired TestRestTemplate rest;
}
```

See the [full Backend Development module](../../04-Backend-Development/README.md) for a complete, verified REST API built from zero framework up through Spring Boot, persistence, security, and testing.
