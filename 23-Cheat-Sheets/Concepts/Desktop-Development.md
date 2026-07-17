# Desktop Development (JavaFX) Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../06-Desktop-Development/README.md)

## Stage, Scene, and Controls
```java
public class Main extends Application {
    public void start(Stage stage) {
        Label label = new Label("Hello");
        Button button = new Button("Click me");
        button.setOnAction(e -> label.setText("Clicked!"));
        stage.setScene(new Scene(new VBox(10, label, button), 300, 150));
        stage.show();
    }
    public static void main(String[] args) { launch(args); }
}
```
See [06-Desktop-Development/01](../../06-Desktop-Development/01-JavaFX-Fundamentals/README.md) — verified live with a real window and real fired clicks.

## Data Binding and Observable Collections
```java
label.textProperty().bind(Bindings.format("Value: %.0f", slider.valueProperty()));
ObservableList<String> items = FXCollections.observableArrayList();
listView.setItems(items); // automatically stays in sync as items are added/removed
```
Manual sync through only one event handler goes stale on other paths — binding fixes this structurally. See [06-Desktop-Development/02](../../06-Desktop-Development/02-Data-Binding-and-Observable-Collections/README.md).

## Threading Rule
```java
Platform.runLater(() -> label.setText("Updated")); // ALWAYS marshal UI updates from background threads
```
Touching UI from a background thread throws a real `IllegalStateException` — but NOT at the call site; it's thrown asynchronously and surfaces only via the thread's uncaught exception handler. See [06-Desktop-Development/03](../../06-Desktop-Development/03-JavaFX-Threading-Rules/README.md).

## CRUD Pattern
```java
TableView<Task> table = new TableView<>(FXCollections.observableArrayList());
TableColumn<Task, String> nameCol = new TableColumn<>("Name");
nameCol.setCellValueFactory(new PropertyValueFactory<>("name"));
```
Use `SimpleStringProperty`/`SimpleBooleanProperty` (not plain fields) so `TableColumn` can observe changes. See [06-Desktop-Development/04](../../06-Desktop-Development/04-Building-a-CRUD-Desktop-App/README.md) — a full, verified Task Manager with real file persistence.

## Run It
```bash
mvn compile javafx:run
```

See the [full Desktop Development module](../../06-Desktop-Development/README.md) for verified, runnable JavaFX lessons on everything above.
