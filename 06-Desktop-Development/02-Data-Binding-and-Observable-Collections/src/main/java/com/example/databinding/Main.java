package com.example.databinding;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.beans.binding.Bindings;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

/**
 * Data Binding and Observable Collections: JavaFX properties can be BOUND
 * together so one always reflects the other automatically -- verified live
 * with a real stale-display bug caused by manual, incomplete synchronization,
 * then fixed with real property binding. Also demonstrates an ObservableList
 * automatically keeping a ListView in sync when items are added.
 */
public class Main extends Application {

    @Override
    public void start(Stage stage) {
        System.out.println("=== Violation: manual sync via a mouse-drag handler, not a value listener ===");
        Slider sliderViolation = new Slider(0, 100, 50);
        Label labelViolation = new Label("Value: 50");
        // BUG: this only updates the label when the user physically DRAGS the
        // slider with the mouse -- it does NOT fire for programmatic changes
        // like slider.setValue(...), e.g. from a "Reset" button.
        sliderViolation.setOnMouseDragged(e -> labelViolation.setText("Value: " + (int) sliderViolation.getValue()));

        System.out.println("Simulating a 'Reset to 20' action via sliderViolation.setValue(20) (NOT a mouse drag):");
        sliderViolation.setValue(20);
        System.out.println("  Slider's actual value: " + (int) sliderViolation.getValue());
        System.out.println("  Label still displays:  " + labelViolation.getText() +
                "  <- BUG: label is STALE, because setValue() never triggers the mouse-drag handler!");

        System.out.println("\n=== Fixed: the label's text is BOUND directly to the slider's value ===");
        Slider sliderFixed = new Slider(0, 100, 50);
        Label labelFixed = new Label();
        // FIX: real property binding. This fires for ANY change to the
        // slider's value, whether from dragging OR a programmatic setValue()
        // call -- there's no separate code path left to forget.
        labelFixed.textProperty().bind(Bindings.format("Value: %.0f", sliderFixed.valueProperty()));

        System.out.println("Simulating the SAME 'Reset to 20' action via sliderFixed.setValue(20):");
        sliderFixed.setValue(20);
        System.out.println("  Slider's actual value: " + (int) sliderFixed.getValue());
        System.out.println("  Label now displays:    " + labelFixed.getText() + "  <- correct: bound label can never go stale");

        System.out.println("\n=== ObservableList automatically keeps a ListView in sync ===");
        ObservableList<String> items = FXCollections.observableArrayList("Buy milk", "Walk the dog");
        ListView<String> listView = new ListView<>(items);
        System.out.println("Initial ListView items: " + listView.getItems());

        items.add("Write JavaFX lesson"); // no manual "refresh the UI" call needed anywhere
        System.out.println("After items.add(\"Write JavaFX lesson\"), ListView items: " + listView.getItems() +
                "  <- correct: the ListView updated automatically because it's backed by the SAME ObservableList");

        VBox root = new VBox(10, sliderFixed, labelFixed, listView);
        Scene scene = new Scene(root, 300, 250);
        stage.setTitle("Data Binding and Observable Collections");
        stage.setScene(scene);
        stage.show();
        System.out.println("\nWindow shown.");

        new Thread(() -> {
            try { Thread.sleep(3000); } catch (InterruptedException ignored) {}
            Platform.runLater(() -> {
                stage.close();
                System.out.println("Window closed programmatically.");
                Platform.exit();
            });
        }).start();
    }

    public static void main(String[] args) {
        launch(args);
    }
}
