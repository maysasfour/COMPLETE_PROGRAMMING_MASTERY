# 15 — Modules and Packages

[Back to course overview](../README.md) | [Previous: Async and Concurrency](../14-Async-and-Concurrency/README.md)

## Learning Objectives

- Organize code with `package`, and understand — unlike C#'s namespaces — a Java package name **must** match its directory path.
- Understand JARs as Java's packaging format, and Maven/Gradle as build tools managing dependencies.
- Contrast with the C# course's Lesson 15, where namespaces are explicitly *not* tied to file/directory location.

## Prerequisites

[14-Async-and-Concurrency](../14-Async-and-Concurrency/README.md)

## Concept

A Java `package` is not just a logical grouping — it has a **mandatory, enforced relationship to directory structure**: a class in `package com.example.utils;` must physically live in a `com/example/utils/` directory. This is a deliberate, notable contrast with the C# course's Lesson 15, where namespaces are explicitly independent of file location.

## Packages and Directory Structure

```java
// com/example/utils/MathHelpers.java
package com.example.utils;

public class MathHelpers {
    public static int add(int a, int b) { return a + b; }
}
```

```java
// Main.java (at the project root, alongside the com/ directory)
import com.example.utils.MathHelpers;

public class Main {
    public static void main(String[] args) {
        System.out.println(MathHelpers.add(2, 3));
    }
}
```

```bash
java Main.java   # the single-file launcher finds com/example/utils/MathHelpers.java automatically
```

If `MathHelpers.java` were moved to a different directory without updating its `package` declaration to match, it would fail to compile — this enforced correspondence is what makes Java package names conventionally reverse-DNS-based (`com.example.utils`), doubling as a genuine, collision-resistant directory path.

## JARs, Maven, and Gradle

```bash
# Maven: dependencies declared in pom.xml, analogous to package.json
mvn compile
mvn package    # produces a .jar

# Gradle: dependencies declared in build.gradle
gradle build
```

A **JAR** (Java ARchive) is a zip file bundling compiled `.class` files (and resources) into one distributable unit — analogous to a compiled npm package or a .NET assembly. Maven and Gradle are Java's two dominant build tools, each managing dependency resolution (from Maven Central, the JVM ecosystem's equivalent of npm/NuGet), compilation, testing, and packaging.

## Detailed Example

See [Main.java](Main.java) and [com/example/utils/MathHelpers.java](com/example/utils/MathHelpers.java) — a genuine multi-file, multi-package example, proving the directory-package correspondence by having it actually work.

## Run It

```bash
cd 01-Languages/Java/15-Modules-and-Packages
java Main.java
```

## Expected Output

Running `java Main.java` prints the result of `MathHelpers.add(2, 3)`, a class defined in a different file, in a different package, in a required matching subdirectory.

## Common Mistakes

- Assuming Java packages are purely logical, like C#/JavaScript modules — they're enforced to match directory structure; moving a file without updating its `package` declaration (or vice versa) is a compile error.
- Confusing a JAR (a packaging format) with a package (a namespace/directory concept) — one JAR can contain classes from many different packages.

## Best Practices

- Follow the reverse-DNS package naming convention (`com.yourcompany.projectname`) for real projects, to avoid naming collisions with other libraries.
- Use Maven or Gradle (not manual `javac`/classpath management) for any project with dependencies.

## Real-World Usage

Every real Java project uses Maven or Gradle; reverse-DNS package naming is universal specifically because Maven Central (the central dependency repository) has no other collision-prevention mechanism across the enormous number of published libraries.

## Summary

- Java packages must match their directory structure exactly — a hard requirement, unlike C#'s location-independent namespaces.
- JARs are Java's packaging format; Maven/Gradle are the dominant build tools managing dependencies, analogous to npm/NuGet.
- Reverse-DNS package naming (`com.company.project`) exists specifically to avoid collisions given the enforced directory correspondence.

## Key Terms

- **Package** — Java's namespace mechanism, with a mandatory, enforced correspondence to directory structure.
- **JAR (Java ARchive)** — a zip-based bundle of compiled classes and resources, Java's packaging format.

## Interview Questions

1. **Is a Java package's name tied to its directory location, unlike a C# namespace?**
   Yes — this is a deliberate, enforced requirement in Java (unlike C#, where namespaces are purely logical and location-independent). A class declared `package com.example.utils;` must physically reside in a `com/example/utils/` directory relative to the source root, or the code fails to compile.

2. **What's the difference between a JAR and a package?**
   A package is a namespace/organizational construct tied to directory structure. A JAR is a packaging format — a zip archive bundling compiled `.class` files (potentially spanning many different packages) plus resources into one distributable unit, analogous to an npm package tarball or a .NET assembly.

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
