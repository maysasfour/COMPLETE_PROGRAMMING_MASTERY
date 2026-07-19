# 15 — Modules and Packages

[Back to course overview](../README.md) | [Previous: Concurrency](../14-Concurrency/README.md)

## Learning Objectives

- Organize code into `package`s, matching directory structure.
- Use `import` — wildcard, specific, and fully-qualified access without any import at all.
- Understand, conceptually, how sbt/Coursier manage real Scala project builds and dependencies beyond a single-file script.

## Prerequisites

[14-Concurrency](../14-Concurrency/README.md)

## Concept

A Scala `package` is a namespace, conventionally mirroring the source directory layout (`geometry/shapes/Shapes.scala` declares `package geometry.shapes`), exactly like Java. `import` brings names from another package into scope — as a single name, several names, or a wildcard (`*`) — but is never strictly required, since any name can always be reached via its fully-qualified path. Real multi-file Scala projects are built with **sbt** (Scala's native build tool) or dependencies fetched via **Coursier** (the same tool bootstrapping this course's toolchain) — this lesson's example uses `scalac`/`scala` directly on multiple files (no build tool needed to demonstrate the *packages* language feature itself), with sbt/Coursier's role explained in prose below.

## Package Declaration Matches Directory Structure

```scala
// file: geometry/shapes/Shapes.scala
package geometry.shapes

case class Circle(radius: Double):
  def area: Double = math.Pi * radius * radius
```

```scala
// file: geometry/Formatter.scala
package geometry

import geometry.shapes.{Circle, Rectangle}   // explicit import of only what's used

object Formatter:
  def describe(c: Circle): String = f"Circle(r=${c.radius}%.1f) area=${c.area}%.2f"
```

## Three Ways to Access a Name From Another Package

```scala
import geometry.shapes.*      // wildcard -- everything in geometry.shapes
import geometry.Formatter     // a single specific name

Formatter.describe(Circle(2.0))                    // via import
geometry.Formatter.describe(geometry.shapes.Circle(1.0))  // fully-qualified, NO import needed at all
```

## sbt and Coursier, Conceptually

- **sbt** is Scala's most common native build tool: it compiles multi-module projects, manages a `build.sbt` dependency list, runs tests, and packages artifacts — the Scala-ecosystem equivalent of Maven/Gradle for Java or Cargo for Rust.
- **Coursier** is the dependency-resolution engine underneath both sbt and this course's own toolchain bootstrap — it fetches JARs (and, as used directly in Lesson 16, arbitrary Java libraries like `sqlite-jdbc`) from Maven Central given a coordinate like `org.xerial:sqlite-jdbc:3.45.1.0`.
- A real project's `build.sbt` declares its package structure's root, dependencies (`libraryDependencies += "org.xerial" %% "sqlite-jdbc" % "3.45.1.0"`), and Scala version — this course stays dependency-minimal and invokes `scalac`/`scala` directly, but everything shown here scales unchanged into an sbt project.

## Detailed Example

See [geometry/shapes/Shapes.scala](geometry/shapes/Shapes.scala) (a nested package, `geometry.shapes`), [geometry/Formatter.scala](geometry/Formatter.scala) (`geometry`, importing from the nested package), and [ModulesAndPackages.scala](ModulesAndPackages.scala) (the entry point, using both a wildcard import and fully-qualified access to the same types).

## Run It

```bash
cd 01-Languages/Scala/15-Modules-and-Packages
scalac geometry/shapes/Shapes.scala geometry/Formatter.scala ModulesAndPackages.scala
scala run . --main-class modulesAndPackagesDemo
```

## Expected Output

```
--- using types from geometry.shapes, formatted via geometry.Formatter ---
Circle(r=2.0) area=12.57
Rectangle(3.0x4.0) area=12.00

--- fully-qualified access works too, without any import ---
fully-qualified: Circle(r=1.0) area=3.14
```

## Common Mistakes

- Forgetting that the package declaration must match the source directory layout by *convention* (not strictly enforced by the compiler the way Java does, but every real build tool and IDE assumes it) — mismatches cause confusing "class not found" issues in larger projects.
- Using wildcard imports (`import geometry.shapes.*`) pervasively in large codebases, making it unclear at a glance which package a given name actually came from — prefer specific imports except for small, well-known packages.
- Assuming `import` is required to use a name — it's purely a convenience; the fully-qualified path always works without any import, as shown directly above.

## Best Practices

- Prefer specific imports (`import geometry.shapes.{Circle, Rectangle}`) over wildcards in real projects for clarity, reserving wildcards for cases importing many related names from a small, well-understood package.
- Match package names to directory paths, matching this course's (and virtually every real Scala project's) convention.
- Use sbt for any project beyond a single file or two — it manages compilation order, incremental builds, dependency resolution (via Coursier underneath), and testing in one coherent tool.

## Real-World Usage

Every real Scala project beyond a tutorial uses sbt with a `build.sbt` declaring dependencies fetched via Coursier — for example, Lesson 16's `sqlite-jdbc` JDBC driver or Lesson 18's MUnit testing library would, in a real sbt project, be one `libraryDependencies` line rather than a manually-downloaded JAR, though both approaches resolve through the same underlying Coursier machinery.

## Summary

- Packages are namespaces conventionally matching directory structure; `import` brings names into scope but is never strictly required since fully-qualified access always works.
- Three names-from-another-package access styles were verified live: wildcard import, specific import, and fully-qualified path with no import.
- sbt (Scala's native build tool) and Coursier (the dependency resolver underneath it) manage real multi-file/multi-dependency Scala projects.

## Key Terms

- **Package** — a namespace, declared with `package name` at the top of a file, conventionally matching the source directory path.
- **sbt** — Scala's most common native build tool, managing compilation, dependencies, and testing for real projects.
- **Coursier** — the dependency-resolution engine that fetches JARs from Maven Central, used both underneath sbt and directly by this course's toolchain.

## Interview Questions

1. **Is `import` required to use a name from another package in Scala? What was verified to prove the answer?** — No — `import` is a convenience that brings a shorter name into scope; a fully-qualified path (`geometry.Formatter.describe(...)`) always works with zero imports. This was demonstrated directly: the same `Circle`/`Formatter` combination was used once via `import geometry.shapes.*` and once via fully-qualified paths with no import at all, producing correct, identical-style output both times.
2. **What roles do sbt and Coursier play in a real Scala project, and how does that relate to this lesson's dependency-minimal approach?** — sbt is the native build tool that compiles multi-module projects, tracks a `build.sbt` dependency manifest, and runs tests; Coursier is the dependency-resolution engine that actually fetches the JARs sbt (or this course's own toolchain bootstrap) declares. This lesson invokes `scalac`/`scala` directly across multiple files/packages to keep the *packages* language feature isolated from build-tool machinery, but the exact same package structure and imports would work unchanged inside a real sbt project with dependencies resolved by Coursier.

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
