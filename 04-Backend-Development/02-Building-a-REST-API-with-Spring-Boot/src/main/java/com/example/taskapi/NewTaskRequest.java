package com.example.taskapi;

/** The shape of a request body for creating/updating a task -- deliberately
 * separate from Task itself, since a client never supplies an id or (usually) done. */
public record NewTaskRequest(String title) {
}
