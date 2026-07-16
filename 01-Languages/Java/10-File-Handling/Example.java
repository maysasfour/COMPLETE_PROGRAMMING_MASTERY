// Example.java - text file I/O with java.nio.file.Files, and handling a missing file.

import java.nio.file.*;
import java.io.IOException;

public class Example {
    public static void main(String[] args) throws IOException {
        Path path = Path.of(System.getProperty("java.io.tmpdir"), "example-notes.txt");

        System.out.println("--- text file round-trip ---");
        Files.writeString(path, "Hello, file system!\n");
        String contents = Files.readString(path);
        System.out.println("Read back: " + contents.trim());

        System.out.println("\n--- missing file handled with a specific exception ---");
        try {
            Files.readString(Path.of(System.getProperty("java.io.tmpdir"), "does-not-exist-example.txt"));
        } catch (NoSuchFileException e) {
            System.out.println("File doesn't exist -- using defaults, handled gracefully");
        }

        Files.delete(path);
        System.out.println("\nCleaned up temporary file.");
    }
}
