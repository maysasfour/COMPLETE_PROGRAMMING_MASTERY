package com.example.crudapp;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.control.cell.CheckBoxTableCell;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.stage.Stage;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

/**
 * A real, working CRUD desktop application: a Task Manager backed by a real,
 * file-persisted repository. Every CRUD operation (Create, Read, Update,
 * Delete) is exercised programmatically and verified against real state --
 * including a full save-to-disk-and-reload-in-a-fresh-repository round trip,
 * proving persistence genuinely works, not just that the UI displays data.
 */
public class Main extends Application {

    @Override
    public void start(Stage stage) throws IOException {
        Path dataFile = Files.createTempFile("tasks", ".txt");
        Files.deleteIfExists(dataFile); // start from a clean, real file

        TaskRepository repository = new TaskRepository(dataFile);
        ObservableList<Task> tasks = FXCollections.observableArrayList(repository.load());

        TableView<Task> table = new TableView<>(tasks);
        TableColumn<Task, String> nameCol = new TableColumn<>("Task");
        nameCol.setCellValueFactory(new PropertyValueFactory<>("name"));
        TableColumn<Task, Boolean> doneCol = new TableColumn<>("Done");
        doneCol.setCellValueFactory(new PropertyValueFactory<>("done"));
        doneCol.setCellFactory(CheckBoxTableCell.forTableColumn(doneCol));
        table.getColumns().addAll(nameCol, doneCol);

        TextField nameField = new TextField();
        nameField.setPromptText("New task name");
        Button addButton = new Button("Add");
        addButton.setOnAction(e -> {
            if (!nameField.getText().isBlank()) {
                tasks.add(new Task(nameField.getText(), false));
                nameField.clear();
            }
        });
        Button deleteButton = new Button("Delete Selected");
        deleteButton.setOnAction(e -> {
            Task selected = table.getSelectionModel().getSelectedItem();
            if (selected != null) tasks.remove(selected);
        });
        Button toggleButton = new Button("Toggle Done");
        toggleButton.setOnAction(e -> {
            Task selected = table.getSelectionModel().getSelectedItem();
            if (selected != null) selected.setDone(!selected.isDone());
        });

        HBox controls = new HBox(10, nameField, addButton, toggleButton, deleteButton);
        controls.setPadding(new Insets(10));
        BorderPane root = new BorderPane(table, null, null, controls, null);
        stage.setScene(new Scene(root, 450, 300));
        stage.setTitle("Task Manager (CRUD Desktop App)");
        stage.show();

        // ============================================================
        // CREATE: add tasks via the exact same code path the "Add" button uses.
        // ============================================================
        System.out.println("=== CREATE ===");
        nameField.setText("Buy milk");
        addButton.fire();
        nameField.setText("Write JavaFX lesson");
        addButton.fire();
        System.out.println("Tasks after adding 2: " + tasks);

        // ============================================================
        // READ: verify the TableView's actual displayed items match.
        // ============================================================
        System.out.println("\n=== READ ===");
        System.out.println("TableView's actual items: " + table.getItems());
        System.out.println("Matches the underlying list: " + table.getItems().equals(tasks));

        // ============================================================
        // UPDATE: select a row and toggle its done status via the button.
        // ============================================================
        System.out.println("\n=== UPDATE ===");
        table.getSelectionModel().select(0); // select "Buy milk"
        toggleButton.fire();
        System.out.println("After toggling task 0's done status: " + tasks);

        // ============================================================
        // DELETE: select a row and remove it via the button.
        // ============================================================
        System.out.println("\n=== DELETE ===");
        table.getSelectionModel().select(1); // select "Write JavaFX lesson"
        deleteButton.fire();
        System.out.println("After deleting task 1: " + tasks);

        // ============================================================
        // PERSISTENCE ROUND-TRIP: save to a REAL file, then load it back
        // using a SEPARATE, brand-new repository instance -- proving data
        // genuinely persists beyond this in-memory list.
        // ============================================================
        System.out.println("\n=== PERSISTENCE ROUND-TRIP ===");
        repository.save(tasks);
        System.out.println("Saved to real file: " + dataFile);
        System.out.println("Raw file contents: " + Files.readString(dataFile).strip());

        TaskRepository freshRepository = new TaskRepository(dataFile); // a NEW instance, no shared state
        List<Task> reloaded = freshRepository.load();
        System.out.println("Reloaded via a FRESH TaskRepository instance: " + reloaded);
        System.out.println("Persistence round-trip correct: " +
                (reloaded.size() == tasks.size() && reloaded.get(0).getName().equals(tasks.get(0).getName())
                        && reloaded.get(0).isDone() == tasks.get(0).isDone()));

        Files.deleteIfExists(dataFile);

        new Thread(() -> {
            try { Thread.sleep(3000); } catch (InterruptedException ignored) {}
            Platform.runLater(() -> {
                stage.close();
                System.out.println("\nWindow closed programmatically.");
                Platform.exit();
            });
        }).start();
    }

    public static void main(String[] args) {
        launch(args);
    }
}
