package com.example.taskapi;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * A UNIT test: @WebMvcTest loads only the web layer (TaskController), NOT the whole
 * application context -- TaskRepository is replaced with a Mockito mock via @MockBean,
 * so this test never touches a real database at all. Fast (no Spring context for JPA/
 * Hibernate to build) and isolated (a bug in TaskRepository's real implementation could
 * never make this test fail, since it's not exercised here at all -- that's what
 * TaskApiIntegrationTest, using the REAL repository, is for).
 */
@WebMvcTest(TaskController.class)
class TaskControllerUnitTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private TaskRepository taskRepository;

    @Test
    void getTask_returnsTaskWhenFound() throws Exception {
        Task task = new Task("Write lesson", false);
        when(taskRepository.findById(1L)).thenReturn(Optional.of(task));

        mockMvc.perform(get("/tasks/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Write lesson"))
                .andExpect(jsonPath("$.done").value(false));
    }

    @Test
    void getTask_returns404WhenNotFound() throws Exception {
        when(taskRepository.findById(99L)).thenReturn(Optional.empty());

        mockMvc.perform(get("/tasks/99"))
                .andExpect(status().isNotFound());
    }

    @Test
    void createTask_returns201WithValidTitle() throws Exception {
        Task saved = new Task("New task", false);
        when(taskRepository.save(any(Task.class))).thenReturn(saved);

        mockMvc.perform(post("/tasks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"title\":\"New task\"}"))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.title").value("New task"));
    }

    @Test
    void createTask_returns400WithBlankTitle() throws Exception {
        mockMvc.perform(post("/tasks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"title\":\"\"}"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void listTasks_returnsAllTasksFromRepository() throws Exception {
        when(taskRepository.findAll()).thenReturn(
                List.of(new Task("Task A", false), new Task("Task B", true)));

        mockMvc.perform(get("/tasks"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[0].title").value("Task A"))
                .andExpect(jsonPath("$[1].done").value(true));
    }

    @Test
    void deleteTask_returns204WhenTaskExists() throws Exception {
        when(taskRepository.existsById(1L)).thenReturn(true);

        mockMvc.perform(delete("/tasks/1"))
                .andExpect(status().isNoContent());
    }

    @Test
    void deleteTask_returns404WhenTaskMissing() throws Exception {
        when(taskRepository.existsById(99L)).thenReturn(false);

        mockMvc.perform(delete("/tasks/99"))
                .andExpect(status().isNotFound());
    }
}
