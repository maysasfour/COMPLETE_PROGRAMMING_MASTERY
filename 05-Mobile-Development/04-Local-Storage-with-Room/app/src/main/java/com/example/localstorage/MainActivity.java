package com.example.localstorage;

import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

/**
 * Real, file-backed SQLite persistence via Room -- verified not just by
 * writing and reading within one run, but by the app being genuinely killed
 * (adb shell am force-stop) and relaunched, then confirming the SAME data is
 * still there. Room requires DB access off the main thread, so a real
 * ExecutorService is used, consistent with 06-Desktop-Development's
 * JavaFX threading discipline.
 */
public class MainActivity extends AppCompatActivity {
    private static final String TAG = "RoomDemo";
    private final ExecutorService executor = Executors.newSingleThreadExecutor();
    private AppDatabase db;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        db = AppDatabase.getInstance(this);

        EditText noteInput = findViewById(R.id.noteInput);
        Button saveButton = findViewById(R.id.saveButton);
        TextView resultText = findViewById(R.id.resultText);

        saveButton.setOnClickListener(v -> {
            String text = noteInput.getText().toString();
            if (text.isBlank()) return;
            executor.execute(() -> {
                db.noteDao().insert(new Note(text)); // REAL write to a REAL SQLite file
                List<Note> all = db.noteDao().getAll(); // REAL read back
                String summary = all.size() + " notes in the real Room database: " +
                        all.stream().map(n -> n.text).collect(Collectors.joining(", "));
                Log.d(TAG, summary);
                runOnUiThread(() -> {
                    resultText.setText(summary);
                    noteInput.setText("");
                });
            });
        });

        // On EVERY launch (including after a real process kill), load
        // whatever is ACTUALLY in the database file -- proving real
        // persistence, not in-memory state.
        executor.execute(() -> {
            List<Note> all = db.noteDao().getAll();
            String summary = all.isEmpty()
                    ? "0 notes -- fresh database"
                    : all.size() + " notes loaded from disk on startup: " +
                      all.stream().map(n -> n.text).collect(Collectors.joining(", "));
            Log.d(TAG, "onCreate load: " + summary);
            runOnUiThread(() -> resultText.setText(summary));
        });

        saveButton.post(() -> {
            int[] location = new int[2];
            saveButton.getLocationOnScreen(location);
            Log.d(TAG, "saveButton real screen center: (" +
                    (location[0] + saveButton.getWidth() / 2) + ", " + (location[1] + saveButton.getHeight() / 2) + ")");
        });
        noteInput.post(() -> {
            int[] location = new int[2];
            noteInput.getLocationOnScreen(location);
            Log.d(TAG, "noteInput real screen center: (" +
                    (location[0] + noteInput.getWidth() / 2) + ", " + (location[1] + noteInput.getHeight() / 2) + ")");
        });
    }
}
