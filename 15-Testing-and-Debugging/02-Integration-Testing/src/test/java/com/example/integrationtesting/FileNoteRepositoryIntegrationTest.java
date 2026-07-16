package com.example.integrationtesting;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import java.io.IOException;
import java.nio.file.Path;
import static org.junit.jupiter.api.Assertions.assertEquals;

// An INTEGRATION test: unlike 01-Unit-Testing's PriceCalculatorTest, this exercises
// FileNoteRepository against a REAL file on a REAL, temporary disk directory
// (JUnit 5's @TempDir) -- not a mock. This is deliberate: the bug this test catches
// ONLY appears with real file I/O timing; a unit test that mocked out the file
// system would never have caught it.
class FileNoteRepositoryIntegrationTest {

    @Test
    void savedNoteCanBeLoadedBackWithTheSameContent(@TempDir Path tempDir) throws IOException {
        FileNoteRepository repository = new FileNoteRepository();
        Path noteFile = tempDir.resolve("note.txt");

        repository.save(noteFile, "Buy milk");
        String loaded = repository.load(noteFile);

        assertEquals("Buy milk", loaded, "content read back from a REAL file should match what was saved");
    }
}
