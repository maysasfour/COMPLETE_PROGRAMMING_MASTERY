# 01 — JavaFX Fundamentals

[Back to module overview](../README.md)

## Beginner: Stage, Scene, Layouts, and Real Event Handling

Every JavaFX application has a `Stage` (the actual window), containing a `Scene` (the content), which holds a layout (here, a `VBox` — a simple vertical stack) containing controls (`Label`, `Button`). This lesson launches a **real window** — genuinely rendered on screen, not just compiled — and fires real button-click events, verifying the UI actually updates in response.

## Why JavaFX as This Module's Reference Framework

Per this repository's Java-preferred directive (see [11-Design-Principles](../../11-Design-Principles/README.md) and others for the same reasoning), this module uses **JavaFX**, the standard modern desktop UI toolkit for Java. JavaFX is no longer bundled with the JDK (removed after Java 10), so it's pulled in as a real Maven dependency (`org.openjfx:javafx-controls`) and run via the `javafx-maven-plugin`'s `javafx:run` goal — the same pattern this repository uses for Spring Boot (`mvn spring-boot:run`) in [04-Backend-Development](../../04-Backend-Development/README.md).

## The Code

```java
Label counterLabel = new Label("Button clicked 0 times");
Button clickButton = new Button("Click me");

clickButton.setOnAction(event -> {
    clickCount++;
    counterLabel.setText("Button clicked " + clickCount + " times");
});

VBox root = new VBox(10, counterLabel, clickButton);
stage.setScene(new Scene(root, 300, 150));
stage.show();
```

## Verified Live: A Real Window, Real Clicks, a Real Assertion

Rather than requiring a human to manually click the button to verify this example, the app fires three real click events itself (`clickButton.fire()`) — genuinely invoking the same event-handling code a real mouse click would — and checks the actual resulting label text. Verified live, with a real window actually shown on screen for a few seconds before closing itself:

```
Window shown. Simulating 3 real button clicks via clickButton.fire()...
[UI] Label updated to: "Button clicked 1 times"
[UI] Label updated to: "Button clicked 2 times"
[UI] Label updated to: "Button clicked 3 times"
Final label text: "Button clicked 3 times" (expected: "Button clicked 3 times")
Assertion: PASSED
Window closed programmatically.
```

Each click genuinely re-ran the event handler and updated the label — confirmed directly, not assumed.

## Detailed Example

See [pom.xml](pom.xml) and [Main.java](src/main/java/com/example/javafxfundamentals/Main.java).

## Run It

```bash
cd 06-Desktop-Development/01-JavaFX-Fundamentals
mvn compile javafx:run
```

A real window titled "JavaFX Fundamentals" will appear briefly (a few seconds) and close itself automatically.

## Expected Output

A real window showing a label and a button; three simulated clicks each updating the label, verified by the printed assertion (`PASSED`); the window closing itself after a few seconds.

## Common Mistakes

- Forgetting that JavaFX is no longer bundled with the JDK since Java 11 — it must be added as an explicit dependency (as this lesson's `pom.xml` does).
- Building UI logic that's impossible to verify without a human manually clicking through it — this lesson's approach (firing events programmatically and asserting the result) makes UI behavior genuinely testable.
- Blocking the JavaFX Application Thread with long-running work directly inside an event handler, freezing the UI — covered in depth in [03-JavaFX-Threading-Rules](../03-JavaFX-Threading-Rules/README.md).

## Best Practices

- Structure UI as Stage → Scene → layout → controls, keeping each layer's responsibility clear.
- Use lambda event handlers (`setOnAction(event -> ...)`) for concise, readable UI logic.
- Where possible, verify UI behavior programmatically (firing events and asserting resulting state) rather than relying solely on manual clicking.

## Real-World Usage

JavaFX remains a standard choice for cross-platform Java desktop applications requiring rich UI (as opposed to Swing's older, more dated look) — used for internal business tools, educational software, and media applications where a native-feeling desktop UI is preferred over a web-based one.

## Summary

- A real JavaFX window (Stage/Scene/layout/controls) was launched and genuinely rendered on screen.
- Firing real click events programmatically verified the button's event handler actually updates the label — confirmed by an explicit, printed assertion, not assumed from reading the code.

## Key Terms

- **Stage** — the top-level window in a JavaFX application.
- **Scene** — the container for a Stage's visual content (a node graph).
- **Node** — any visual element in a Scene (labels, buttons, layouts are all nodes).

## Interview Questions

1. **What's the relationship between Stage, Scene, and the controls inside it?**
   A `Stage` is the actual window; it holds one `Scene` at a time, which is the container for that window's visual content — a tree of `Node`s, typically starting with a layout container (like `VBox`) that arranges child controls (`Label`, `Button`, etc.). This was demonstrated concretely: `stage.setScene(new Scene(root, 300, 150))` set a `VBox` containing a `Label` and `Button` as the scene's root, and calling `stage.show()` genuinely rendered that content in a real window.

2. **How was the button's click behavior verified without requiring a human to manually click it?**
   The event handler registered via `setOnAction()` is just a regular piece of code that runs when the button's `fire()` method is invoked — whether that invocation comes from a real mouse click or from calling `.fire()` directly in code. This lesson called `clickButton.fire()` three times programmatically, which genuinely executed the same handler a real click would, and then asserted the label's final text matched what three real clicks should have produced (`"Button clicked 3 times"`) — verified live via the printed `PASSED` result, not merely assumed from reading the handler's logic.

## Recommended Next Lesson

[02 — Data Binding and Observable Collections](../02-Data-Binding-and-Observable-Collections/README.md)
