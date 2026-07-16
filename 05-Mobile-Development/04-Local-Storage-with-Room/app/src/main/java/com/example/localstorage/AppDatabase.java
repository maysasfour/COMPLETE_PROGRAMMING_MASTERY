package com.example.localstorage;

import android.content.Context;
import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

@Database(entities = {Note.class}, version = 1)
public abstract class AppDatabase extends RoomDatabase {
    public abstract NoteDao noteDao();

    private static volatile AppDatabase instance;

    // A REAL, file-backed SQLite database on the device (not in-memory) --
    // named "notes-db", so it genuinely persists across app restarts and
    // process kills, verified live in this lesson's README.
    public static AppDatabase getInstance(Context context) {
        if (instance == null) {
            synchronized (AppDatabase.class) {
                if (instance == null) {
                    instance = Room.databaseBuilder(context.getApplicationContext(),
                            AppDatabase.class, "notes-db").build();
                }
            }
        }
        return instance;
    }
}
