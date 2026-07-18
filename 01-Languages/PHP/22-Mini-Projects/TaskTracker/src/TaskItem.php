<?php

declare(strict_types=1);

/**
 * A backed enum instead of a free-text "priority" string column -- invalid
 * values (a typo like "hihg") are rejected by the type system itself, at
 * the point of construction, rather than silently stored and discovered
 * later when something tries to compare against an unrecognized string.
 */
enum Priority: string
{
    case Low = 'low';
    case Medium = 'medium';
    case High = 'high';

    public function label(): string
    {
        return match ($this) {
            self::Low => 'Low',
            self::Medium => 'Medium',
            self::High => 'High',
        };
    }
}

enum Status: string
{
    case Pending = 'pending';
    case Done = 'done';
}

/**
 * An immutable value object -- once a TaskItem is built (always by
 * TaskRepository, from a row that's already in the database), nothing
 * about it changes in place. "Marking done" replaces the stored row and
 * hands back a brand-new TaskItem reflecting it, rather than mutating a
 * live object that other code might be holding a reference to.
 */
final class TaskItem
{
    public function __construct(
        public readonly int $id,
        public readonly string $title,
        public readonly Priority $priority,
        public readonly Status $status,
        public readonly string $createdAt,
    ) {
    }
}

final class TaskStats
{
    public function __construct(
        public readonly int $pending,
        public readonly int $done,
    ) {
    }

    public function total(): int
    {
        return $this->pending + $this->done;
    }
}
