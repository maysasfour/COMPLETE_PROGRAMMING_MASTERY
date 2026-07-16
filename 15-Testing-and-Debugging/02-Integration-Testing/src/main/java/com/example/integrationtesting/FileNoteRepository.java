package com.example.integrationtesting;

import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class FileNoteRepository {
    public void save(Path file, String content) throws IOException {
        try (FileWriter writer = new FileWriter(file.toFile())) {
            writer.write(content); // try-with-resources guarantees flush+close, even if write() throws
        }
    }

    public String load(Path file) throws IOException {
        return Files.readString(file);
    }
}
