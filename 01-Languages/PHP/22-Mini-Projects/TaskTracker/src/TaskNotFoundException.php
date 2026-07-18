<?php

declare(strict_types=1);

/**
 * A custom, specific exception rather than a generic \RuntimeException --
 * a caller catching TaskNotFoundException by name knows exactly what went
 * wrong without inspecting the message string, and CLI code can catch just
 * this type without also swallowing unrelated runtime failures.
 */
final class TaskNotFoundException extends RuntimeException
{
    public function __construct(int $id)
    {
        parent::__construct("No task found with id {$id}.");
    }
}
