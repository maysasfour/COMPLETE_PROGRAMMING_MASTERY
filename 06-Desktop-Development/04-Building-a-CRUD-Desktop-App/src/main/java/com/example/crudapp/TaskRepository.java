package com.example.crudapp;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * A real, file-backed repository -- tasks are persisted as plain text
 * ("done|name" per line) to an actual file on disk, so they genuinely
 * survive beyond a single run of the application.
 */
public class TaskRepository {
    private final Path file;

    public TaskRepository(Path file) {
        this.file = file;
    }

    public List<Task> load() throws IOException {
        List<Task> tasks = new ArrayList<>();
        if (!Files.exists(file)) {
            return tasks;
        }
        for (String line : Files.readAllLines(file)) {
            if (line.isBlank()) continue;
            String[] parts = line.split("\\|", 2);
            tasks.add(new Task(parts[1], Boolean.parseBoolean(parts[0])));
        }
        return tasks;
    }

    public void save(List<Task> tasks) throws IOException {
        List<String> lines = new ArrayList<>();
        for (Task task : tasks) {
            lines.add(task.isDone() + "|" + task.getName());
        }
        Files.write(file, lines);
    }
}
