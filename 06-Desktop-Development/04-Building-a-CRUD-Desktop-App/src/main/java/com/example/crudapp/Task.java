package com.example.crudapp;

import javafx.beans.property.SimpleBooleanProperty;
import javafx.beans.property.SimpleStringProperty;

/**
 * A real JavaFX "bean" using Property fields (not plain String/boolean) --
 * this is what lets a TableColumn's PropertyValueFactory observe changes and
 * keep the TableView's display automatically in sync (see Lesson 02).
 */
public class Task {
    private final SimpleStringProperty name;
    private final SimpleBooleanProperty done;

    public Task(String name, boolean done) {
        this.name = new SimpleStringProperty(name);
        this.done = new SimpleBooleanProperty(done);
    }

    public String getName() { return name.get(); }
    public void setName(String value) { name.set(value); }
    public SimpleStringProperty nameProperty() { return name; }

    public boolean isDone() { return done.get(); }
    public void setDone(boolean value) { done.set(value); }
    public SimpleBooleanProperty doneProperty() { return done; }

    @Override
    public String toString() {
        return (isDone() ? "[x] " : "[ ] ") + getName();
    }
}
