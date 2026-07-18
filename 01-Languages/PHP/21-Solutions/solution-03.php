<?php

declare(strict_types=1);

/**
 * Exercise 03 — Backed Enum Implementing an Interface
 *
 * Backed enums are NOT automatically JSON-serializable in any useful shape
 * (json_encode on a bare backed-enum case gives just its scalar value, with
 * no label) -- implementing JsonSerializable lets us control that shape
 * explicitly, the same mechanism any ordinary class would use.
 */
enum Priority: int implements JsonSerializable
{
    case Low = 1;
    case Medium = 2;
    case High = 3;

    public function label(): string
    {
        // Matching on $this (the enum case itself) rather than $this->value
        // reads more directly as "which case is this" -- match compares with
        // ===, and enum cases are singletons, so identity comparison works.
        return match ($this) {
            Priority::Low => 'Low',
            Priority::Medium => 'Medium',
            Priority::High => 'High',
        };
    }

    public function jsonSerialize(): mixed
    {
        return ['value' => $this->value, 'label' => $this->label()];
    }
}

$p = Priority::from(2);
echo "from(2) label: {$p->label()}\n";

// tryFrom() returns null on a bad backing value instead of throwing --
// the "safe" counterpart to from(), which throws ValueError for the same input.
$missing = Priority::tryFrom(99);
var_dump($missing);

try {
    Priority::from(99);
} catch (ValueError $e) {
    echo "from(99) threw as expected: {$e->getMessage()}\n";
}

foreach (Priority::cases() as $case) {
    echo "{$case->name} => {$case->label()} (backing value {$case->value})\n";
}

// json_encode() calls jsonSerialize() automatically because Priority
// implements JsonSerializable -- without that interface this would just
// dump the raw int, losing the label entirely.
echo json_encode([Priority::Low, Priority::High]) . "\n";
