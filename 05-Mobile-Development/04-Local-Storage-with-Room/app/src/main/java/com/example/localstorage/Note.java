package com.example.localstorage;

import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity(tableName = "notes")
public class Note {
    @PrimaryKey(autoGenerate = true)
    public int id;
    public String text;

    public Note(String text) {
        this.text = text;
    }
}
