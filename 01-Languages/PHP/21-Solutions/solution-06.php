<?php

declare(strict_types=1);

/**
 * Exercise 06 — Named Arguments
 *
 * Named arguments let a caller reach a later optional parameter without
 * repeating the value of every optional parameter that comes before it --
 * something a positional-only call cannot express at all.
 */
function buildInvitation(
    string $name,
    string $event,
    string $time = "18:00",
    bool $plusOne = false,
    ?string $note = null,
): string {
    $line = "{$name}, you're invited to {$event} at {$time}.";
    if ($plusOne) {
        $line .= " You may bring a guest.";
    }
    if ($note !== null) {
        $line .= " Note: {$note}";
    }
    return $line;
}

echo buildInvitation("Mays", "Launch Party", "19:30", true, "Bring your badge.") . "\n";

// Skips $time and $plusOne entirely (accepting their defaults) while still
// reaching $note -- impossible with positional-only arguments, which would
// require spelling out "18:00" and "false" explicitly just to get past them.
echo buildInvitation(name: "Ada", event: "Conference Dinner", note: "Vegetarian option available.") . "\n";

// Positional for the two required parameters, named for one optional one --
// PHP allows mixing, as long as positional arguments come first.
echo buildInvitation("Grace", "Team Offsite", plusOne: true) . "\n";

// Named arguments change HOW arguments are supplied, not WHETHER required
// parameters are still required -- omitting $name still triggers the same
// ArgumentCountError as a positional-only call would.
try {
    buildInvitation(event: "Missing-Name Party");
} catch (ArgumentCountError $e) {
    echo "Caught expected ArgumentCountError: {$e->getMessage()}\n";
}
