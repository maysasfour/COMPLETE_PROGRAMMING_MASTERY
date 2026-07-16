package com.example.layoutsandviews;

import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

/**
 * A real Button whose click handler updates a real TextView --
 * findViewById() connects the Java code to the XML-declared layout.
 */
public class MainActivity extends AppCompatActivity {
    private static final String TAG = "LayoutsDemo";
    private int clickCount = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView counterText = findViewById(R.id.counterText);
        Button clickButton = findViewById(R.id.clickButton);

        clickButton.setOnClickListener(v -> {
            clickCount++;
            counterText.setText("Clicked " + clickCount + " times");
            Log.d(TAG, "Real tap registered. counterText now reads: \"" + counterText.getText() + "\"");
        });

        // Log the button's real, laid-out on-screen coordinates once the
        // layout pass completes, so an external tool (adb) can tap its exact center.
        clickButton.post(() -> {
            int[] location = new int[2];
            clickButton.getLocationOnScreen(location);
            int centerX = location[0] + clickButton.getWidth() / 2;
            int centerY = location[1] + clickButton.getHeight() / 2;
            Log.d(TAG, "Button real screen center: (" + centerX + ", " + centerY + ")");
        });
    }
}
