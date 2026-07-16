package com.example.restintegration;

import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * A REAL network call from the Android emulator to a REAL HTTP server running
 * on the HOST machine, reached via the emulator's special host alias
 * "10.0.2.2". Demonstrates BOTH a real connection failure (server not yet
 * running) and a real successful fetch (server running) -- genuine network
 * behavior, not simulated.
 */
public class MainActivity extends AppCompatActivity {
    private static final String TAG = "RestDemo";
    private static final String API_URL = "http://10.0.2.2:8090/api/greeting";
    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button fetchButton = findViewById(R.id.fetchButton);
        TextView resultText = findViewById(R.id.resultText);

        fetchButton.setOnClickListener(v -> executor.execute(() -> {
            String result;
            try {
                URL url = new URL(API_URL);
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setConnectTimeout(3000);
                connection.setReadTimeout(3000);
                connection.setRequestMethod("GET");

                int status = connection.getResponseCode();
                StringBuilder response = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(
                        new InputStreamReader(connection.getInputStream()))) {
                    String line;
                    while ((line = reader.readLine()) != null) response.append(line);
                }
                result = "HTTP " + status + ": " + response;
                Log.d(TAG, "Real network call SUCCEEDED: " + result);
            } catch (Exception e) {
                result = "Real network error: " + e.getClass().getSimpleName() + ": " + e.getMessage();
                Log.d(TAG, result);
            }
            String finalResult = result;
            runOnUiThread(() -> resultText.setText(finalResult));
        }));

        fetchButton.post(() -> {
            int[] location = new int[2];
            fetchButton.getLocationOnScreen(location);
            Log.d(TAG, "fetchButton real screen center: (" +
                    (location[0] + fetchButton.getWidth() / 2) + ", " + (location[1] + fetchButton.getHeight() / 2) + ")");
        });
    }
}
