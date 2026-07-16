# 06 — Desktop Development

[Back to repository root](../README.md)

## What Desktop Development Covers

This module covers building native desktop applications with JavaFX: windows and controls, data binding and observable collections, the single-UI-thread rule, and a complete CRUD application. Every lesson launches a **genuinely real window**, actually rendered on screen, verified via real captured output rather than described in the abstract.

## Why JavaFX as This Module's Reference Framework

Per this repository's Java-preferred directive (see [11-Design-Principles](../11-Design-Principles/README.md) and other modules for the same reasoning), this module uses **JavaFX** — the standard modern Java desktop UI toolkit. JavaFX is no longer bundled with the JDK (removed after Java 10), so it's pulled in as a real Maven dependency (`org.openjfx:javafx-controls` 26.0.1) and run via `mvn compile javafx:run`, mirroring this repository's Spring Boot lessons (`mvn spring-boot:run`) in [04-Backend-Development](../04-Backend-Development/README.md). A real window genuinely appears on screen for each lesson (a few seconds), then closes itself programmatically — verified live, with real captured console output at every step, not simulated or described.

## Why It Matters / Where It's Used

- **Desktop applications remain a real, common deployment target** for internal business tools, admin utilities, and applications needing rich, native-feeling UI beyond what a browser provides.
- **JavaFX's threading rule and data-binding model are genuinely subtle** — this module demonstrates a real threading violation whose exception surfaces in a surprising place (not a normal `try`/`catch`), and a real stale-display bug from manual UI synchronization, both verified live rather than described.
- **Interviews**: "how does JavaFX handle UI updates from background threads," "what's the difference between manual UI updates and data binding," and "how would you structure a CRUD desktop app" are realistic desktop-development interview questions, directly covered by this module's four lessons.

## Advantages of This Approach

- Every lesson launches a **genuinely real window** — this repository's usual "verify by actually running it" discipline extended to a visual, GUI context rather than only terminal/HTTP output.
- Lesson 03 uncovered a genuinely surprising, verified finding: a JavaFX threading violation's exception does **not** propagate to a normal `try`/`catch` around the offending call — it's thrown asynchronously and only surfaces via the background thread's uncaught exception handler, discovered through direct experimentation, not assumed from documentation.
- Lesson 04's CRUD app verifies persistence with a genuine round-trip through a brand-new repository instance sharing no in-memory state — real proof of persistence, not an assumption.

## Disadvantages / Trade-offs

- GUI applications are harder to verify in an automated way than CLI/HTTP-based code — this module's approach (firing real events/actions programmatically and asserting on real resulting state) makes this practical, but a human interactively using the app is still valuable additional verification beyond what's shown here.
- JavaFX's ecosystem and community are smaller than the web-development ecosystem this repository otherwise covers heavily — its long-term platform position (e.g., relative to Electron or native mobile) is a real consideration for new projects, beyond the scope of this module.

## How to Run the Examples

Each lesson is a self-contained Maven project using the `javafx-maven-plugin`.

```bash
cd 06-Desktop-Development/01-JavaFX-Fundamentals
mvn compile javafx:run
```

A real window will appear briefly (a few seconds) and close itself automatically — no manual interaction is required, though you're welcome to interact with it while it's open. Requires a JDK (this module was built and verified against JDK 25) and Apache Maven (verified against Maven 3.9.16, the same install used throughout this repository's Java-based modules). `target/` directories are not committed — recompile locally after cloning.

## Common Beginner Mistakes

- **Manually syncing UI state through one specific event handler instead of binding to the underlying property** — verified live in Lesson 02 to leave a display stale when the value changes through any other path.
- **Touching UI controls from a background thread** — verified live in Lesson 03 to throw a real exception that a normal `try`/`catch` around the call cannot catch, since it's thrown asynchronously from an internal listener chain.
- **Using plain `String`/`boolean` fields instead of JavaFX `Property` types** in a class backing a `TableView` — breaks the automatic UI-refresh behavior demonstrated in Lessons 02 and 04.
- **Verifying persistence by checking only that a file was written**, without a genuine reload through a fresh object instance — Lesson 04 demonstrates the stronger, correct verification.

## Best Practices

- Bind UI elements directly to the properties they represent, rather than manually syncing them through specific event handlers.
- Never touch UI controls from any thread other than the JavaFX Application Thread; use `Platform.runLater()` to marshal updates back from background work.
- Use `ObservableList`/`Property`-based data models for anything backing a UI control.
- Structure a desktop CRUD app in clear layers: data model, persistence, UI — verifying each independently.

## Interview Questions

1. What's the relationship between Stage, Scene, and the nodes inside a JavaFX application?
2. How does JavaFX property binding differ from manually keeping two values in sync, and what real bug does binding prevent?
3. Why doesn't a normal `try`/`catch` catch a JavaFX threading violation, and what's the correct fix?
4. How would you structure a CRUD desktop application to keep its data model, persistence, and UI concerns separate?
5. How would you verify a persistence layer actually works, beyond confirming a file was written?

(Detailed, verified answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [JavaFX Fundamentals](01-JavaFX-Fundamentals/README.md) | Stage, Scene, layouts, controls, real event handling |
| 02 | [Data Binding and Observable Collections](02-Data-Binding-and-Observable-Collections/README.md) | A real stale-display bug from manual sync; property binding; ObservableList |
| 03 | [JavaFX Threading Rules](03-JavaFX-Threading-Rules/README.md) | A real threading violation whose exception surfaces in a surprising place |
| 04 | [Building a CRUD Desktop App](04-Building-a-CRUD-Desktop-App/README.md) | A complete Task Manager: Create/Read/Update/Delete, real file persistence |

## Suggested Path

Work through 01 → 04 in order — Lesson 04 (the capstone CRUD app) directly builds on Lesson 01's controls, Lesson 02's property-based data model, and Lesson 03's safe threading practices. See also [04-Backend-Development](../04-Backend-Development/README.md) for the same CRUD concept applied to a web API instead of a desktop UI, and [13-Software-Architecture](../13-Software-Architecture/README.md) for the layered-architecture principle this module's CRUD app follows (data model, repository, UI as separate layers).

**Previous module:** [17-Git-and-GitHub](../17-Git-and-GitHub/README.md)
