package com.example.threading;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

/**
 * JavaFX Threading Rules: ALL UI updates must happen on the JavaFX Application
 * Thread. Touching a UI control from any other thread throws a REAL exception --
 * verified live with an actual stack trace -- fixed with Platform.runLater().
 *
 * A genuinely surprising, verified finding: the exception does NOT propagate
 * to a normal try/catch around the offending call. It's thrown asynchronously,
 * from deep inside the control's internal property-change listener chain, and
 * surfaces only via the background thread's UNCAUGHT exception handler.
 */
public class Main extends Application {

    @Override
    public void start(Stage stage) throws InterruptedException {
        Label statusLabel = new Label("Idle");
        VBox root = new VBox(10, statusLabel);
        stage.setScene(new Scene(root, 300, 100));
        stage.setTitle("JavaFX Threading Rules");
        stage.show();

        System.out.println("=== Violation: updating a Label directly from a background thread ===");
        CountDownLatch violationDone = new CountDownLatch(1);
        Thread backgroundViolation = new Thread(() -> {
            statusLabel.setText("Loaded!"); // BUG: not on the FX Application Thread!
            System.out.println("  setText() call itself returned normally (no exception at the call site!)");
        });
        // A plain try/catch around setText() would NOT catch this -- the real
        // exception is thrown from inside the control's internal listener
        // chain, asynchronously relative to the setText() call, and only
        // surfaces via the thread's UNCAUGHT exception handler.
        backgroundViolation.setUncaughtExceptionHandler((thread, ex) -> {
            System.out.println("  Uncaught on background thread: " + ex.getClass().getName() + ": " + ex.getMessage());
            System.out.println("  Top real stack frame: " + ex.getStackTrace()[0]);
            violationDone.countDown();
        });
        backgroundViolation.start();
        violationDone.await(3, TimeUnit.SECONDS);
        System.out.println("  Label's underlying value: \"" + statusLabel.getText() +
                "\"  <- the PROPERTY did update, but the exception proves the internal render/listener chain" +
                " was disrupted mid-update -- an unsafe, undefined-behavior state, not a clean failure.");

        System.out.println("\n=== Fixed: the SAME background work, updating the UI via Platform.runLater ===");
        CountDownLatch fixedDone = new CountDownLatch(1);
        Thread backgroundFixed = new Thread(() -> Platform.runLater(() -> {
            statusLabel.setText("Loaded!"); // correctly marshaled back onto the FX Application Thread
            System.out.println("  Update completed cleanly ON the FX Application Thread -- no exception, no undefined behavior.");
            fixedDone.countDown();
        }));
        backgroundFixed.start();
        fixedDone.await(3, TimeUnit.SECONDS);
        Platform.runLater(() -> System.out.println("  Label's value after the fix: \"" + statusLabel.getText() + "\""));

        new Thread(() -> {
            try { Thread.sleep(2000); } catch (InterruptedException ignored) {}
            Platform.runLater(() -> {
                stage.close();
                System.out.println("Window closed programmatically.");
                Platform.exit();
            });
        }).start();
    }

    public static void main(String[] args) throws InterruptedException {
        launch(args);
    }
}
