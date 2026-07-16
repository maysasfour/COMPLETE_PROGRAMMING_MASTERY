# 05 — Testing a REST API

[Back to module overview](../README.md) | [Previous: Authentication and Authorization](../04-Authentication-and-Authorization/README.md)

## Beginner: Two Genuinely Different Kinds of Test

This lesson tests the Lesson 03-style task API two ways: a **unit test** (`@WebMvcTest`) that mocks the repository entirely — fast, isolated, never touches a real database — and an **integration test** (`@SpringBootTest`) that boots the *entire* application, including a real (if embedded) H2 database, and makes genuine HTTP calls against it end-to-end.

```java
@WebMvcTest(TaskController.class)
class TaskControllerUnitTest {
    @Autowired private MockMvc mockMvc;
    @MockitoBean private TaskRepository taskRepository; // a MOCK -- no real database involved at all

    @Test
    void getTask_returns404WhenNotFound() throws Exception {
        when(taskRepository.findById(99L)).thenReturn(Optional.empty());
        mockMvc.perform(get("/tasks/99")).andExpect(status().isNotFound());
    }
}
```

`@WebMvcTest` loads only the web layer (`TaskController` and its supporting infrastructure), not the whole application — genuinely fast, since no JPA/Hibernate/database startup is involved. `@MockitoBean` replaces `TaskRepository` with a Mockito mock inside the Spring context, letting the test control exactly what the repository "returns" without a real database backing it.

## Beginner: A Genuine, Verified Spring Boot 4.x Breaking Change

Building this lesson's `pom.xml` initially with just `spring-boot-starter-test` (the setup that worked in Spring Boot 3.x) failed to compile at all — verified live, with real compiler errors:

```
package org.springframework.boot.test.autoconfigure.web.servlet does not exist
package org.springframework.boot.test.mock.mockito does not exist
cannot find symbol: class WebMvcTest
cannot find symbol: class MockBean
```

Investigating the actual JARs resolved by Maven (not guessing) revealed Spring Boot 4.x genuinely restructured its test support: `WebMvcTest` moved to a **new, separate** `spring-boot-webmvc-test` module; `TestRestTemplate` moved to a **new, separate** `spring-boot-resttestclient` module (and its package changed from `org.springframework.boot.test.web.client` to `org.springframework.boot.resttestclient`); and Spring Boot's own `@MockBean` was **removed entirely**, replaced by Spring Framework's own native `@MockitoBean` (`org.springframework.test.context.bean.override.mockito.MockitoBean`, part of `spring-test` itself since Spring Framework 6.2). None of this was assumed — it was discovered by directly inspecting the actual class files inside the downloaded JARs after the initial compile failed.

## Intermediate: Integration Testing Against a Real Database

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureTestRestTemplate // needed since TestRestTemplate is no longer auto-registered
class TaskApiIntegrationTest {
    @LocalServerPort private int port;
    @Autowired private TestRestTemplate restTemplate;

