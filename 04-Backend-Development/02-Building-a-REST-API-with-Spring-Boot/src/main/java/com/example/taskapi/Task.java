package com.example.taskapi;

/**
 * A record (Java 16+) used as a simple, immutable data-transfer shape for JSON
 * request/response bodies -- Spring's built-in Jackson integration serializes
 * and deserializes this to/from JSON automatically, with no manual mapping code.
 */
public record Task(Long id, String title, boolean done) {
    // A record's canonical constructor, equals/hashCode/toString, and accessors
    // (id(), title(), done()) are all generated automatically.
}
