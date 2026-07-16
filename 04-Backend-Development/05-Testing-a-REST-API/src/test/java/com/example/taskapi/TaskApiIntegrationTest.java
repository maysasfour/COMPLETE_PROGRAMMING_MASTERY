package com.example.taskapi;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.resttestclient.TestRestTemplate;
import org.springframework.boot.resttestclient.autoconfigure.AutoConfigureTestRestTemplate;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * An INTEGRATION test: @SpringBootTest boots the FULL application context (web layer,
 * TaskRepository, Hibernate, an embedded H2 database) on a real, random port, and
 * TestRestTemplate makes REAL HTTP calls against it -- exercising the entire stack
 * end-to-end, unlike TaskControllerUnitTest's mocked repository. Slower (a full Spring
 * context + database must actually start), but catches bugs a unit test's mocked
 * repository could never find -- like a genuinely wrong JPA query or a schema mismatch.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureTestRestTemplate // Spring Boot 4.x: TestRestTemplate moved to its own module and
                                  // is no longer auto-registered by @SpringBootTest alone
class TaskApiIntegrationTest {

    @LocalServerPort
    private int port;

    @Autowired
    private TestRestTemplate restTemplate;

    private String url(String path) {
        return "http://localhost:" + port + path;
    }

    @Test
    void fullCrudLifecycle_worksAgainstARealDatabase() {
        // CREATE
        ResponseEntity<Task> createResponse = restTemplate.postForEntity(
                url("/tasks"), new NewTaskRequest("Integration test task"), Task.class);
        assertThat(createResponse.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        Long id = createResponse.getBody().getId();
        assertThat(id).isNotNull();

        // READ
        ResponseEntity<Task> getResponse = restTemplate.getForEntity(url("/tasks/" + id), Task.class);
        assertThat(getResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(getResponse.getBody().getTitle()).isEqualTo("Integration test task");
        assertThat(getResponse.getBody().isDone()).isFalse();

        // UPDATE (complete)
        ResponseEntity<Task> patchResponse = restTemplate.exchange(
                url("/tasks/" + id + "/complete"), org.springframework.http.HttpMethod.PATCH, null, Task.class);
        assertThat(patchResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(patchResponse.getBody().isDone()).isTrue();

        // DELETE
        restTemplate.delete(url("/tasks/" + id));
        ResponseEntity<Task> afterDelete = restTemplate.getForEntity(url("/tasks/" + id), Task.class);
        assertThat(afterDelete.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
    }

    @Test
    void creatingTaskWithBlankTitle_returns400() {
        ResponseEntity<Task> response = restTemplate.postForEntity(
                url("/tasks"), new NewTaskRequest(""), Task.class);
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
    }

    @Test
    void gettingNonexistentTask_returns404() {
        ResponseEntity<Task> response = restTemplate.getForEntity(url("/tasks/999999"), Task.class);
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
    }
}