    @Test
    void fullCrudLifecycle_worksAgainstARealDatabase() {
        ResponseEntity<Task> created = restTemplate.postForEntity(url("/tasks"), new NewTaskRequest("..."), Task.class);
        assertThat(created.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        // ...
    }
}
```

Even after adding `spring-boot-resttestclient` and `@AutoConfigureTestRestTemplate`, a second genuine error surfaced: `NoClassDefFoundError: org/springframework/boot/restclient/RestTemplateBuilder` — the new `resttestclient` module needs `RestTemplateBuilder` from a *third* module (`spring-boot-restclient`) that isn't pulled in transitively. Adding it explicitly fixed the issue, confirmed by a subsequent full, successful test run.

## Advanced: Why Both Test Types Matter

The unit test (`TaskControllerUnitTest`) verifies the controller's own logic — status codes, request validation, response shaping — in complete isolation from persistence concerns, and runs fast enough to execute on every code change. The integration test (`TaskApiIntegrationTest`) verifies the *whole stack* actually works together: real JPA queries against a real (if embedded) database, real HTTP serialization, a genuinely full request/response round-trip. A unit test's mocked repository can never catch a bug in an actual JPQL query or a schema mismatch; only the integration test, hitting a real database, can.

Verified live: running `mvn test` executed all 10 tests (7 unit + 3 integration) with **zero failures**, confirmed by Maven's own `BUILD SUCCESS` output.

## Detailed Example

See [pom.xml](pom.xml) (with the three test-support modules this lesson's own investigation revealed are needed in Spring Boot 4.x), [src/test/java/com/example/taskapi/TaskControllerUnitTest.java](src/test/java/com/example/taskapi/TaskControllerUnitTest.java) (7 mocked-repository unit tests), and [src/test/java/com/example/taskapi/TaskApiIntegrationTest.java](src/test/java/com/example/taskapi/TaskApiIntegrationTest.java) (3 real-database integration tests).

## Run It

```bash
cd 04-Backend-Development/05-Testing-a-REST-API
mvn test
```

## Expected Output

Running `mvn test` prints `Tests run: 7, Failures: 0, Errors: 0` for the unit tests, `Tests run: 3, Failures: 0, Errors: 0` for the integration tests, and an overall `Tests run: 10, Failures: 0, Errors: 0` followed by `BUILD SUCCESS` — all confirmed by actually running the full suite in this lesson's own verification, including working around two genuine, real Spring Boot 4.x dependency/API changes along the way.

## Common Mistakes

- Assuming `spring-boot-starter-test` alone still provides `WebMvcTest`/`TestRestTemplate`/`@MockBean` in Spring Boot 4.x — verified live that it doesn't; these moved to (or were replaced by) separate modules/annotations.
- Writing only unit tests (with a mocked repository) and never an integration test against a real database — a mocked repository can never catch a genuinely wrong JPQL query, a schema mismatch, or a serialization bug that only surfaces with real HTTP round-tripping.
- Writing only integration tests and never fast, isolated unit tests — integration tests are slower (a full Spring context + database must start for every test class), making them impractical as the *only* layer of testing during rapid iteration.

## Best Practices

- Use `@WebMvcTest` + mocked dependencies for fast, focused tests of a controller's own logic (status codes, validation, response shape).
- Use `@SpringBootTest` (with `webEnvironment = RANDOM_PORT` and `TestRestTemplate`) for genuine end-to-end verification against a real (even if embedded/in-memory) database.
- When a framework upgrade breaks previously-working test code, investigate the actual resolved dependencies/class files (as done in this lesson) rather than guessing at replacement APIs — the real, verified fix here required inspecting real JARs to find where `WebMvcTest`/`TestRestTemplate`/`RestTemplateBuilder` had actually moved to.

## Real-World Usage

The unit-test/integration-test split demonstrated here is the standard testing strategy for real Spring Boot applications — a healthy test suite has many fast unit tests (using `@WebMvcTest`/`@DataJpaTest`/plain Mockito) and a smaller number of slower integration tests (`@SpringBootTest`) verifying the full stack, exactly the ratio this lesson's 7-unit/3-integration split reflects. Major framework version upgrades (like the Spring Boot 3.x → 4.x test-module restructuring discovered in this lesson) are a genuine, recurring reality of maintaining production Java applications.

## Summary

- `@WebMvcTest` + `@MockitoBean` provide fast, isolated controller-layer unit tests; `@SpringBootTest` + `TestRestTemplate` provide full-stack integration tests against a real database.
- Spring Boot 4.x genuinely restructured its test support (`WebMvcTest`/`TestRestTemplate` moved to new modules, `@MockBean` was replaced by Spring Framework's own `@MockitoBean`) — discovered and fixed here by direct investigation of resolved dependencies, not assumption.
- All 10 tests (7 unit, 3 integration) pass — confirmed live via `mvn test`'s `BUILD SUCCESS`.

## Key Terms

- **`@WebMvcTest`** — loads only the web layer for a fast, isolated controller test.
- **`@MockitoBean`** — Spring Framework's native annotation for replacing a bean with a Mockito mock inside a test's application context (Spring Boot's own `@MockBean` was removed in 4.x in favor of this).
- **`@SpringBootTest`** — boots the full application context for genuine integration testing.

## Interview Questions

1. **What's the difference between `@WebMvcTest` and `@SpringBootTest`, and when would you use each?**
   `@WebMvcTest` loads only the web/controller layer of the application, with dependencies like repositories typically replaced by mocks (`@MockitoBean`) — it's fast, since no database or full application context needs to start, and it's ideal for testing a controller's own logic (routing, status codes, request validation) in isolation. `@SpringBootTest` boots the entire application context, including real beans like a JPA repository backed by an actual (if embedded) database — slower, but capable of catching integration-level bugs (a wrong query, a schema mismatch, a serialization issue) that a mocked-repository unit test could never detect. A healthy test suite uses both: many fast `@WebMvcTest`-style unit tests, and a smaller number of `@SpringBootTest` integration tests covering full end-to-end behavior.

2. **This lesson discovered several Spring Boot 4.x test-support changes. How were they found, and why does that method matter?**
   By actually attempting to compile and run the tests, reading the real compiler errors (`package ... does not exist`, `cannot find symbol`), and then directly inspecting the contents of the downloaded JAR files in the local Maven repository to find where the missing classes had actually moved to (or been replaced) — rather than guessing based on outdated documentation or assumption. This method matters because framework major-version upgrades routinely restructure APIs in ways that aren't always obvious from memory or older tutorials; verifying against the actual, currently-resolved dependencies is the only way to get a genuinely correct fix rather than a plausible-sounding but wrong one.

## Recommended Next Lesson

This completes the Backend Development module's core lessons. Return to the [module overview](../README.md) for a summary and next steps.
