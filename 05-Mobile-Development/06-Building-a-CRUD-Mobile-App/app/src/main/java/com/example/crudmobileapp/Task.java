package com.example.crudmobileapp;

import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity(tableName = "tasks")
public class Task {
    @PrimaryKey(autoGenerate = true)
    public int id;
    public String name;

    public Task(String name) {
        this.name = name;
    }
}
