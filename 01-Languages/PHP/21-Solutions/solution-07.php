<?php

declare(strict_types=1);

/**
 * Exercise 07 — Capstone: Library Checkout State Machine
 *
 * Combines: a backed enum for state, a trait mixed into two unrelated
 * classes for auto-incrementing ids, a match-based transition guard, a
 * custom Exception for invalid transitions, and named arguments.
 */
enum BookStatus: string
{
    case Available = 'available';
    case CheckedOut = 'checked_out';
    case Lost = 'lost';
}

/**
 * A trait, not a shared base class -- Book and Member have nothing else in
 * common, so forcing them under one abstract parent just to share an id
 * counter would be a worse fit than this purely horizontal mix-in.
 */
trait HasId
{
    private static int $nextId = 1;

    public readonly int $id;

    protected function assignId(): void
    {
        $this->id = self::$nextId++;
    }
}

final class Book
{
    use HasId;

    public BookStatus $status = BookStatus::Available;

    public function __construct(public readonly string $title)
    {
        $this->assignId();
    }
}

final class Member
{
    use HasId;

    public function __construct(public readonly string $name)
    {
        $this->assignId();
    }
}

final class InvalidTransitionException extends Exception
{
}

function checkout(Book $book, Member $member, ?DateTimeImmutable $dueDate = null): void
{
    // match($book->status) enforces the ONLY legal source state for this
    // transition -- CheckedOut/Lost fall through to a shared "reject" arm
    // rather than needing a separate condition written out for each.
    $book->status = match ($book->status) {
        BookStatus::Available => BookStatus::CheckedOut,
        BookStatus::CheckedOut, BookStatus::Lost => throw new InvalidTransitionException(
            "Cannot check out '{$book->title}' -- current status is {$book->status->value}",
        ),
    };

    $due = $dueDate ?? new DateTimeImmutable('+14 days');
    echo "Checked out '{$book->title}' to {$member->name} (id #{$member->id}), due {$due->format('Y-m-d')}.\n";
}

function returnBook(Book $book): void
{
    $book->status = match ($book->status) {
        BookStatus::CheckedOut => BookStatus::Available,
        BookStatus::Available, BookStatus::Lost => throw new InvalidTransitionException(
            "Cannot return '{$book->title}' -- current status is {$book->status->value}",
        ),
    };
    echo "Returned '{$book->title}'. Status is now {$book->status->value}.\n";
}

$book = new Book(title: "Refactoring");
$member = new Member(name: "Priya");

echo "Book #{$book->id} starts as {$book->status->value}.\n";

// Full successful cycle, called once with a named argument to exercise it.
checkout($book, $member, dueDate: new DateTimeImmutable('2026-08-01'));
echo "Status after checkout: {$book->status->value}\n";
returnBook($book);

// Deliberate invalid transition: check out a book that's already CheckedOut.
checkout($book, $member);
try {
    checkout($book, $member);
} catch (InvalidTransitionException $e) {
    echo "Caught expected InvalidTransitionException: {$e->getMessage()}\n";
}
