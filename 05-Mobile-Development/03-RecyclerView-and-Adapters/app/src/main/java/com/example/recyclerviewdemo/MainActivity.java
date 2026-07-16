package com.example.recyclerviewdemo;

import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import java.util.ArrayList;
import java.util.List;

/**
 * Demonstrates a REAL, common RecyclerView bug: modifying the backing list
 * without telling the Adapter is a structurally silent failure -- the data
 * changes, but the RecyclerView keeps showing the OLD content until it's
 * explicitly notified. Verified live via real screenshots and real taps on a
 * real emulator.
 */
public class MainActivity extends AppCompatActivity {
    private static final String TAG = "RecyclerDemo";
    private final List<String> items = new ArrayList<>(List.of("Item 1", "Item 2", "Item 3"));
    private ItemAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        RecyclerView recyclerView = findViewById(R.id.recyclerView);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        adapter = new ItemAdapter(items);
        recyclerView.setAdapter(adapter);

        Button addBrokenButton = findViewById(R.id.addBrokenButton);
        addBrokenButton.setOnClickListener(v -> {
            // BUG: the backing list is modified, but the adapter is never
            // told -- the RecyclerView has no way to know anything changed.
            items.add("Item " + (items.size() + 1) + " (added WITHOUT notify)");
            Log.d(TAG, "Backing list now has " + items.size() + " items, but adapter.getItemCount() reported to RecyclerView is STALE until notified");
        });

        Button addFixedButton = findViewById(R.id.addFixedButton);
        addFixedButton.setOnClickListener(v -> {
            items.add("Item " + (items.size() + 1) + " (added WITH notify)");
            adapter.notifyItemInserted(items.size() - 1); // correctly tells the RecyclerView to re-check
            Log.d(TAG, "Backing list now has " + items.size() + " items, adapter notified -- RecyclerView WILL update");
        });

        logButtonCenter(addBrokenButton, "addBrokenButton");
        logButtonCenter(addFixedButton, "addFixedButton");
    }

    private void logButtonCenter(Button button, String name) {
        button.post(() -> {
            int[] location = new int[2];
            button.getLocationOnScreen(location);
            int centerX = location[0] + button.getWidth() / 2;
            int centerY = location[1] + button.getHeight() / 2;
            Log.d(TAG, name + " real screen center: (" + centerX + ", " + centerY + ")");
        });
    }
}
